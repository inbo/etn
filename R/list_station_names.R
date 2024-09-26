#' List all available station names
#'
#' @inheritParams list_animal_ids
#' @return A vector of all unique `station_name` present in
#'   `acoustic.deployments`.
#'
#' @export
list_station_names <- function(connection,
                               api = TRUE) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api, json = TRUE)
  return(out)
}
#' list_station_names() sql helper
#'
#' @inheritParams list_station_names()
#' @noRd
#'
list_station_names_sql <- function(){
  # Create connection
  connection <- create_connection(credentials = get_credentials())
  # Check connection
  check_connection(connection)

  query <- glue::glue_sql(
    "SELECT DISTINCT station_name FROM acoustic.deployments WHERE station_name IS NOT NULL",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return station_names
  stringr::str_sort(data$station_name, numeric = TRUE)
}
