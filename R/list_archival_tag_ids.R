#' List all available archival tag ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom stringr str_sort
#'
#' @return A vector of all unique `id_code` present in `archive.sensor`.
list_archival_tag_ids <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT id_code FROM archive.sensor",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  str_sort(data$id_code, numeric = TRUE)
}
