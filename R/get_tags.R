#' Get tag data
#'
#' Get data for tags, with options to filter results. Note that there
#' can be multiple records (`acoustic_tag_id`) per tag device
#' (`tag_serial_number`).
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param tag_serial_number Character (vector). One or more tag serial numbers.
#' @param tag_type Character (vector). `acoustic` or `archival`. Some tags are
#'   both, find those with `acoustic-archival`.
#' @param tag_subtype Character (vector). `animal`, `built-in`, `range` or
#'   `sentinel`.
#' @param acoustic_tag_id Character (vector). One or more acoustic tag
#'   identifiers. These are the identifiers found in acoustic detections.
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
#' # Get all tags
#' get_tags()
#'
#' # Get archival tags, including acoustic-archival
#' get_tags(tag_type = c("archival", "acoustic-archival"))
#'
#' # Get tags of specific subtype
#' get_tags(tag_subtype = c("built-in", "range"))
#'
#' # Get specific tags
#' get_tags(tag_serial_number = "1187450")
#' get_tags(acoustic_tag_id = "A69-1601-16130")
#' get_tags(acoustic_tag_id = c("A69-1601-16129", "A69-1601-16130"))
#' }
get_tags <- function(connection = con,
                     tag_type = NULL,
                     tag_subtype = NULL,
                     tag_serial_number = NULL,
                     acoustic_tag_id = NULL) {
  # Check connection
  check_connection(connection)

  # Check tag_serial_number
  if (is.null(tag_serial_number)) {
    tag_serial_number_query <- "True"
  } else {
    valid_tag_serial_numbers <- list_tag_serial_numbers(connection)
    tag_serial_number <- as.character(tag_serial_number) # Cast to character
    check_value(tag_serial_number, valid_tag_serial_numbers, "tag_serial_number")
    tag_serial_number_query <- glue_sql("tag_serial_number IN ({tag_serial_number*})", .con = connection)
  }

  # Check tag_type
  if (is.null(tag_type)) {
    tag_type_query <- "True"
  } else {
    valid_tag_types <- c("acoustic", "archival", "acoustic-archival")
    check_value(tag_type, valid_tag_types, "tag_type")
    tag_type_query <- glue_sql("tag_type IN ({tag_type*})", .con = connection)
  }

  # Check tag_subtype
  if (is.null(tag_subtype)) {
    tag_subtype_query <- "True"
  } else {
    valid_tag_subtypes <- c("animal", "built-in", "range", "sentinel")
    check_value(tag_subtype, valid_tag_subtypes, "tag_subtype")
    tag_subtype_query <- glue_sql("tag_subtype IN ({tag_subtype*})", .con = connection)
  }

  # Check acoustic_tag_id
  if (is.null(acoustic_tag_id)) {
    acoustic_tag_id_query <- "True"
  } else {
    valid_acoustic_tag_ids <- list_acoustic_tag_ids(connection)
    check_value(acoustic_tag_id, valid_acoustic_tag_ids, "acoustic_tag_id")
    acoustic_tag_id_query <- glue_sql("acoustic_tag_id IN ({acoustic_tag_id*})", .con = connection)
  }

  # Build query
  query <- glue_sql("
    WITH
    combined_tag AS (
      SELECT
        -- id_pk,
        tag_device_fk,
        sensor_type,
        tag_full_id,
        thelma_converted_code,
        -- tag_code_space AS protocol,
        -- id_code,
        frequency,
        slope,
        intercept,
        range,
        sensor_transmit_ratio,
        accelerometer_algoritm,
        accelerometer_samples_per_second,
        min_delay,
        max_delay,
        power,
        duration_step1,
        acceleration_on_sec_step1,
        min_delay_step2,
        max_delay_step2,
        power_step2,
        duration_step2,
        acceleration_on_sec_step2,
        min_delay_step3,
        max_delay_step3,
        power_step3,
        duration_step3,
        acceleration_on_sec_step3,
        min_delay_step4,
        max_delay_step4,
        power_step4,
        duration_step4,
        acceleration_on_sec_step4
        -- file,
        -- units,
        -- external_id
      FROM
        acoustic.tags

      UNION

      SELECT
        -- id_pk,
        device_tag_fk AS tag_device_fk,
        sensor_type.description AS sensor_type,
        CASE
          WHEN sensor_full_id IS NOT NULL THEN sensor_full_id
          WHEN protocol IS NOT NULL AND id_code IS NOT NULL THEN CONCAT(protocol, '-', id_code)
        END AS tag_full_id,
        NULL AS thelma_converted_code,
        -- protocol,
        -- id_code,
        frequency,
        slope,
        intercept,
        range,
        sensor_transmit_ratio,
        accelerometer_algoritm,
        accelerometer_samples_per_second,
        min_delay,
        max_delay,
        power,
        duration_step1,
        acceleration_on_sec_step1,
        min_delay_step2,
        max_delay_step2,
        power_step2,
        duration_step2,
        acceleration_on_sec_step2,
        min_delay_step3,
        max_delay_step3,
        power_step3,
        duration_step3,
        acceleration_on_sec_step3,
        min_delay_step4,
        max_delay_step4,
        power_step4,
        duration_step4,
        acceleration_on_sec_step4
        -- resolution
        -- unit
        -- accurency
        -- range_min
        -- range_max
      FROM
        archive.sensor AS archival_tag
        LEFT JOIN archive.sensor_type AS sensor_type
          ON archival_tag.sensor_type_fk = sensor_type.id_pk
    )

    SELECT * FROM (
    SELECT
      tag.serial_number AS tag_serial_number,
      CASE
        WHEN tag_type.name = 'id-tag' THEN 'acoustic'
        WHEN tag_type.name = 'sensor-tag' AND tag_full_id IS NOT NULL THEN 'acoustic-archival'
        WHEN tag_type.name = 'sensor-tag' THEN 'archival'
      END AS tag_type,
      CASE
        WHEN tag_subtype.name = 'animal' THEN 'animal'
        WHEN tag_subtype.name = 'built-in tag' THEN 'built-in'
        WHEN tag_subtype.name = 'range tag' THEN 'range'
        WHEN tag_subtype.name = 'sentinel tag' THEN 'sentinel'
      END AS tag_subtype,
      combined_tag.sensor_type AS sensor_type,
      combined_tag.tag_full_id AS acoustic_tag_id,
      combined_tag.thelma_converted_code AS acoustic_tag_id_alternative,
      manufacturer.project AS manufacturer,
      tag.model AS model,
      combined_tag.frequency AS frequency,
      tag_status.name AS status,
      tag.activation_date AS activation_date,
      tag.battery_estimated_lifetime AS battery_estimated_life,
      tag.battery_estimated_end_date AS battery_estimated_end_date,
      combined_tag.slope AS sensor_slope,
      combined_tag.intercept AS sensor_intercept,
      combined_tag.range AS sensor_range,
      combined_tag.sensor_transmit_ratio AS sensor_transmit_ratio,
      combined_tag.accelerometer_algoritm AS accelerometer_algorithm,
      combined_tag.accelerometer_samples_per_second AS accelerometer_samples_per_second,
      owner_organization.name AS owner_organization,
      tag.owner_pi AS owner_pi,
      financing_project.projectcode AS financing_project,
      combined_tag.min_delay AS step1_min_delay,
      combined_tag.max_delay AS step1_max_delay,
      combined_tag.power AS step1_power,
      combined_tag.duration_step1 AS step1_duration,
      combined_tag.acceleration_on_sec_step1 AS step1_acceleration_duration,
      combined_tag.min_delay_step2 AS step2_min_delay,
      combined_tag.max_delay_step2 AS step2_max_delay,
      combined_tag.power_step2 AS step2_power,
      combined_tag.duration_step2 AS step2_duration,
      combined_tag.acceleration_on_sec_step2 AS step2_acceleration_duration,
      combined_tag.min_delay_step3 AS step3_min_delay,
      combined_tag.max_delay_step3 AS step3_max_delay,
      combined_tag.power_step3 AS step3_power,
      combined_tag.duration_step3 AS step3_duration,
      combined_tag.acceleration_on_sec_step3 AS step3_acceleration_duration,
      combined_tag.min_delay_step4 AS step4_min_delay,
      combined_tag.max_delay_step4 AS step4_max_delay,
      combined_tag.power_step4 AS step4_power,
      combined_tag.duration_step4 AS step4_duration,
      combined_tag.acceleration_on_sec_step4 AS step4_acceleration_duration,
      tag.id_pk AS tag_device_id
    FROM common.tag_device AS tag
      LEFT JOIN combined_tag
        ON tag.id_pk = combined_tag.tag_device_fk
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
    ) AS tag -- Subquery needed to allow where clause on tag_type, tag_subtype
    WHERE
      {tag_serial_number_query}
      AND {tag_type_query}
      AND {tag_subtype_query}
      AND {acoustic_tag_id_query}
    ", .con = connection)
  tags <- dbGetQuery(connection, query)

  # Sort data
  tags <-
    tags %>%
    arrange(factor(tag_serial_number, levels = list_tag_serial_numbers(connection)))

  as_tibble(tags)
}
