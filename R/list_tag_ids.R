#' List all available tag ids
#'
#' @param connection A valid connection to the ETN database.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom stringr str_sort
#'
#' @return A vector of all unique `tag_id` present in `tags_view2`.
list_tag_ids <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT tag_id FROM vliz.tags_view2",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  str_sort(data$tag_id, numeric = TRUE)
}
