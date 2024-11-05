#' Get acoustic project data
#'
#' Get data for acoustic projects, with options to filter results.
#'
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
#'
#' @return A tibble with acoustic project data, sorted by `project_code`. See
#'   also
#'   [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @inheritParams list_animal_ids
#' @export
#'
#' @examples
#' # Get all acoustic projects
#' get_acoustic_projects()
#'
#' # Get a specific acoustic project
#' get_acoustic_projects(acoustic_project_code = "demer")
get_acoustic_projects <- function(connection,
                                  acoustic_project_code = NULL,
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
