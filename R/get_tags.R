#' Get tag data
#'
#' Get data for tags, with options to filter results. By default, reference
#' tags are excluded.
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param tag_id Character (vector). One or more tag ids.
#' @param include_ref_tags Logical. Include reference tags. Defaults to
#'   `FALSE`.
#'
#' @return A tibble with tags data, sorted by `tag_id`. See also
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
#' # Get all (animal) tags
#' get_tags(con)
#'
#' # Get all tags, including reference tags
#' get_tags(con, include_ref_tags = TRUE)
#'
#' # Get specific tags (will automatically set include_ref_tags = TRUE)
#' get_tags(con, tag_id = "A69-1303-65313")
#' get_tags(con, tag_id = c("A69-1601-1705", "A69-1601-1707"))
#' }
get_tags <- function(connection = con,
                     tag_id = NULL,
                     include_ref_tags = FALSE) {
  # Check connection
  check_connection(connection)

  # Check tag_id
  valid_tag_ids <- list_tag_ids(connection)
  if (is.null(tag_id)) {
    tag_id_query <- "True"
  } else {
    check_value(tag_id, valid_tag_ids, "tag_id")
    tag_id_query <- glue_sql("tag_id IN ({tag_id*})", .con = connection)
    include_ref_tags <- TRUE
  }

  # Build query
  query <- glue_sql("
    SELECT
      *
    FROM
      vliz.tags_view2
    WHERE
      {tag_id_query}
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
    arrange(factor(tag_id, levels = valid_tag_ids)) # valid_tag_ids defined above

  as_tibble(tags)
}
