#' Get processed tag archival data
#'
#' @inheritParams get_animals
#'
#' @returns A data.frame with the archival data values.
#' @export
#'
#' @examplesIf interactive() & credentials_are_set()
#'
get_archival_data <- function(tag_serial_number = NULL,
                              animal_id = NULL,
                              animal_project_code = NULL,
                              progress = TRUE,
                              return_as = c("tibble", "arrow")
                              ) {


  # Validate inputs ---------------------------------------------------------
  return_as <- rlang::arg_match(return_as)

  # Fetch file uuids --------------------------------------------------------
  uuid_tbl <-
    get_archival_data_uuid(tag_serial_number, animal_id, animal_project_code)
  uuids <-
    uuid_tbl |>
    dplyr::pull("converted_archival_file_uuid") |>
    # Sometimes, multiple uuids are passed. We only need to download every file
    # once.
    unique()

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

  responses <-
    purrr::map2(requests, temp_file_paths, \(req, path) {
      if (file.exists(path) & file.size(path) > 0) {
        NULL
      } else {
        httr2::req_perform(req, path = path)
      }
    }, .progress = progress)

  # Parse responses ---------------------------------------------------------

  # drop csv files that have a header but no records (issue in view), this
  # shouldn't really happen. It's a bug in the view. Arrow can't handle reading
  # this file, duckdb and readr can.
  temp_file_paths <- purrr::keep(temp_file_paths, \(filepath){
    length(readLines(filepath, n = 2)) > 1
  })

  # sensor_data <-
  #   temp_file_paths |>
  #   purrr::map(
  #   \(csv_path) {
  #       readr::read_csv(
  #         file = csv_path,
  #         show_col_types = FALSE,
  #                       col_types =
  #                         readr::cols(
  #                           tag_id = readr::col_character(),
  #                           timestamp_utc = readr::col_datetime(),
  #                           measurement_type = readr::col_character(),
  #                           measurement_value = readr::col_double(),
  #                           measurement_unit = readr::col_character()))
  #   }
  # ) |>
  #   purrr::list_rbind(names_to = "uuid")

  csv_schema <- arrow::schema(
    tag_id            = arrow::string(),
    timestamp_utc     = arrow::timestamp("s", timezone = "UTC"),
    measurement_type  = arrow::string(),
    measurement_value = arrow::float64(),
    measurement_unit  = arrow::string()
  )

  # arrow only
  sensor_data <-
    arrow::open_csv_dataset(
    temp_file_paths,
    schema = csv_schema,
    # since we provide a schema, we should skip reading the header
    skip = 1
  ) |>
    dplyr::mutate(uuid = stringr::str_sub(arrow::add_filename(), start = 49))

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
      relationship = "many-to-one"
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
