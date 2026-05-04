#' Get processed tag archival data
#'
#' @inheritParams get_animals
#'
#' @returns
#' @export
#'
#' @examplesIf interactive() & credentials_are_set()
#'
get_archival_data <- function(tag_serial_number = NULL,
                              animal_id = NULL,
                              animal_project_code = NULL
                              ) {

  # Fetch file uuids --------------------------------------------------------
  uuids <-
    get_archival_data_uuid(tag_serial_number, animal_id, animal_project_code) |>
    dplyr::pull("converted_archival_file_uuid")


  # Read files from web -----------------------------------------------------

  ## Prepare requests -------------------------------------------------------

  requests <-
    purrr::map(
      uuids,
      \(uuid) {
        httr2::request("https://www.lifewatch.be") |>
          httr2::req_url_path_append("etn", "archival-data", "file") |>
          httr2::req_url_path_append(uuid)
      }
    ) |>
    purrr::map(\(req) {httr2::req_retry(max_tries = 2)}) |>
    purrr::map(\(req) {httr2::req_throttle(req,
                                           capacity = 5,
                                           fill_time_s = 20,
                                           realm = "https://www.lifewatch.be")}
               )


  ## Perform requests -------------------------------------------------------

  responses <-
    httr2::req_perform_parallel(requests)

  # Parse responses ---------------------------------------------------------

  sensor_data |>
    purrr::map(
    responses,
    \(response) {
      httr2::resp_body_raw(response) |>
        readr::read_csv()
    }
  ) |>
    purrr::list_rbind()

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
#' @examplesIf interactive() & credentials_are_set() get_archival_data_uuid()
#'   get_archival_data_uuid(tag_serial_number = "22035610")
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
