#' List all available tag ids
#'
#' @param connection A valid connection to the ETN database.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all unique `tag_id` present in `tags`.
list_tag_ids <- function(connection = con) {
  query <- glue_sql("SELECT DISTINCT tag_id FROM vliz.tags_view2",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$tag_id
}
