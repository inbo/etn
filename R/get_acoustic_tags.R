#' Get acoustic tag data
#'
#' Get data for acoustic tags, with options to filter results. By default,
#' reference tags are excluded.
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param tag_serial_number Character (vector). One or more tag serial numbers.
#' @param acoustic_tag_id Character (vector). One or more acoustic tag ids.
#' @param include_ref_tags Logical. Include reference tags. Defaults to
#'   `FALSE`.
#'
#' @return A tibble with tags data, sorted by `tag_serial_number`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr %>% arrange as_tibble filter
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # Get all acoustic tags
#' get_tags(con)
#'
#' # Get all acoustic tags, including reference tags
#' get_tags(con, include_ref_tags = TRUE)
#'
#' # Get specific acoustic tags (will automatically set include_ref_tags = TRUE)
#' get_tags(con, tag_id = "A69-1303-65313")
#' get_tags(con, tag_id = c("A69-1601-1705", "A69-1601-1707"))
#' }
get_acoustic_tags <- function(connection = con,
                              tag_serial_number = NULL,
                              acoustic_tag_id = NULL,
                              include_ref_tags = FALSE) {
  # Check connection
  check_connection(connection)

  # Check tag_serial_number
  valid_tag_serial_numbers <- list_tag_serial_numbers(connection)
  if (is.null(tag_serial_number)) {
    tag_serial_number_query <- "True"
  } else {
    check_value(tag_serial_number, valid_tag_serial_numbers, "tag_serial_number")
    tag_serial_number_query <- glue_sql("tag_serial_number IN ({tag_serial_number*})", .con = connection)
    include_ref_tags <- TRUE
  }

  # Check acoustic_tag_id
  valid_acoustic_tag_ids <- list_acoustic_tag_ids(connection)
  if (is.null(acoustic_tag_id)) {
    acoustic_tag_id_query <- "True"
  } else {
    check_value(acoustic_tag_id, valid_acoustic_tag_ids, "acoustic_tag_id")
    acoustic_tag_id_query <- glue_sql("acoustic_tag_id IN ({acoustic_tag_id*})", .con = connection)
    include_ref_tags <- TRUE
  }

  # Build query
  query <- glue_sql("
    SELECT
      *
    FROM
      acoustic.tags_view2
    WHERE
      {tag_serial_number_query}
      {acoustic_tag_id_query}
    ", .con = connection)
  tags <- dbGetQuery(connection, query)

  # Filter on reference tags
  if (include_ref_tags) {
    tags
  } else {
    tags <- tags %>% filter(.data$type == "animal")
  }

  # Sort data
  tags <-
    tags %>%
    arrange(factor(tag_serial_number, levels = valid_tag_serial_numbers)) # valid_tag_serial_numbers defined above

  as_tibble(tags)
}
