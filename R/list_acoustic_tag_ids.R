#' List all available acoustic tag ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom stringr str_sort
#'
#' @return A vector of all unique `tag_full_id` present in `acoustic.tags`.
list_acoustic_tag_ids <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT tag_full_id FROM acoustic.tags",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  str_sort(data$tag_full_id, numeric = TRUE)
}
