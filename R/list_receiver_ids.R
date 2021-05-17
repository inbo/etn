#' List all available receiver ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom stringr str_sort
#'
#' @return A vector of all unique `receiver_id` present in `receivers_view2`.
list_receiver_ids <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT receiver_id FROM acoustic.receivers_view2 ORDER BY receiver_id",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  str_sort(data$receiver_id, numeric = TRUE)
}
