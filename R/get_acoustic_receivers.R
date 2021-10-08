#' Get acoustic receiver data
#'
#' Get data for acoustic receivers, with options to filter results.
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param receiver_id Character (vector). One or more receiver identifiers.
#' @param status Character. One or more statuses, e.g. `available` or `broken`.
#'
#' @return A tibble with acoustic receiver data, sorted by `receiver_id`. See
#'   also
#'   [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr %>% arrange as_tibble
#' @importFrom readr read_file
#'
#' @examples
#' \dontrun{
#' # Set default connection variable
#' con <- connect_to_etn()
#'
#' # Get all acoustic receivers()
#' get_acoustic_receivers()
#'
#' # Get lost and broken acoustic receivers()
#' get_acoustic_receivers(status = c("lost", "broken"))
#'
#' # Get a specific acoustic receiver
#' get_acoustic_receiver(receiver_id = "VR2W-124070")
#' }
get_acoustic_receivers <- function(connection = con,
                                   receiver_id = NULL,
                                   status = NULL) {
  # Check connection
  check_connection(connection)

  # Check receiver_id
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
    valid_receiver_ids <- list_receiver_ids(connection)
    check_value(receiver_id, valid_receiver_ids, "receiver_id")
    receiver_id_query <- glue_sql("receiver.receiver IN ({receiver_id*})", .con = connection)
  }

  # Check status
  if (is.null(status)) {
    status_query <- "True"
  } else {
    valid_status <- c("active", "available", "broken", "inactive", "lost", "returned")
    check_value(status, valid_status, "status")
    status_query <- glue_sql("receiver.controlled_status IN ({status*})", .con = connection)
  }

  receiver_query <- glue_sql(read_file(system.file("sql", "receiver.sql", package = "etn")), .con = connection)
  tag_query <- glue_sql(read_file(system.file("sql", "tag.sql", package = "etn")), .con = connection)

  # Build query
  query <- glue_sql("
    SELECT
      receiver.receiver AS receiver_id,
      manufacturer.project AS manufacturer,
      receiver.model_number AS receiver_model,
      receiver.serial_number AS receiver_serial_number,
      receiver.modem_address AS modem_address,
      receiver.controlled_status AS status,
      receiver.expected_battery_life AS battery_estimated_life,
      owner_organization.name AS owner_organization,
      financing_project.projectcode AS financing_project,
      tag.acoustic_tag_id AS built_in_acoustic_tag_id,
      receiver.ar_model_number AS ar_model,
      receiver.ar_serial_number AS ar_serial_number,
      receiver.ar_expected_battery_life AS ar_battery_estimated_life,
      receiver.ar_voltage_at_deploy AS ar_voltage_at_deploy,
      receiver.ar_interrogate_code AS ar_interrogate_code,
      receiver.ar_receive_frequency AS ar_receive_frequency,
      receiver.ar_reply_frequency AS ar_reply_frequency,
      receiver.ar_ping_rate AS ar_ping_rate,
      receiver.ar_enable_code_address AS ar_enable_code_address,
      receiver.ar_release_code AS ar_release_code,
      receiver.ar_disable_code AS ar_disable_code,
      receiver.ar_tilt_code AS ar_tilt_code,
      receiver.ar_tilt_after_deploy AS ar_tilt_after_deploy
      -- id_pk
      -- external_id
    FROM
      ({receiver_query}) AS receiver
      LEFT JOIN common.manufacturer AS manufacturer
          ON receiver.manufacturer_fk = manufacturer.id_pk
      LEFT JOIN common.etn_group AS owner_organization
        ON receiver.owner_group_fk = owner_organization.id_pk
      LEFT JOIN common.projects AS financing_project
        ON receiver.financing_project_fk = financing_project.id
      LEFT JOIN ({tag_query}) AS tag
        ON receiver.built_in_tag_device_fk = tag.tag_device_fk
    WHERE
      receiver.receiver_type = 'acoustic_telemetry'
      AND {receiver_id_query}
      AND {status_query}
    ", .con = connection)
  receivers <- dbGetQuery(connection, query)

  # Sort data
  receivers <-
    receivers %>%
    arrange(receiver_id)

  as_tibble(receivers)
}
