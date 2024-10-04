#' Get cpod project data
#'
#' Get data for cpod projects, with options to filter results.
#'
#' @param cpod_project_code Character (vector). One or more cpod project
#'   codes. Case-insensitive.
#'
#' @return A tibble with animal project data, sorted by `project_code`. See
#'   also
#'   [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @inheritParams list_animal_ids
#' @export
#'
#' @examples
#' # Get all animal projects
#' get_cpod_projects()
#'
#' # Get a specific animal project
#' get_cpod_projects(cpod_project_code = "cpod-lifewatch")
get_cpod_projects <- function(connection,
                              cpod_project_code = NULL,
                              api = TRUE) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api)
  return(out)
}
