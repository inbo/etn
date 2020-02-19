#' Get detections data
#'
#' Get detections data, with options to filter on animal project, network
#' project, start- and enddate, deployment station name and/or tag identifier.
#' Use `limit` to limit the number of returned records
#'
#' @param connection A valid connection to the ETN database.
#' @param network_project (character) One or more network projects.
#' @param animal_project (character) One or more animal projects.
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
#' @param limit (integer) The number of records to return (useful for testing
#'   purposes).
#'
#' @return A tibble (tidyverse data.frame).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr pull %>%
#' @importFrom rlang .data
#' @importFrom assertthat assert_that is.number
#' @importFrom tibble as_tibble
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # Get detections filtered by start year and limited to 100 records
#' get_detections(con, start_date = "2017", limit = 100)
#'
#' # Get detections within a time frame for a specific animal project and
#' # network project
#' get_detections(con, animal_project = "phd_reubens",
#'                network_project = "thornton", start_date = "2011-01-28",
#'                end_date = "2011-02-01")
#'
#' # Get detections for a specific animal project at specific stations
#' get_detections(con, animal_project = "phd_reubens",
#'                station_name = c("R03", "R05"))
#'
#' # Get detectios for a specific tag
#' get_detections(con, tag_id = "A69-1303-65302")
#'
#' # Get detections for a specific receiver during a specific time period
#' get_detections(con, receiver_id = "VR2W-122360", start_date = "2015-12-03",
#'                end_date = "2015-12-05")
#' # Get detections for a specific species during a given period
#' get_detections(con, scientific_name = "Anguilla anguilla",
#'                start_date = "2015-12-03",
#'                end_date = "2015-12-05")
#' }
get_detections <- function(connection, network_project = NULL,
                           animal_project = NULL, start_date = NULL,
                           end_date = NULL, station_name = NULL,
                           tag_id = NULL, receiver_id = NULL,
                           scientific_name = NULL, limit = NULL) {
  check_connection(connection)

  # check the network project inputs
  valid_network_projects <- get_projects(connection, project_type = "network") %>%
    pull(.data$projectcode)
  check_null_or_value(network_project, valid_network_projects, "network_project")
  if (is.null(network_project)) {
    network_project = valid_network_projects
  }

  # check the animal project inputs
  valid_animal_projects <- get_projects(connection, project_type = "animal") %>%
    pull(.data$projectcode)
  check_null_or_value(animal_project,  valid_animal_projects, "animal_project")
  if (is.null(animal_project)) {
    animal_project = valid_animal_projects
  }

  # check the start- and end date inputs
  if (is.null(start_date)) {
    # use an arbitrary early date for this project
    start_date <- check_date_time("1970", "start_date")
  } else {
    start_date <- check_date_time(start_date, "start_date")
  }
  if (is.null(end_date)) {
    # use today
    end_date <- as.character(Sys.Date())
  } else {
    end_date <- check_date_time(end_date, "end_date")
  }

  # Check the station inputs
  valid_station_names <- station_names(connection)
  check_null_or_value(station_name, valid_station_names,
                      "station_name")
  if (is.null(station_name)) {
    station_name = valid_station_names
  }

  # Check the tags inputs
  valid_tags <- tag_ids(connection)
  check_null_or_value(tag_id, valid_tags,
                      "tag_id")
  if (is.null(tag_id)) {
    tag_id = valid_tags
  }

  # Check the receiver inputs
  valid_receivers <- get_receivers(connection) %>%
    pull(.data$receiver_id)
  check_null_or_value(receiver_id, valid_receivers,
                      "receiver_id")
  if (is.null(receiver_id)) {
    receiver_id = valid_receivers
  }

  # Valid scientific names
  valid_animals <- scientific_names(connection)
  check_null_or_value(scientific_name, valid_animals, "scientific_name")
  if (is.null(scientific_name)) {
    scientific_name = valid_animals
  }

  # Check the limit input
  if (is.null(limit)) {
    sub_query <- glue_sql("LIMIT ALL", .con = connection)
  } else {
    assert_that(is.number(limit))
    sub_query <- glue_sql("LIMIT {limit}",
                          limit = as.character(limit),
                          .con = connection)
  }

  detections_query <- glue_sql("
    SELECT *
    FROM vliz.detections_view2
    WHERE network_project_code IN ({network_project*})
      AND animal_project_code IN ({animal_project*})
      AND date_time > {start_date}
      AND date_time < {end_date}
      AND station_name IN ({station_name*})
      AND tag_id IN ({tag_id*})
      AND receiver_id IN ({receiver_id*})
      AND scientific_name IN ({scientific_name*})
    {sub_query}
    ",
    nrows = limit,
    .con = connection
  )
  detections <- dbGetQuery(connection, detections_query)
  as_tibble(detections)
}

#' Support function to get unique set of station_names
#'
#' Get unique station_names
#'
#' @param connection A valid connection to the ETN database.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all station_names present in vliz.deployments_view2.
station_names <- function(connection) {

  query <- glue_sql("
    SELECT DISTINCT station_name FROM vliz.deployments_view2
    ", .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$station_name
}

#' Support function to get unique set of tag_ids
#'
#' Get unique tag_ids
#'
#' @param connection A valid connection to the ETN database.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all tags present in vliz.tags_view2.
tag_ids <- function(connection) {

  query <- glue_sql("
    SELECT DISTINCT tag_id FROM vliz.tags_view2
    ", .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$tag_id
}
