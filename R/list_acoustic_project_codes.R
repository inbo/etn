#' List all available acoustic project codes
#'
#'
#' @return A vector of all unique `project_code` of `type = "acoustic"` in
#'   `project.sql`.
#'
#' @inheritParams list_animal_ids
#' @export
#'
#' @examples
#' list_acoustic_project_codes()
list_acoustic_project_codes <- function(connection) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  conduct_parent_to_helpers(protocol = select_protocol(), json = TRUE)
}
