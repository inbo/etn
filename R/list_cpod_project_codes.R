#' List all available cpod project codes
#'
#' @inheritParams list_animal_ids
#' @return A vector of all unique `project_code` of `type = "cpod"` in
#'   `project.sql`.
#'
#' @export
#'
#' @examplesIf etn:::credentials_are_set()
#' list_cpod_project_codes()
list_cpod_project_codes <- function(connection) {
  # Check arguments
  # The connection argument has been deprecated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  conduct_parent_to_helpers(protocol = select_protocol(), json = TRUE)
}
