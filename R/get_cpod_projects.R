#' Get cpod project data
#'
#' Get data for cpod projects, with options to filter results.
#'
#' @param cpod_project_code Character (vector). One or more cpod project
#'   codes. Case-insensitive.
#'
#' @return A tibble with animal project data, sorted by `project_code`.
#'
#' @inheritParams list_animal_ids
#' @inheritParams get_animal_projects
#' @export
#'
#' @examplesIf etn:::credentials_are_set()
#' # Get all animal projects
#' get_cpod_projects()
#'
#' # Get a specific animal project
#' get_cpod_projects(cpod_project_code = "cpod-lifewatch")
get_cpod_projects <- function(connection,
                              cpod_project_code = NULL,
                              citation = FALSE) {
  # Check arguments
  # The connection argument has been deprecated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(protocol = select_protocol()) |>
    # Set the column classes explicitly
    dplyr::mutate(moratorium = as.logical(as.integer(.data$moratorium)))

  # Optionally add citation information from IMIS/MarineInfo
  if(citation){
    imis_dataset_ids <- unique(dplyr::pull(out, "imis_dataset_id"))
    citation_df <- cite_imis_dataset(imis_dataset_ids)

    out <- dplyr::full_join(out,
                            citation_df,
                            by = dplyr::join_by("imis_dataset_id"))
  }

  # Return the animal project data
  out
}
