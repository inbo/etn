#' Get acoustic deployment data
#'
#' Get data for deployments of acoustic receivers, with options to filter
#' results.
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param deployment_id Integer (vector). One or more deployment identifiers.
#' @param receiver_id Character (vector). One or more receiver identifiers.
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
#' @param station_name Character (vector). One or more deployment station
#'   names.
#' @param open_only Logical. Restrict deployments to those that are currently
#'   open (i.e. no end date defined). Defaults to `FALSE`.
#'
#' @return A tibble with acoustic deployment data, sorted by
#'   `acoustic_project_code`, `station_name` and `deploy_date_time`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @examples
#' # Set default connection variable
#' con <- connect_to_etn()
#'
#' # Get all acoustic deployments
#' get_acoustic_deployments(con)
#'
#' # Get specific acoustic deployment
#' get_acoustic_deployments(con, deployment_id = 1437)
#'
#' # Get acoustic deployments for a specific receiver
#' get_acoustic_deployments(con, receiver_id = "VR2W-124070")
#'
#' # Get open acoustic deployments for a specific receiver
#' get_acoustic_deployments(con, receiver_id = "VR2W-124070", open_only = TRUE)
#'
#' # Get acoustic deployments for a specific acoustic project
#' get_acoustic_deployments(con, acoustic_project_code = "demer")
#'
#' # Get acoustic deployments for two specific stations
#' get_acoustic_deployments(con, station_name = c("de-9", "de-10"))
get_acoustic_deployments <- function(connection = con,
                                     deployment_id = NULL,
                                     receiver_id = NULL,
                                     acoustic_project_code = NULL,
                                     station_name = NULL,
                                     open_only = FALSE) {
  # Check connection
  check_connection(connection)

  # Check deployment_id
  if (is.null(deployment_id)) {
    deployment_id_query <- "True"
  } else {
    valid_deployment_ids <- list_deployment_ids(connection)
    check_value(deployment_id, valid_deployment_ids, "receiver_id")
    deployment_id_query <- glue::glue_sql(
      "dep.id_pk IN ({deployment_id*})",
      .con = connection
    )
  }

  # Check receiver_id
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
    valid_receiver_ids <- list_receiver_ids(connection)
    check_value(receiver_id, valid_receiver_ids, "receiver_id")
    receiver_id_query <- glue::glue_sql(
      "receiver.receiver IN ({receiver_id*})",
      .con = connection
    )
  }

  # Check acoustic_project_code
  if (is.null(acoustic_project_code)) {
    acoustic_project_code_query <- "True"
  } else {
    acoustic_project_code <- tolower(acoustic_project_code)
    valid_acoustic_project_codes <- tolower(list_acoustic_project_codes(connection))
    check_value(acoustic_project_code, valid_acoustic_project_codes, "acoustic_project_code")
    acoustic_project_code_query <- glue::glue_sql(
      "LOWER(network_project.projectcode) IN ({acoustic_project_code*})",
      .con = connection
    )
  }

  # Check station_name
  if (is.null(station_name)) {
    station_name_query <- "True"
  } else {
    valid_station_names <- list_station_names(connection)
    check_value(station_name, valid_station_names, "station_name")
    station_name_query <- glue::glue_sql(
      "dep.station_name IN ({station_name*})",
      .con = connection
    )
  }

  # Build query
  query <- glue::glue_sql("
    SELECT
      dep.id_pk AS deployment_id,
      receiver.receiver AS receiver_id,
      network_project.projectcode AS acoustic_project_code,
      dep.station_name AS station_name,
      location_name AS station_description,
      location_manager AS station_manager,
      dep.deploy_date_time AS deploy_date_time,
      dep.deploy_lat AS deploy_latitude,
      dep.deploy_long AS deploy_longitude,
      dep.intended_lat AS intended_latitude,
      dep.intended_long AS intended_longitude,
      dep.mooring_type AS mooring_type,
      dep.bottom_depth AS bottom_depth,
      dep.riser_length AS riser_length,
      dep.instrument_depth AS deploy_depth,
      dep.battery_install_date AS battery_installation_date,
      dep.drop_dead_date AS battery_estimated_end_date,
      dep.activation_datetime AS activation_date_time,
      dep.recover_date_time AS recover_date_time,
      dep.recover_lat AS recover_latitude,
      dep.recover_long AS recover_longitude,
      dep.download_date_time AS download_date_time,
      dep.data_downloaded AS download_file_name,
      dep.valid_data_until_datetime AS valid_data_until_date_time,
      dep.sync_date_time AS sync_date_time,
      dep.time_drift AS time_drift,
      dep.ar_battery_install_date AS ar_battery_installation_date,
      dep.ar_confirm AS ar_confirm,
      dep.transmit_profile AS transmit_profile,
      dep.transmit_power_output AS transmit_power_output,
      dep.log_temperature_stats_period AS log_temperature_stats_period,
      dep.log_temperature_sample_period AS log_temperature_sample_period,
      dep.log_tilt_sample_period AS log_tilt_sample_period,
      dep.log_noise_stats_period AS log_noise_stats_period,
      dep.log_noise_sample_period AS log_noise_sample_period,
      dep.log_depth_stats_period AS log_depth_stats_period,
      dep.log_depth_sample_period AS log_depth_sample_period,
      dep.comments AS comments
      -- dep.project: dep.project_fk instead
      -- dep.check_complete_time
      -- dep.voltage_at_deploy
      -- dep.voltage_at_download
      -- dep.location_description
      -- dep.date_created
      -- dep.date_modified
      -- dep.distance_to_mouth
      -- dep.source
      -- dep.acousticreleasenumber: cpod
      -- dep.hydrophonecablelength: cpod
      -- dep.recordingname: cpod
      -- dep.hydrophonesensitivity: cpod
      -- dep.amplifiersensitivity: cpod
      -- dep.sample_rate: cpod
      -- dep.external_id
    FROM
      acoustic.deployments AS dep
      LEFT JOIN acoustic.receivers AS receiver
        ON dep.receiver_fk = receiver.id_pk
      LEFT JOIN common.projects AS network_project
        ON dep.project_fk = network_project.id
    WHERE
      dep.deployment_type = 'acoustic_telemetry'
      AND {deployment_id_query}
      AND {receiver_id_query}
      AND {acoustic_project_code_query}
      AND {station_name_query}
    ", .con = connection)
  deployments <- DBI::dbGetQuery(connection, query)

  # Filter on open deployments
  if (open_only) {
    deployments <- filter(deployments, is.na(.data$recover_date_time))
  }

  # Sort data
  deployments <-
    deployments %>%
    dplyr::arrange(
      .data$acoustic_project_code,
      factor(.data$station_name, levels = list_station_names(connection)),
      .data$deploy_date_time
    )

  dplyr::as_tibble(deployments)
}
