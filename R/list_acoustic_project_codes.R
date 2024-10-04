#' List all available acoustic project codes
#'
#'
#' @return A vector of all unique `project_code` of `type = "acoustic"` in
#'   `project.sql`.
#'
#' @inheritParams list_animal_ids
#' @export
list_acoustic_project_codes <- function(connection,
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
