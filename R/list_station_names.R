#' List all available station names
#'
#' @param connection A valid connection to the ETN database.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all unique `station_name` present in `deployments`.
list_station_names <- function(connection) {
  query <- glue_sql("SELECT DISTINCT station_name FROM vliz.deployments_view2",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$station_name
}
