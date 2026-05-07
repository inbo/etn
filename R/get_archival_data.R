#' Get processed tag archival data
#'
#' @inheritParams get_animals
#' @param ... Additional arguments passed to `readr::read_csv()` when reading
#'   the csv files.
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
                              ...
                              ) {

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
    purrr::map(\(req) {httr2::req_retry(req, max_tries = 2)}) |>
    # purrr::map(\(req) {httr2::req_throttle(req,
    #                                        capacity = 10,
    #                                        fill_time_s = 20,
    #                                        realm = "https://www.lifewatch.be")}
    #            )
    purrr::map(\(req) {httr2::req_progress(req, type = "down")})


  ## Perform requests -------------------------------------------------------

  temp_dir <- withr::local_tempdir(pattern = "archivaldata_")
  temp_file_paths <- file.path(temp_dir, names(requests)) |>
    purrr::set_names(nm = names(requests))
  # responses <-
  #   httr2::req_perform_sequential(requests,
  #                                 paths = file.path(temp_dir, names(requests)),
  #                                 progress = progress)

  responses <-
    purrr::map2(requests, temp_file_paths, \(req, path) {
      httr2::req_perform(req, path = path)
    }, .progress = progress)
  # Parse responses ---------------------------------------------------------

  sensor_data <-
    temp_file_paths |>
    purrr::map(
    \(csv_path) {
        readr::read_csv(
          file = csv_path,
          show_col_types = FALSE,
                        col_types =
                          readr::cols(
                            tag_id = readr::col_character(),
                            timestamp_utc = readr::col_datetime(),
                            measurement_type = readr::col_character(),
                            measurement_value = readr::col_double(),
                            measurement_unit = readr::col_character()),
                        ...)
    }
  ) |>
    purrr::list_rbind(names_to = "uuid")


  ## Add metadata ------------------------------------------------------------

  # Add the metadata returned by get_archive_data_uuid() so at least the
  # function arguments are included in the returned  table as columns.

  sensor_data |>
    dplyr::left_join(uuid_tbl,
      by = c("uuid" = "converted_archival_file_uuid"),
      # Every metadata entry should match many sensor records
      relationship = "many-to-one"
    ) |>
    # Don't return the UUID
    dplyr::select(-"uuid")

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
