#' Get animal project data
#'
#' Get data for animal projects, with options to filter results.
#'
#' @param animal_project_code Character (vector). One or more animal project
#'   codes. Case-insensitive.
#' @param citation Logical. If `TRUE`, add citation information from IMIS/MarineInfo for each
#'  project, based on the `imis_dataset_id` field. This will add the following columns to the output:
#'  - `citation`: A formatted citation with DOI if available.
#'  - `doi`: The DOI for the dataset if available.
#'  - `name`: The contact person, usually the first author. If no contact person is entered, the first author with status creator.
#'  - `email`: The email of the contact person.
#'  - `institute`: The institute of the contact person.
#'
#' @inheritParams list_animal_ids
#' @return A tibble with animal project data, sorted by `project_code`. See
#'   also
#'   [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
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
                                animal_project_code = NULL,
                                citation = FALSE) {
  # Check arguments
  # The connection argument has been deprecated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(protocol = select_protocol(),
                                   ignored_arguments = "citation") |>
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
