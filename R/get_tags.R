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
#' @importFrom readr read_file
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
    tag_serial_number_query <- glue_sql("tag.tag_serial_number IN ({tag_serial_number*})", .con = connection)
  }

  # Check tag_type
  if (is.null(tag_type)) {
    tag_type_query <- "True"
  } else {
    valid_tag_types <- c("acoustic", "archival", "acoustic-archival")
    check_value(tag_type, valid_tag_types, "tag_type")
    tag_type_query <- glue_sql("tag.tag_type IN ({tag_type*})", .con = connection)
  }

  # Check tag_subtype
  if (is.null(tag_subtype)) {
    tag_subtype_query <- "True"
  } else {
    valid_tag_subtypes <- c("animal", "built-in", "range", "sentinel")
    check_value(tag_subtype, valid_tag_subtypes, "tag_subtype")
    tag_subtype_query <- glue_sql("tag.tag_subtype IN ({tag_subtype*})", .con = connection)
  }

  # Check acoustic_tag_id
  if (is.null(acoustic_tag_id)) {
    acoustic_tag_id_query <- "True"
  } else {
    valid_acoustic_tag_ids <- list_acoustic_tag_ids(connection)
    check_value(acoustic_tag_id, valid_acoustic_tag_ids, "acoustic_tag_id")
    acoustic_tag_id_query <- glue_sql("tag.acoustic_tag_id IN ({acoustic_tag_id*})", .con = connection)
  }

  tag_query <- glue_sql(read_file(system.file("sql", "tag.sql", package = "etn")), .con = connection)

  # Build query
  query <- glue_sql("
    SELECT
      tag.tag_serial_number AS tag_serial_number,
      tag.tag_type AS tag_type,
      tag.tag_subtype AS tag_subtype,
      tag.sensor_type AS sensor_type,
      tag.acoustic_tag_id AS acoustic_tag_id,
      tag.thelma_converted_code AS acoustic_tag_id_alternative,
      manufacturer.project AS manufacturer,
      tag_device.model AS model,
      tag.frequency AS frequency,
      tag_status.name AS status,
      tag_device.activation_date AS activation_date,
      tag_device.battery_estimated_lifetime AS battery_estimated_life,
      tag_device.battery_estimated_end_date AS battery_estimated_end_date,
      tag.resolution AS resolution,
      tag.unit AS unit,
      tag.accurency AS accuracy,
      tag.range_min AS range_min,
      tag.range_max AS range_max,
      tag.slope AS sensor_slope,
      tag.intercept AS sensor_intercept,
      tag.range AS sensor_range,
      tag.sensor_transmit_ratio AS sensor_transmit_ratio,
      tag.accelerometer_algoritm AS accelerometer_algorithm,
      tag.accelerometer_samples_per_second AS accelerometer_samples_per_second,
      owner_organization.name AS owner_organization,
      tag_device.owner_pi AS owner_pi,
      financing_project.projectcode AS financing_project,
      tag.min_delay AS step1_min_delay,
      tag.max_delay AS step1_max_delay,
      tag.power AS step1_power,
      tag.duration_step1 AS step1_duration,
      tag.acceleration_on_sec_step1 AS step1_acceleration_duration,
      tag.min_delay_step2 AS step2_min_delay,
      tag.max_delay_step2 AS step2_max_delay,
      tag.power_step2 AS step2_power,
      tag.duration_step2 AS step2_duration,
      tag.acceleration_on_sec_step2 AS step2_acceleration_duration,
      tag.min_delay_step3 AS step3_min_delay,
      tag.max_delay_step3 AS step3_max_delay,
      tag.power_step3 AS step3_power,
      tag.duration_step3 AS step3_duration,
      tag.acceleration_on_sec_step3 AS step3_acceleration_duration,
      tag.min_delay_step4 AS step4_min_delay,
      tag.max_delay_step4 AS step4_max_delay,
      tag.power_step4 AS step4_power,
      tag.duration_step4 AS step4_duration,
      tag.acceleration_on_sec_step4 AS step4_acceleration_duration,
      tag_device.id_pk AS tag_device_id
    FROM ({tag_query}) AS tag
      LEFT JOIN common.tag_device AS tag_device
        ON tag.tag_device_fk = tag_device.id_pk
        LEFT JOIN common.manufacturer AS manufacturer
          ON tag_device.manufacturer_fk = manufacturer.id_pk
        LEFT JOIN common.tag_device_status AS tag_status
          ON tag_device.tag_device_status_fk = tag_status.id_pk
        LEFT JOIN common.etn_group AS owner_organization
          ON tag_device.owner_group_fk = owner_organization.id_pk
        LEFT JOIN common.projects AS financing_project
          ON tag_device.financing_project_fk = financing_project.id
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
