#' Get raw detections data
#'
#' Get the raw detections data, with optional filters for the project, the
#' start- and enddate, the deployment station name and the transmitter/tag
#' identifier. Use the \code{limit} option to limit the data size.
#'
#' @param connection A valid connection with the ETN database.
#' @param network_project (character) One or more network projects.
#' @param animal_project (character) One or more animal projects.
#' @param start_date (character) Date in ISO 8601 format, e.g. 2018-01-01. Date
#'   definition on month (e.g. 2018-03) or year (e.g. 2018) level are supported
#'   as well.
#' @param end_date (character) Date in ISO 8601 format, e.g. 2018-01-01. Date
#'   definition on month (e.g. 2018-03) or year (e.g. 2018) level are supported
#'   as well.
#' @param deployment_station_name (character) One or more deployment station
#'   names.
#' @param transmitter (character) One or more transmitter identifiers, also
#'   referred to as `tag_code_space` identifiers
#' @param receiver (character) One or more receiver identifiers.
#' @param scientific_name (character) One or more scientific names.
#' @param limit (integer) Limit the number of records to download. If NULL, all
#'   records are downloaded.
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
#' # Get detection data filtered by the start year
#' get_detections(con, start_date = "2017", limit = 100)
#'
#' # Get detection data within time frame for specific animal project and
#' # network project
#' get_detections(con, animal_project = "phd_reubens",
#'                network_project = "thornton", start_date = "2011-01-28",
#'                end_date = "2011-02-01")
#'
#' # Get detection data for specific animal project and station names and a
#' # limit about the number of returned records
#' get_detections(con, animal_project = "phd_reubens",
#'                deployment_station_name = c("R03", "R05"), limit = 100)
#'
#' # Get detection data for specific transmitter
#' get_detections(con, transmitter = "A69-1303-65302")
#'
#' # Get detection data for specific receiver during specific time period
#' get_detections(con, receiver = "VR2W-122360", start_date = "2015-12-03",
#'                end_date = "2015-12-05")
#' # Get detection data for a specific species during a given period
#' get_detections(con, scientific_name = "Anguilla anguilla",
#'                start_date = "2015-12-03",
#'                end_date = "2015-12-05")
#' }
get_detections <- function(connection, network_project = NULL,
                           animal_project = NULL, start_date = NULL,
                           end_date = NULL, deployment_station_name = NULL,
                           transmitter = NULL, receiver = NULL,
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

  # check the receiver inputs
  valid_receivers <- get_receivers(connection) %>%
    pull(.data$receiver)
  check_null_or_value(receiver, valid_receivers,
                      "receiver")
  if (is.null(receiver)) {
    receiver = valid_receivers
  }

  # valid scientific names
  valid_animals <- scientific_names(connection)
  check_null_or_value(scientific_name, valid_animals, "scientific_name")
  if (is.null(scientific_name)) {
    scientific_name = valid_animals
  }

  # check the limit input
  if (is.null(limit)) {
    sub_query <- glue_sql("LIMIT ALL", .con = connection)
  } else {
    assert_that(is.number(limit))
    sub_query <- glue_sql("LIMIT {limit}",
                          limit = as.character(limit),
                          .con = connection)
  }

  detections_query <- glue_sql(
    "SELECT * FROM vliz.detections_view
    WHERE network_project_code IN ({network_project*})
      AND animal_project_code IN ({animal_project*})
      AND datetime > {start_date}
      AND datetime < {end_date}
      AND deployment_station_name IN ({station_name*})
      AND transmitter IN ({transmitter*})
      AND receiver IN ({receiver*})
      AND scientific_name IN ({scientific_names*})
    {sub_query}",
    network_project = network_project,
    animal_project = animal_project,
    start_date = start_date,
    end_date = end_date,
    station_name = deployment_station_name[!is.na(deployment_station_name)],
    transmitter = transmitter,
    receiver = receiver,
    scientific_names = scientific_name,
    nrows = limit,
    .con = connection
  )
  detections <- dbGetQuery(connection, detections_query)
  as_tibble(detections)

}

#' Support function to get unique set of deployment_station_name
#'
#' Get unique deployment_station_name
#'
#' @param connection A valid connection to ETN database.
#'
#' @keywords internal
#'
#' @noRd
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all deployment_station_names present in vliz.deployments.
deployment_station_names <- function(connection) {

  query <- glue_sql(
    "SELECT DISTINCT station_name FROM vliz.deployments",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$station_name
}

#' Support function to get unique set of transmitters (tag_code_space)
#'
#' Get unique transmitters
#'
#' @param connection A valid connection to ETN database.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all transmitter present in vliz.tags.
transmitters <- function(connection) {

  query <- glue_sql(
    "SELECT DISTINCT tag_full_id FROM vliz.tags",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$tag_full_id
}

