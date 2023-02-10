#' Get acoustic detections data
#'
#' Get data for acoustic detections, with options to filter results. Use
#' `limit` to limit the number of returned records.
#'
#' @param credentials Login credentials to the ETN database, as created by
#'   `get_credentials()`
#' @param start_date Character. Start date (inclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param end_date Character. End date (exclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param acoustic_tag_id Character (vector). One or more acoustic tag ids.
#' @param animal_project_code Character (vector). One or more animal project
#'   codes. Case-insensitive.
#' @param scientific_name Character (vector). One or more scientific names.
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
#' @param receiver_id Character (vector). One or more receiver identifiers.
#' @param station_name Character (vector). One or more deployment station
#'   names.
#' @param limit Logical. Limit the number of returned records to 100 (useful
#'   for testing purposes). Defaults to `FALSE`.
#'
#' @return A tibble with acoustic detections data, sorted by `acoustic_tag_id`
#'  and `date_time`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @examples
#' # Set default connection variable
#' credentials <- connect_to_etn()
#'
#' # Get limited sample of acoustic detections
#' get_acoustic_detections(con, limit = TRUE)
#'
#' # Get all acoustic detections from a specific animal project
#' get_acoustic_detections(con, animal_project_code = "2014_demer")
#'
#' # Get 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   con,
#'   animal_project_code = "2014_demer",
#'   start_date = "2015",
#'   end_date = "2016",
#' )
#'
#' # Get April 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   con,
#'   animal_project_code = "2014_demer",
#'   start_date = "2015-04",
#'   end_date = "2015-05",
#' )
#'
#' # Get April 24, 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   con,
#'   animal_project_code = "2014_demer",
#'   start_date = "2015-04-24",
#'   end_date = "2015-04-25",
#' )
#'
#' # Get acoustic detections for a specific tag at two specific stations
#' get_acoustic_detections(
#'   con,
#'   acoustic_tag_id = "A69-1601-16130",
#'   station_name = c("de-9", "de-10")
#' )
#'
#' # Get acoustic detections for a specific species, receiver and acoustic project
#' get_acoustic_detections(
#'   con,
#'   scientific_name = "Rutilus rutilus",
#'   receiver_id = "VR2W-124070",
#'   acoustic_project_code = "demer"
#' )
get_acoustic_detections_api <- function(credentials = etn:::get_credentials(),
                                        start_date = NULL,
                                        end_date = NULL,
                                        acoustic_tag_id = NULL,
                                        animal_project_code = NULL,
                                        scientific_name = NULL,
                                        acoustic_project_code = NULL,
                                        receiver_id = NULL,
                                        station_name = NULL,
                                        limit = FALSE) {
  # I want the following block to be universal for all API functions, so
  # independent of the function name which is part of the URL

  ## first retrieve the arguments from the function environment, before we
  ## create any other objects, parse it as json primitives because that's what
  ## opencpu expects
  payload <- #as_json_primitive(
    return_parent_arguments()
    #)
  ## get rid of _api in the function name, etnservice doesn't use this suffix
  function_identity <-
    gsub("_api", "", deparse(match.call()[[1]]))

  endpoint <-
    sprintf(
      "https://opencpu.lifewatch.be/library/etnservice/R/%s",
      function_identity
    )
  ## OPENCPU uses JSON primitives, so we have to fetch and convert the function
  ## arguments before sending them as the request body
  response <-
    httr::POST(
      url = paste(endpoint, "json", sep = "/"),
      body = payload,
      encode = "json"
    )



  # Check if the response has the expected content type, if the server returns
  # an error stop and return it

  # TODO if it's text/html, its probably an error message: forward as an error
  # in check_content_type?
  check_content_type(response, "application/json")

  # If request was not successful, generate a warning
  # ISSUE conflict with check_content_type()
  httr::warn_for_status(response, "submit request to API server")
  # Parse server response JSON to a vector
  # all etn functions output tibbles instead of data.frames
  response %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyVector = TRUE) %>%
    dplyr::as_tibble() %>%
    readr::format_csv() %>% #abuse parser to get column classes back :()
    readr::read_csv()
}
