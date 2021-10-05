#' Get archival tag data
#'
#' Get data for archival tags, with options to filter results. Note that there
#' can be multiple records (`archival_tag_id`) per tag device
#' (`tag_serial_number`), often multiple types of sensors
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param tag_serial_number Character (vector). One or more tag serial numbers.
#' @param archival_tag_id Character (vector). One or more archival tag
#'   identifiers.
#'
#' @return A tibble with tags data, sorted by `tag_serial_number`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr %>% arrange as_tibble
#'
#' @examples
#' \dontrun{
#' # Set default connection variable
#' con <- connect_to_etn()
#'
#' # Get all archival tags
#' get_archival_tags()
#'
#' # Get specific archival tags
#' get_archival_tags(tag_serial_number = "1292638")
#' get_archival_tags(archival_tag_id = "3638")
#' get_archival_tags(archival_tag_id = c("3638", "3639"))
#' }
get_archival_tags <- function(connection = con,
                              tag_serial_number = NULL,
                              archival_tag_id = NULL) {
  # Check connection
  check_connection(connection)

  # Check tag_serial_number
  if (is.null(tag_serial_number)) {
    tag_serial_number_query <- "True"
  } else {
    valid_tag_serial_numbers <- list_tag_serial_numbers(connection)
    tag_serial_number <- as.character(tag_serial_number) # Cast to character
    check_value(tag_serial_number, valid_tag_serial_numbers, "tag_serial_number")
    tag_serial_number_query <- glue_sql("tag.serial_number IN ({tag_serial_number*})", .con = connection)
  }

  # Check archival_tag_id
  if (is.null(archival_tag_id)) {
    archival_tag_id_query <- "True"
  } else {
    valid_archival_tag_ids <- list_archival_tag_ids(connection)
    archival_tag_id <- as.character(archival_tag_id) # Cast to character
    check_value(archival_tag_id, valid_archival_tag_ids, "archival_tag_id")
    archival_tag_id_query <- glue_sql("archival_tag.id_code IN ({archival_tag_id*})", .con = connection)
  }

  # Build query
  query <- glue_sql("
    SELECT
      tag.serial_number AS tag_serial_number,
      CASE
        WHEN tag_type.name = 'id-tag' THEN 'acoustic'
        WHEN tag_type.name = 'sensor-tag' THEN 'archival'
      END AS tag_type,
      tag_subtype.name AS tag_subtype,
      tag.id_pk AS tag_id,
      archival_tag.id_code AS archival_tag_id,
      sensor_type.description AS sensor_type,
      manufacturer.project AS manufacturer,
      tag.model AS model,
      archival_tag.frequency AS frequency,
      tag_status.name AS status,
      tag.activation_date AS activation_date,
      tag.battery_estimated_lifetime AS battery_estimated_life,
      tag.battery_estimated_end_date AS battery_estimated_end_date,
      -- sensor_type.description AS sensor_type: see higher
      archival_tag.slope AS sensor_slope,
      archival_tag.intercept AS sensor_intercept,
      archival_tag.range AS sensor_range,
      archival_tag.sensor_transmit_ratio AS sensor_transmit_ratio,
      archival_tag.accelerometer_algoritm AS accelerometer_algorithm,
      archival_tag.accelerometer_samples_per_second AS accelerometer_samples_per_second,
      owner_organization.name AS owner_organization,
      tag.owner_pi AS owner_pi,
      financing_project.projectcode AS financing_project,
      archival_tag.min_delay AS step1_min_delay,
      archival_tag.max_delay AS step1_max_delay,
      archival_tag.power AS step1_power,
      archival_tag.duration_step1 AS step1_duration,
      archival_tag.acceleration_on_sec_step1 AS step1_acceleration_duration,
      archival_tag.min_delay_step2 AS step2_min_delay,
      archival_tag.max_delay_step2 AS step2_max_delay,
      archival_tag.power_step2 AS step2_power,
      archival_tag.duration_step2 AS step2_duration,
      archival_tag.acceleration_on_sec_step2 AS step2_acceleration_duration,
      archival_tag.min_delay_step3 AS step3_min_delay,
      archival_tag.max_delay_step3 AS step3_max_delay,
      archival_tag.power_step3 AS step3_power,
      archival_tag.duration_step3 AS step3_duration,
      archival_tag.acceleration_on_sec_step3 AS step3_acceleration_duration,
      archival_tag.min_delay_step4 AS step4_min_delay,
      archival_tag.max_delay_step4 AS step4_max_delay,
      archival_tag.power_step4 AS step4_power,
      archival_tag.duration_step4 AS step4_duration,
      archival_tag.acceleration_on_sec_step4 AS step4_acceleration_duration
    FROM common.tag_device AS tag
      LEFT JOIN archive.sensor AS archival_tag
        ON tag.id_pk = archival_tag.device_tag_fk -- Not tag_device_fk
        LEFT JOIN archive.sensor_type AS sensor_type
          ON archival_tag.sensor_type_fk = sensor_type.id_pk
      LEFT JOIN common.manufacturer AS manufacturer
        ON tag.manufacturer_fk = manufacturer.id_pk
      LEFT JOIN common.tag_device_type AS tag_type
        ON tag.tag_device_type_fk = tag_type.id_pk
      LEFT JOIN acoustic.acoustic_tag_subtype AS tag_subtype
        ON tag.acoustic_tag_subtype_fk = tag_subtype.id_pk
      LEFT JOIN common.tag_device_status AS tag_status
        ON tag.tag_device_status_fk = tag_status.id_pk
      LEFT JOIN common.etn_group AS owner_organization
        ON tag.owner_group_fk = owner_organization.id_pk
      LEFT JOIN common.projects AS financing_project
        ON tag.financing_project_fk = financing_project.id

    WHERE
      tag_type.name = 'sensor-tag'
      AND {tag_serial_number_query}
      AND {archival_tag_id_query}
    ", .con = connection)
  tags <- dbGetQuery(connection, query)

  # Sort data
  tags <-
    tags %>%
    arrange(factor(tag_serial_number, levels = list_tag_serial_numbers(connection)))

  as_tibble(tags)
}
