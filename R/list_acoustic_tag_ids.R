#' List all available acoustic tag ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom stringr str_sort
#' @importFrom readr read_file
#'
#' @return A vector of all unique `acoustic_tag_id` present in `tag.sql`.
list_acoustic_tag_ids <- function(connection = con) {
  tag_query <- glue_sql(read_file(system.file("sql", "tag.sql", package = "etn")), .con = connection)
  query <- glue_sql(
    "SELECT DISTINCT acoustic_tag_id FROM ({tag_query}) AS tag WHERE acoustic_tag_id IS NOT NULL",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  str_sort(data$acoustic_tag_id, numeric = TRUE)
}
