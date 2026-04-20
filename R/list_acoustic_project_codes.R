#' List all available acoustic project codes
#'
#' @inheritParams list_animal_ids
#' @return A vector of all unique `project_code` of `type = "acoustic"` in
#'   `project.sql`.
#' @family list functions
#' @export
#' @examplesIf etn:::credentials_are_set()
#' list_acoustic_project_codes()
list_acoustic_project_codes <- function(connection) {
  # Check arguments
  # The connection argument has been deprecated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  conduct_parent_to_helpers(protocol = select_protocol(), json = TRUE)
}
