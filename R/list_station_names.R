#' List all available station names
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `station_name` present in
#'   `acoustic.deployments`.
#'
#' @export
list_station_names <- function(api = TRUE,
                               connection) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection(function_identity)
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api)
  return(out)
}
#' list_station_names() sql helper
#'
#' @inheritParams list_station_names()
#' @noRd
#'
list_station_names_sql <- function(){
  # Create connection
  connection <- do.call(connect_to_etn, get_credentials())
  # Check connection
  check_connection(connection)

  query <- glue::glue_sql(
    "SELECT DISTINCT station_name FROM acoustic.deployments WHERE station_name IS NOT NULL",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  stringr::str_sort(data$station_name, numeric = TRUE)
}
