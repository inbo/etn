#' List all available station names
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom stringr str_sort
#'
#' @return A vector of all unique `station_name` present in `deployments_view2`.
list_station_names <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT station_name FROM acoustic.deployments_view2",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  str_sort(data$station_name, numeric = TRUE)
}
