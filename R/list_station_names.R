#' List all available station names
#'
#' @inheritParams list_animal_ids
#' @return A vector of all unique `station_name` present in
#'   `acoustic.deployments`.
#'
#' @export
list_station_names <- function(connection) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  conduct_parent_to_helpers(protocol = select_protocol(), json = TRUE)
}
