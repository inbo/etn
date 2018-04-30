#' Get raw detections data
#'
#' Download the raw detections data, with optional filters for the project,
#' the start- and enddate, the deployment station name and the transmitter/tag
#' identifier. Use the \code{limit} option to limit the data size.
#'
#' @param connection A valid connection with the ETN database.
#' @param network_project (character) One or more network projects.
#' @param animal_project (character) One or more animal projects.
#' @param start_date (character) Date in ISO 8601 format, e.g. 2018-01-01. Date
#' definition on month (e.g. 2018-03) or year (e.g. 2018) level are supported
#' as well.
#' @param end_date (character) Date in ISO 8601 format, e.g. 2018-01-01. Date
#' definition on month (e.g. 2018-03) or year (e.g. 2018) level are supported
#' as well.
#' @param deployment_station_name (character) One or more deployment station
#' names.
#' @param transmitter (character) One or more transmitter identifiers, also
#' referred to as `tag_code_space` identifiers
#' @param limit (integer) Limit the number of records to download. If NULL, all
#' records are downloaded.
#'
#' @return data.frame
#'
#' @export
#'
#' @examples
#' \dontrun{
#' get_detections(con, start_date = "2017", limit = 100)
#' get_detections(con, animal_project = c("phd_reubens"),
#'                start_date = "2011", end_date = "2012",
#'                limit = 10)
#' get_detections(con, deployment_station_name = c("Tsost"),
#'                limit = 100)
#' get_detections(con, transmitter = "A69-1601-28281",
#'                limit = 100)
#' get_detections(con, transmitter = c("A69-1303-65301"),
#'                limit = 50)
#' }
get_detections <- function(connection, network_project = NULL,
                           animal_project = NULL, start_date = NULL,
                           end_date = NULL, deployment_station_name = NULL,
                           transmitter = NULL, limit = NULL) {
  check_connection(connection)

  # check the network project inputs
  valid_network_projects <- get_projects(connection, project_type = "network") %>%
    pull(projectcode)
  check_null_or_value(network_project, valid_network_projects, "network_project")
  if (is.null(network_project)) {
    network_project = valid_network_projects
  }

  # check the animal project inputs
  valid_animal_projects <- get_projects(connection, project_type = "animal") %>%
    pull(projectcode)
  check_null_or_value(animal_project,  valid_animal_projects, "animal_project")
  if (is.null(animal_project)) {
    animal_project = valid_animal_projects
  }

  # check the start- and end date inputs
  if (is.null(start_date)) {
    # use an arbitrary early date for this project
    start_date <- check_datetime("1970", "start_date")
  } else {
    start_date <- check_datetime(start_date, "start_date")
  }
  if (is.null(end_date)) {
    # use today
    end_date <- as.character(Sys.Date())
  } else {
    end_date <- check_datetime(end_date, "end_date")
  }

  # check the station inputs
  valid_deployment_station_names <- deployment_station_names(connection)
  check_null_or_value(deployment_station_name, valid_deployment_station_names,
                      "deployment_station_name")
  if (is.null(deployment_station_name)) {
    deployment_station_name = valid_deployment_station_names
  }

  # check the transmitter tags inputs
  valid_transmitters <- transmitters(connection)
  check_null_or_value(transmitter, valid_transmitters,
                      "transmitter")
  if (is.null(transmitter)) {
    transmitter = valid_transmitters
  }

  # check the limit input - remark: LIMIT NULL is in postgres LIMIT ALL
  if (!is.null(limit)) {
    assert_that(is.number(limit))
  }

  detections_query <- glue_sql(
    "SELECT * FROM vliz.detections_view
    WHERE network_project_code IN ({network_project*})
      AND animal_project_code IN ({animal_project*})
      AND datetime > {start_date}
      AND datetime < {end_date}
      AND deployment_station_name IN ({station_name*})
      AND transmitter IN ({transmitter*})
    LIMIT {nrows}",
    network_project = network_project,
    animal_project = animal_project,
    start_date = start_date,
    end_date = end_date,
    station_name = deployment_station_name,
    transmitter = transmitter,
    nrows = as.character(limit),
    .con = connection
  )
  detections <- dbGetQuery(connection, detections_query)
  detections

}

#' Support function to get unique set of deployment_station_name
#'
#' This function retrieves all unique deployment_station_name
#' @param connection A valid connection to ETN database.
#'
#' @export
#'
#' @return A vector of all deployment_station_names present in vliz.deployments.
deployment_station_names <- function(connection) {

  query <- glue_sql(
    "SELECT DISTINCT station_name FROM vliz.deployments",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data %>%
    pull(station_name)
}

#' Support function to get unique set of transmitters (tag_code_space)
#'
#' This function retrieves all unique transmitters
#'
#' @param connection A valid connection to ETN database.
#'
#' @export
#'
#' @return A vector of all transmitter present in vliz.tags.
transmitters <- function(connection) {

  query <- glue_sql(
    "SELECT DISTINCT tag_code_space FROM vliz.tags",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data %>%
    pull(tag_code_space)
}

