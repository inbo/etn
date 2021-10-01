#' Get acoustic detections data
#'
#' Get data for acoustic detections, with options to filter results. Use
#' `limit` to limit the number of returned records.
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param start_date Character. Start date (inclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param end_date Character. End date (exclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param acoustic_tag_id Character (vector). One or more acoustic tag ids.
#' @param animal_project_code Character (vector). One or more animal projects.
#'   Case-insensitive.
#' @param scientific_name Character (vector). One or more scientific names.
#' @param network_project_code Character (vector). One or more network
#'   projects. Case-insensitive.
#' @param receiver_id Character (vector). One or more receiver identifiers.
#' @param station_name Character (vector). One or more deployment station
#'   names. Case-insensitive.
#' @param limit Logical. Limit the number of returned records to 100 (useful
#'   for testing purposes). Defaults to `FALSE`.
#'
#' @return A tibble with detections data, sorted by `acoustic_tag_id` and `date_time`.
#'  See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr %>% arrange as_tibble
#' @importFrom assertthat assert_that
#'
#' @examples
#' \dontrun{
#' # Set default connection variable
#' con <- connect_to_etn()
#'
#' # Get limited sample of acoustic detections
#' get_acoustic_detections(limit = TRUE)
#'
#' # Get all acoustic detections from a specific animal project
#' get_acoustic_detections(animal_project_code = "2014_demer")
#'
#' # Get 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   animal_project_code = "2014_demer",
#'   start_date = "2015",
#'   end_date = "2016",
#' )
#'
#' # Get April 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   animal_project_code = "2014_demer",
#'   start_date = "2015-04",
#'   end_date = "2015-05",
#' )
#'
#' # Get April 24, 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   animal_project_code = "2014_demer",
#'   start_date = "2015-04-24",
#'   end_date = "2015-04-25",
#' )
#'
#' # Get acoustic detections for a specific tag at two specific stations
#' get_acoustic_detections(
#'   acoustic_tag_id = "A69-1601-16130",
#'   station_name = c("de-9", "de-10")
#' )
#'
#' # Get acoustic detections for a specific species, receiver and network project
#' get_acoustic_detections(
#'   scientific_name = "Rutilus rutilus",
#'   receiver_id = "VR2W-124070",
#'   network_project_code = "demer"
#' )
#' }
get_acoustic_detections <- function(connection = con,
                                    start_date = NULL,
                                    end_date = NULL,
                                    acoustic_tag_id = NULL,
                                    animal_project_code = NULL,
                                    scientific_name = NULL,
                                    network_project_code = NULL,
                                    receiver_id = NULL,
                                    station_name = NULL,
                                    limit = FALSE) {
  # Check connection
  check_connection(connection)

  # Check start_date
  if (is.null(start_date)) {
    start_date_query <- "True"
  } else {
    start_date <- check_date_time(start_date, "start_date")
    start_date_query <- glue_sql("detection.datetime >= {start_date}", .con = connection)
  }

  # Check end_date
  if (is.null(end_date)) {
    end_date_query <- "True"
  } else {
    end_date <- check_date_time(end_date, "end_date")
    end_date_query <- glue_sql("detection.datetime < {end_date}", .con = connection)
  }

  # Check acoustic_tag_id
  if (is.null(acoustic_tag_id)) {
    acoustic_tag_id_query <- "True"
  } else {
    valid_acoustic_tag_ids <- list_acoustic_tag_ids(connection)
    check_value(acoustic_tag_id, valid_acoustic_tag_ids, "acoustic_tag_id")
    acoustic_tag_id_query <- glue_sql("acoustic_tag.tag_full_id IN ({acoustic_tag_id*})", .con = connection)
    include_ref_tags <- TRUE
  }

  # Check animal_project_code
  if (is.null(animal_project_code)) {
    animal_project_code_query <- "True"
  } else {
    animal_project_code <- tolower(animal_project_code)
    valid_animal_project_codes <- tolower(list_animal_project_codes(connection))
    check_value(animal_project_code, valid_animal_project_codes, "animal_project_code")
    animal_project_code_query <- glue_sql(
      "LOWER(animal_project.projectcode) IN ({animal_project_code*})",
      .con = connection
    )
  }

  # Check scientific_name
  if (is.null(scientific_name)) {
    scientific_name_query <- "True"
  } else {
    scientific_name_ids <- list_scientific_names(connection)
    check_value(scientific_name, scientific_name_ids, "scientific_name")
    scientific_name_query <- glue_sql("animal.scientific_name IN ({scientific_name*})", .con = connection)
  }

  # Check network_project_code
  if (is.null(network_project_code)) {
    network_project_code_query <- "True"
  } else {
    network_project_code <- tolower(network_project_code)
    valid_network_project_codes <- tolower(list_network_project_codes(connection))
    check_value(network_project_code, valid_network_project_codes, "network_project_code")
    network_project_code_query <- glue_sql(
      "LOWER(network_project.projectcode) IN ({network_project_code*})",
      .con = connection
    )
  }

  # Check receiver_id
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
    valid_receiver_ids <- list_receiver_ids(connection)
    check_value(receiver_id, valid_receiver_ids, "receiver_id")
    receiver_id_query <- glue_sql("detection.receiver IN ({receiver_id*})", .con = connection)
  }

  # Check station_name
  if (is.null(station_name)) {
    station_name_query <- "True"
  } else {
    station_name <- tolower(station_name)
    valid_station_names <- tolower(list_station_names(connection))
    check_value(station_name, valid_station_names, "station_name")
    station_name_query <- glue_sql(
      "LOWER(deployment.station_name) IN ({station_name*})",
      .con = connection
    )
  }

  # Check limit
  assert_that(is.logical(limit), msg = "limit must be a logical: TRUE/FALSE.")
  if (limit) {
    limit_query <- glue_sql("LIMIT 100", .con = connection)
  } else {
    limit_query <- glue_sql("LIMIT ALL}", .con = connection)
  }

  # Build query
  query <- glue_sql("
    SELECT
      detection.id_pk AS detection_id,
      detection.datetime AS date_time,
      tag.serial_number AS tag_serial_number, -- Not detection.transmitter_serial
      detection.transmitter AS acoustic_tag_id,
      animal_project.projectcode AS animal_project_code,
      animal.id_pk AS animal_id,
      animal.scientific_name AS scientific_name,
      network_project.projectcode AS network_project_code,
      detection.receiver AS receiver_id,
      deployment.station_name AS station_name,
      deployment.deploy_lat AS deploy_latitude,
      deployment.deploy_long AS deploy_longitude,
      -- sensor_type?
      detection.sensor_value AS sensor_value,
      detection.sensor_unit AS sensor_unit,
      detection.sensor2_value AS sensor2_value,
      detection.sensor2_unit AS sensor2_unit,
      detection.signal_to_noise_ratio AS signal_to_noise_ratio,
      detection.file AS source_file,
      detection.qc_flag AS qc_flag,
      detection.deployment_fk AS deployment_id
    FROM acoustic.detections AS detection
      LEFT JOIN acoustic.tags AS acoustic_tag
        ON detection.transmitter = acoustic_tag.tag_full_id
        LEFT JOIN common.tag_device AS tag
          ON acoustic_tag.tag_device_fk = tag.id_pk
          LEFT JOIN common.animal_release_tag_device AS animal_with_tag
            ON tag.id_pk = animal_with_tag.tag_device_fk
            LEFT JOIN common.animal_release AS animal
              ON animal_with_tag.animal_release_fk = animal.id_pk
              LEFT JOIN common.projects AS animal_project
                ON animal.project_fk = animal_project.id
      LEFT JOIN acoustic.deployments AS deployment
        ON detection.deployment_fk = deployment.id_pk
      LEFT JOIN common.projects AS network_project
        ON deployment.project_fk = network_project.id
    WHERE
      {start_date_query}
      AND {end_date_query}
      AND {acoustic_tag_id_query}
      AND {animal_project_code_query}
      AND {scientific_name_query}
      AND {network_project_code_query}
      AND {receiver_id_query}
      AND {station_name_query}
      {limit_query}
    ", .con = connection)
  detections <- dbGetQuery(connection, query)

  # Sort data (faster than in SQL)
  detections <-
    detections %>%
    arrange(
      factor(.data$acoustic_tag_id, levels = list_acoustic_tag_ids(connection)),
      .data$date_time
    )

  as_tibble(detections)
}
