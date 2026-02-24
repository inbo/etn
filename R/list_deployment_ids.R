#' List all available receiver ids
#'
#' @inheritParams list_animal_ids
#' @return A vector of all unique `id_pk` present in `acoustic.deployments`.
#'
#' @export
#'
#' @examples
#' list_deployment_ids()
list_deployment_ids <- function(connection) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  conduct_parent_to_helpers(protocol = select_protocol(), json = TRUE) |>
    # Set the column classes explicitly
    as.integer()
}
