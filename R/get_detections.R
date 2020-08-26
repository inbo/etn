#' Get detections data
#'
#' Get detections data, with options to filter on animal project, network
#' project, start- and enddate, deployment station name and/or tag identifier.
#' Use `limit` to limit the number of returned records
#'
#' @param connection A valid connection to the ETN database.
#' @param application_type (string) `acoustic_telemetry` or `cpod`.
#' @param network_project_code (character) One or more network projects.
#' @param animal_project_code (character) One or more animal projects.
#' @param start_date (character) Date in ISO 8601 format, e.g. 2018-01-01. Date
#'   selection on month (e.g. 2018-03) or year (e.g. 2018) are supported as
#'   well.
#' @param end_date (character) Date in ISO 8601 format, e.g. 2018-01-01. Date
#'   selection on month (e.g. 2018-03) or year (e.g. 2018) are supported as
#'   well.
#' @param station_name (character) One or more deployment station names.
#' @param tag_id (character) One or more tag identifiers.
#' @param receiver_id (character) One or more receiver identifiers.
#' @param scientific_name (character) One or more scientific names.
#' @param limit (logical) Limit the number of returned records to 100 (useful for testing
#'   purposes). Default: `TRUE`.
#'
#' @return A tibble (tidyverse data.frame).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr pull %>% as_tibble
#' @importFrom rlang .data
#' @importFrom assertthat assert_that is.number
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # Get detections filtered by start year, limited to 100 records by default
#' get_detections(con, start_date = "2017")
#'
#' # Get detections for a specific application type, limited to 100 records
#' get_detections(con, application_type = "acoustic_telemetry")
#'
#' # Get detections within a time frame for a specific animal project and
#' # network project
#' get_detections(
#'   con,
#'   animal_project_code = "phd_reubens",
#'   network_project_code = "thornton", start_date = "2011-01-28",
#'   end_date = "2011-02-01",
#'   limit = FALSE
#' )
#'
#' # Get detections for a specific animal project at specific stations
#' get_detections(
#'   con,
#'   animal_project_code = "phd_reubens",
#'   station_name = c("R03", "R05"),
#'   limit = FALSE
#' )
#'
#' # Get detections for a specific tag
#' get_detections(
#'   con,
#'   tag_id = "A69-1303-65302",
#'   limit = FALSE
#' )
#'
#' # Get detections for a specific receiver during a specific time period
#' get_detections(
#'   con,
#'   receiver_id = "VR2W-122360",
#'   start_date = "2015-12-03",
#'   end_date = "2015-12-05",
#'   limit = FALSE
#' )
#' # Get detections for a specific species during a given period
#' get_detections(
#'   con,
#'   scientific_name = "Anguilla anguilla",
#'   start_date = "2015-12-03",
#'   end_date = "2015-12-05",
#'   limit = FALSE
#' )
#' }
get_detections <- function(connection = con,
                           application_type = NULL,
                           network_project_code = NULL,
                           animal_project_code = NULL,
                           start_date = NULL,
                           end_date = NULL,
                           station_name = NULL,
                           tag_id = NULL,
                           receiver_id = NULL,
                           scientific_name = NULL,
                           limit = TRUE) {
  # Check connection
  check_connection(connection)

  # Check application_type
  if (is.null(application_type)) {
    application_type_query <- "True"
  } else {
    check_value(application_type, c("acoustic_telemetry", "cpod"), "application_type")
    application_type_query <- glue_sql("application_type IN ({application_type*})", .con = connection)
  }

  # Check network_project_code
  if (is.null(network_project_code)) {
    network_project_code_query <- "True"
  } else {
    valid_network_project_codes <- list_network_project_codes(connection)
    check_value(network_project_code, valid_network_project_codes, "network_project_code")
    network_project_code_query <- glue_sql("network_project_code IN ({network_project_code*})", .con = connection)
  }

  # Check animal_project_code
  if (is.null(animal_project_code)) {
    animal_project_code_query <- "True"
  } else {
    valid_animal_project_codes <- list_animal_project_codes(connection)
    check_value(animal_project_code, valid_animal_project_codes, "animal_project_code")
    animal_project_code_query <- glue_sql("animal_project_code IN ({animal_project_code*})", .con = connection)
  }

  # Check start_date
  if (is.null(start_date)) {
    start_date_query <- "True"
  } else {
    start_date <- check_date_time(start_date, "start_date")
    start_date_query <- glue_sql("date_time >= {start_date}", .con = connection)
  }

  # Check end_date
  if (is.null(end_date)) {
    end_date_query <- "True"
  } else {
    end_date <- check_date_time(end_date, "end_date")
    end_date_query <- glue_sql("date_time <= {end_date}", .con = connection)
  }

  # Check station_name
  if (is.null(station_name)) {
    station_name_query <- "True"
  } else {
    valid_station_names <- list_station_names(connection)
    check_value(station_name, valid_station_names, "station_name")
    station_name_query <- glue_sql("station_name IN ({station_name*})", .con = connection)
  }

  # Check tag_id
  if (is.null(tag_id)) {
    tag_id_query <- "True"
  } else {
    valid_tag_ids <- list_tag_ids(connection)
    check_value(tag_id, valid_tag_ids, "tag_id")
    tag_id_query <- glue_sql("tag_id IN ({tag_id*})", .con = connection)
  }

  # Check receiver_id
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
    valid_receiver_ids <- list_receiver_ids(connection)
    check_value(receiver_id, valid_receiver_ids, "receiver_id")
    receiver_id_query <- glue_sql("receiver_id IN ({receiver_id*})", .con = connection)
  }

  # Check scientific_name
  if (is.null(scientific_name)) {
    scientific_name_query <- "True"
  } else {
    scientific_name_ids <- list_scientific_names(connection)
    check_value(scientific_name, scientific_name_ids, "scientific_name")
    scientific_name_query <- glue_sql("scientific_name IN ({scientific_name*})", .con = connection)
  }

  # Check limit
  if (limit) {
    limit_query <- glue_sql("LIMIT 100", .con = connection)
  } else {
    limit_query <- glue_sql("LIMIT ALL}", .con = connection)
  }

  # Build query
  query <- glue_sql("
    SELECT
      *
    FROM
      vliz.detections_view2
    WHERE
      {application_type_query}
      AND {network_project_code_query}
      AND {animal_project_code_query}
      AND {start_date_query}
      AND {end_date_query}
      AND {station_name_query}
      AND {tag_id_query}
      AND {receiver_id_query}
      AND {scientific_name_query}
    {limit_query}
    ", .con = connection)
  detections <- dbGetQuery(connection, query)
  as_tibble(detections)
}
