#' List all available station names
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `station_name` present in
#'   `acoustic.deployments`.
#'
#' @export
list_station_names <- function(connection = con) {
  query <- glue::glue_sql(
    "SELECT DISTINCT station_name FROM acoustic.deployments WHERE station_name IS NOT NULL",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  stringr::str_sort(data$station_name, numeric = TRUE)
}
