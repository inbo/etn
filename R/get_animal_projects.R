#' Get animal project data
#'
#' Get data for animal projects, with options to filter results.
#'
#' @param animal_project_code Character (vector). One or more animal project
#'   codes. Case-insensitive.
#'
#' @inheritParams list_animal_ids
#' @return A tibble with animal project data, sorted by `project_code`. See
#'   also
#'   [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @examples
#' # Get all animal projects
#' get_animal_projects()
#'
#' # Get a specific animal project
#' get_animal_projects(animal_project_code = "2014_demer")
get_animal_projects <- function(connection,
                                animal_project_code = NULL,
                                api = TRUE){
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api)
  return(out)
}

#' get_animal_projects() sql helper
#'
#' @inheritParams get_animal_projects()
#' @noRd
#'
get_animal_projects_sql <- function(animal_project_code = NULL) {
  do.call(getFromNamespace("get_animal_projects", ns = "etnservice"),
          args = list(credentials = get_credentials(),
                      animal_project_code = animal_project_code)
  )
}
