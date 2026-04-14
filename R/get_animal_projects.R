#' Get animal project data
#'
#' Get data for animal projects, with options to filter results.
#'
#' @param animal_project_code Character (vector). One or more animal project
#'   codes. Case-insensitive.
#'
#' @inheritParams list_animal_ids
#' 
#' @return A tibble with animal project data, sorted by `project_code`.
#'
#' @export
#'
#' @examplesIf etn:::credentials_are_set()
#' # Get all animal projects
#' get_animal_projects()
#'
#' # Get a specific animal project
#' get_animal_projects(animal_project_code = "2014_demer")
get_animal_projects <- function(connection,
                                animal_project_code = NULL) {
  # Check arguments
  # The connection argument has been deprecated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(protocol = select_protocol()) |>
    # Set the column classes explicitly
    dplyr::mutate(moratorium = as.logical(as.integer(.data$moratorium)))

  return(out)
}
