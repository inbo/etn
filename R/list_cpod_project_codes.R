#' List all available cpod project codes
#'
#' @inheritParams list_animal_ids
#' @return A vector of all unique `project_code` of `type = "cpod"` in
#'   `project.sql`.
#'
#' @export
list_cpod_project_codes <- function(connection, api = TRUE){
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api, json = TRUE)
  return(out)
}

