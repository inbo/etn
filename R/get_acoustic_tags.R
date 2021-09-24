#' Get acoustic tag data
#'
#' Get data for acoustic tags, with options to filter results.
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param tag_serial_number Character (vector). One or more tag serial numbers.
#' @param acoustic_tag_id Character (vector). One or more acoustic tag ids.
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
#' # Get all acoustic tags
#' get_acoustic_tags()
#'
#' # Get specific acoustic tags
#' get_acoustic_tags(tag_serial_number = "1157779")
#' get_acoustic_tags(acoustic_tag_id = "A69-1601-28294")
#' get_acoustic_tags(acoustic_tag_id = c("A69-1601-28294", "A69-1601-28295"))
#' }
get_acoustic_tags <- function(connection = con,
                              tag_serial_number = NULL,
                              acoustic_tag_id = NULL) {
  # Check connection
  check_connection(connection)

  # Check tag_serial_number
  valid_tag_serial_numbers <- list_tag_serial_numbers(connection)
  if (is.null(tag_serial_number)) {
    tag_serial_number_query <- "True"
  } else {
    tag_serial_number <- as.character(tag_serial_number) # Cast to character
    check_value(tag_serial_number, valid_tag_serial_numbers, "tag_serial_number")
    tag_serial_number_query <- glue_sql("tag.serial_number IN ({tag_serial_number*})", .con = connection)
    include_ref_tags <- TRUE
  }

  # Check acoustic_tag_id
  valid_acoustic_tag_ids <- list_acoustic_tag_ids(connection)
  if (is.null(acoustic_tag_id)) {
    acoustic_tag_id_query <- "True"
  } else {
    check_value(acoustic_tag_id, valid_acoustic_tag_ids, "acoustic_tag_id")
    acoustic_tag_id_query <- glue_sql("acoustic_tag.tag_full_id IN ({acoustic_tag_id*})", .con = connection)
    include_ref_tags <- TRUE
  }

  # Build query
  query <- glue_sql("
    SELECT
      tag.serial_number AS tag_serial_number, -- Not acoustic_tag.serial_number_tbd
      CASE
        WHEN tag_type.name = 'id-tag' THEN 'acoustic'
        WHEN tag_type.name = 'sensor-tag' THEN 'archival'
      END AS tag_type, -- Not acoustic_tag.type_tbd
      tag_subtype.name AS tag_subtype,
      tag.id_pk AS tag_id,
      acoustic_tag.tag_full_id AS acoustic_tag_id,
      acoustic_tag.thelma_converted_code AS acoustic_tag_id_alternative,
      manufacturer.project AS manufacturer, -- Not acoustic_tag.manufacturer_fk_tbd
      tag.model AS model, -- Not acoustic_tag.model_tbd
      acoustic_tag.frequency AS frequency,
      acoustic_tag.tag_code_space AS acoustic_tag_id_protocol,
      acoustic_tag.id_code AS acoustic_tag_id_code,
      tag_status.name AS status, -- Not acoustic_tag.status_tbd
      tag.activation_date AS activation_date, -- Not acoustic_tag.activation_date_tbd
      tag.battery_estimated_lifetime AS battery_estimated_life, -- Not acoustic_tag.estimated_lifetime_tbd
      tag.battery_estimated_end_date AS battery_estimated_end_date, -- Not acoustic_tag.end_date_tbd
      acoustic_tag.sensor_type AS sensor_type,
      acoustic_tag.slope AS sensor_slope,
      acoustic_tag.intercept AS sensor_intercept,
      acoustic_tag.range AS sensor_range,
      acoustic_tag.sensor_transmit_ratio AS sensor_transmit_ratio,
      acoustic_tag.accelerometer_algoritm AS accelerometer_algorithm,
      acoustic_tag.accelerometer_samples_per_second AS accelerometer_samples_per_second,
      owner_organization.name AS owner_organization, -- Not acoustic_tag.owner_group_fk_tbd
      tag.owner_pi AS owner_pi, -- Not acoustic_tag.owner_pi_tbd
      financing_project.projectcode AS financing_project, -- Not acoustic_tag.financing_project_fk_tbd
      acoustic_tag.min_delay AS step1_min_delay,
      acoustic_tag.max_delay AS step1_max_delay,
      acoustic_tag.power AS step1_power,
      acoustic_tag.duration_step1 AS step1_duration,
      acoustic_tag.acceleration_on_sec_step1 AS step1_acceleration_duration,
      acoustic_tag.min_delay_step2 AS step2_min_delay,
      acoustic_tag.max_delay_step2 AS step2_max_delay,
      acoustic_tag.power_step2 AS step2_power,
      acoustic_tag.duration_step2 AS step2_duration,
      acoustic_tag.acceleration_on_sec_step2 AS step2_acceleration_duration,
      acoustic_tag.min_delay_step3 AS step3_min_delay,
      acoustic_tag.max_delay_step3 AS step3_max_delay,
      acoustic_tag.power_step3 AS step3_power,
      acoustic_tag.duration_step3 AS step3_duration,
      acoustic_tag.acceleration_on_sec_step3 AS step3_acceleration_duration,
      acoustic_tag.min_delay_step4 AS step4_min_delay,
      acoustic_tag.max_delay_step4 AS step4_max_delay,
      acoustic_tag.power_step4 AS step4_power,
      acoustic_tag.duration_step4 AS step4_duration,
      acoustic_tag.acceleration_on_sec_step4 AS step4_acceleration_duration
    FROM common.tag_device AS tag
      LEFT JOIN acoustic.tags AS acoustic_tag
        ON tag.id_pk = acoustic_tag.tag_device_fk
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
      tag_type.name = 'id-tag'
      AND {tag_serial_number_query}
      AND {acoustic_tag_id_query}
    ", .con = connection)
  tags <- dbGetQuery(connection, query)

  # Sort data
  tags <-
    tags %>%
    arrange(factor(tag_serial_number, levels = valid_tag_serial_numbers)) # valid_tag_serial_numbers defined above

  as_tibble(tags)
}
