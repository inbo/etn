#' Get tag metadata
#'
#' Get metadata for tags, with option to filter on tag id. By default, reference
#' tags are excluded.
#'
#' @param connection A valid connection with the ETN database.
#' @param tag_id (string) One or more tag ids.
#' @param include_ref_tags (logical) Include reference tags. Default:
#'   `FALSE`.
#'
#' @return A tibble (tidyverse data.frame).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr pull %>% as_tibble
#' @importFrom rlang .data
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
  if (is.null(tag_id)) {
    tag_id_query <- "True"
  } else {
    valid_tag_ids <- list_tag_ids(connection)
    check_value(tag_id, valid_tag_ids, "tag_id")
    tag_id_query <- glue_sql("tag_id IN ({tag_id*})", .con = connection)
    include_ref_tags <- TRUE
  }

  # Build query
  query <- glue_sql("
    SELECT *
    FROM vliz.tags_view2
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

  as_tibble(tags)
}
