#' List all available network receiver ids
#'
#' @param connection A valid connection to the ETN database.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all unique `receiver_id` present in `receivers`.
list_receiver_ids <- function(connection) {
  query <- glue_sql("SELECT DISTINCT receiver_id FROM vliz.receivers_view2",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$receiver_id
}
