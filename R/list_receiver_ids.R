#' List all available receiver ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `receiver` present in `acoustic.receivers`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom stringr str_sort
list_receiver_ids <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT receiver FROM acoustic.receivers",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  str_sort(data$receiver, numeric = TRUE)
}
