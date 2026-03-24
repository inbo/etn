#' Get acoustic project data
#'
#' Get data for acoustic projects, with options to filter results.
#'
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
#'
#' @return A tibble with acoustic project data, sorted by `project_code`.
#'
#' @inheritParams list_animal_ids
#' @export
#'
#' @examplesIf etn:::credentials_are_set()
#' # Get all acoustic projects
#' get_acoustic_projects()
#'
#' # Get a specific acoustic project
#' get_acoustic_projects(acoustic_project_code = "demer")
get_acoustic_projects <- function(connection,
                                  acoustic_project_code = NULL) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(protocol = select_protocol()) |>
    # Set the column classes explicitly
    dplyr::mutate(moratorium = as.logical(as.integer(.data$moratorium)))

  return(out)
}
