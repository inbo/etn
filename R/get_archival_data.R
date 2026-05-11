#' Get processed tag archival data
#'
#' @inheritParams get_animals
#' @inheritParams get_acoustic_detections
#' @param animal_project_code `r lifecycle::badge("experimental")` Character
#'   (vector). One or more animal project codes. Case-insensitive. An animal
#'   project can contain many gigabytes of archival data. Downloading this data
#'   may take a while and  exceed the available RAM or Storage of your computer
#' @param return_as `r lifecycle::badge("experimental")` Character. One of "tibble" or "arrow". Whether to return the
#'   data as an in memory tibble or an out of memory arrow dataset. The latter
#'   is recommended for large datasets, but requires more disk space and may be
#'   slower to query. When selecting "arrow" keep in mind that the downloaded
#'   data will remain stored on your computer until R is restarted.
#'
#' @returns A data.frame with the archival data values.
#' @export
#'
#' @examplesIf interactive() & credentials_are_set()
#'
get_archival_data <- function(tag_serial_number = NULL,
                              animal_id = NULL,
                              animal_project_code = NULL,
                              limit = FALSE,
                              progress = TRUE,
                              return_as = c("tibble", "arrow")
                              ) {


  # Validate inputs ---------------------------------------------------------
  return_as <- rlang::arg_match(return_as)

  # Control progress reporting ----------------------------------------------
  # Don't show the progress bar when testing: clutters up console and CI output
  if (is_testing()) {
    progress <- FALSE
  }
  # Only show the progress bar if less than 50% of records have been fetched in
  # 24h: workaround to control progress reporting
  if (!progress) {
    withr::local_options(cli.progress_show_after = 60 * 60 * 24)
  }

  # Fetch file uuids --------------------------------------------------------
  # Sometimes, multiple uuids are passed. We only need to download every file
  # once.
  uuid_tbl <-
    get_archival_data_uuid(tag_serial_number, animal_id, animal_project_code) |>
    dplyr::distinct()

  uuids <-
    uuid_tbl |>
    dplyr::pull("converted_archival_file_uuid") |>
    unique()

  ## Stop if no data found --------------------------------------------------
  if(length(uuids) == 0){
    cli::cli_abort(
      "No archival data found for the provided filters.",
      class = "archival_data_not_found"
    )
  }

  ## Warn if some filters return no data ------------------------------------
  used_filters <- rlang::call_args(rlang::call_match()) |>
    purrr::map(eval)
  # drop arguments that are not columns
  used_filters <-
    purrr::keep_at(used_filters, names(used_filters) %in% colnames(uuid_tbl))

  # Find query values that we didn't find files for
  indexes_no_file_found <-
    purrr::imap(used_filters, ~ !.x %in% dplyr::pull(uuid_tbl, .y))

  values_no_file_found <-
    used_filters |>
    purrr::imap(~ purrr::keep_at(.x, purrr::chuck(indexes_no_file_found, .y))) |>
    purrr::compact()

  if (length(values_no_file_found) > 0) {
    cli::cli_warn(
      c("No archival data was found for:",
        "x" = purrr::imap_chr(
          values_no_file_found,
          ~ glue::glue("{.y}: {glue::glue_collapse(.x, sep = ', ')}")
        ) |>
          # Drop names so CLI can do in line formatting instead
          purrr::set_names(nm = NULL)
      ),
      class = "archival_data_not_found_for_filter"
    )
  }

  # Read files from web -----------------------------------------------------

  ## Prepare requests -------------------------------------------------------
  requests <-
    purrr::set_names(uuids, nm = uuids) |>
    purrr::map(
      \(uuid) {
        httr2::request("https://www.lifewatch.be") |>
          httr2::req_url_path_append("etn", "archival-data", "file") |>
          httr2::req_url_path_append(uuid)
      }
    ) |>
    purrr::map(\(req) {httr2::req_retry(req, max_tries = 2)})

  # If limit is TRUE, we only want to fetch a single file.
  if(limit){
    requests <- requests[1]
  }

  ## Perform requests -------------------------------------------------------

  # We don't need to store csv files on disk after the function call is
  # completed if we are returning an in memory tibble, we do if we are
  # returniing an out of memory object.
  switch(return_as,
    tibble = {
      temp_dir <- withr::local_tempdir(
        pattern = "archivaldata_"
      )
    },
    arrow = temp_dir <- tempdir()
  )

  temp_file_paths <- file.path(temp_dir, names(requests)) |>
    purrr::set_names(nm = names(requests))

  if (limit) {
    # Only fetch the first file
    requests |>
      purrr::map(httr2::req_perform_connection) |>
      # Read the header, and 100 lines
      purrr::map(\(req) {httr2::resp_stream_lines(req, lines = 101)}) |>
      # Write to temp file, same as normally
      purrr::walk2(temp_file_paths, \(lines, path) {readr::write_lines(lines, file = path)})
  } else {
    responses <-
      purrr::map2(requests, temp_file_paths, \(req, path) {
        if (file.exists(path) & file.size(path) > 0) {
          NULL
        } else {
          httr2::req_perform(req, path = path)
        }
      }, .progress = ifelse(progress, "Downloading", FALSE))
  }

  # Parse responses ---------------------------------------------------------

  # drop csv files that have a header but no records (issue in view), this
  # shouldn't really happen. It's a bug in the view. Arrow can't handle reading
  # this file, duckdb and readr can.
  temp_file_paths <- purrr::keep(temp_file_paths, \(filepath){
    length(readLines(filepath, n = 2)) > 1
  })

  csv_schema <- arrow::schema(
    tag_id            = arrow::string(),
    timestamp_utc     = arrow::timestamp("s", timezone = "UTC"),
    measurement_type  = arrow::string(),
    measurement_value = arrow::float64(),
    measurement_unit  = arrow::string()
  )

  # Use arrow to process and combine the local csv files out of memory
  sensor_data <-
    arrow::open_csv_dataset(
    temp_file_paths,
    schema = csv_schema,
    # since we provide a schema, we should skip reading the header
    skip = 1
  ) |>
    # Take the last 36 characters of the filename (length of a UUID)
    dplyr::mutate(uuid = stringr::str_sub(arrow::add_filename(), start = -36L))

  # also duckdb
  # duckdbfs::open_dataset(sources = temp_file_paths,
  #                        schema = csv_schema,
  #                        format = "csv",
  #                        filename = TRUE) |>
  #   dplyr::mutate(uuid = stringr::str_sub(filename, start = 49)) |>
  #   dplyr::collect()

  # # duckdb, no httr2
  # uuid_tbl_ddb <- arrow::to_duckdb(uuid_tbl,
  #                                  con = duckdbfs::cached_connection())
  #
  # requests |>
  #   # get urls, you'd just make them as urls instead of going url to request to
  #   # url
  #   purrr::map_chr(httr2::req_get_url) |>
  #   duckdbfs::open_dataset(format = "csv",
  #                          schema = csv_schema,
  #                          filename = TRUE) |>
  #   dplyr::mutate(uuid = stringr::str_sub(filename, start = 49)) |>
  #   dplyr::left_join(uuid_tbl_ddb,
  #                    by = c("uuid" = "converted_archival_file_uuid")
  #   ) |>
  #   # Don't return the UUID
  #   dplyr::select(-c("uuid", "filename")) |>
  #   dplyr::collect()


  ## Add metadata ------------------------------------------------------------

  # Add the metadata returned by get_archive_data_uuid() so at least the
  # function arguments are included in the returned  table as columns.

  sensor_data <-
    sensor_data |>
    dplyr::left_join(uuid_tbl,
      by = c("uuid" = "converted_archival_file_uuid"),
      # Every metadata entry should match many sensor records
      # relationship = "many-to-one"
    ) |>
    # Don't return the UUID
    dplyr::select(-"uuid")

  # Return object -----------------------------------------------------------

  switch (return_as,
    arrow = sensor_data,
    tibble = dplyr::collect(sensor_data)
  )

}

#' Fetch a table with UUID references to archival data files
#'
#' Archival data is stored in csv files hosted on lifewatch.com. To fetch these
#' we must first query ETN for uuids that are needed to build the paths to read
#' these csv files.
#'
#' @inheritParams get_animals
#'
#' @returns A tibble with a column `converted_archival_file_uuid` that contains
#'   the UUID pointing to the archival data csv file. Other columns are:
#'   `animal_id`, `tag_serial_number`, and `animal_project_code`.
#'
#' @family helper functions
#' @examplesIf interactive() & credentials_are_set()
#' get_archival_data_uuid()
#' get_archival_data_uuid(tag_serial_number = "22035610")
get_archival_data_uuid <- function(
  tag_serial_number = NULL,
  animal_id = NULL,
  animal_project_code = NULL
) {
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(protocol = select_protocol())

  # Return uuid table
  out
}
