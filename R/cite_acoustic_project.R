#' Get Acoustic Citations
#'
#' This function returns the the citations for all acoustic (= network) projects
#' included in a dataset. These citations will be retrieved from
#' [IMIS](https://www.vliz.be/nl/imis).
#'
#' @inheritParams get_acoustic_projects
#' @param imis_dataset_ids A vector of IMIS dataset ids. This is an optional argument, if not provided, the function will attempt to retrieve the dataset ids using the `get_acoustic_projects()` function. This allows for more flexibility in case the user already has the dataset ids or wants to retrieve citations for a specific set of dataset ids without having to go through the process of retrieving acoustic project codes first.(Integer) IMIS dataset ids as returned by
#'   `get_acoustic_projects()`.
#'
#' @returns A data.frame with 5 columns:
#'  - The `acoustic_project_code`
#'  - A formatted `citation` with DOI if available
#'  - The `DOI`
#'  - The contact person, usually the first author. If no contact person is entered, the first author with status creator..
#'  - The corresponding `email`.
#'  - The corresponding `institute`.
#' @family citation helpers
#' @noRd
#'
#' @examplesIf interactive() # Cite the 2014_gudena acoustic project:
#' cite_acoustic_project(8856)
cite_acoustic_projects <- function(imis_dataset_ids = NULL) {
  # Query the IMIS API ------------------------------------------------------

  marineinfo_dataset_endpoints <-
    glue::glue("https://marineinfo.org/id/dataset/{imis_dataset_ids}.json")

  marineinfo_metadata <-
    purrr::map(marineinfo_dataset_endpoints, jsonlite::fromJSON) |>
    # Set names to acronym, get_acoustic_projects() doesn't guarantee order of
    # results so we can't just get this from the acoustic_project_codes argument
    (\(returned_list) {
      purrr::set_names(returned_list, purrr::map(returned_list, list("datasetrec", "Acronym")))
    })()

  # Parse the Citation and DOI ----------------------------------------------

  # If there is no citation, return an empty string. If there is a doi, append
  # it with the `doi:` prefix and end on a period.
  marineinfo_citation <- purrr::map(marineinfo_metadata, "datasetrec") |>
    purrr::map(\(datasetrec) {
      glue::glue(
        "{citation}.{doi_prefix}{doi}{doi_suffix}",
        citation = purrr::pluck(datasetrec, "Citation", .default = ""),
        doi = purrr::pluck(datasetrec, "DOI", .default = ""),
        doi_prefix = ifelse(doi != "", " doi:", ""),
        doi_suffix = ifelse(doi != "", ".", "")
      )
    }) |>
    purrr::map(\(citation) {
      data.frame(citation = citation)
    }) |>
    purrr::list_rbind(names_to = "acoustic_project_code")

  # Parse the person information --------------------------------------------

  marineinfo_ownerships <- purrr::map(marineinfo_metadata, list("ownerships")) |>
    purrr::map(\(ownership_df) {
      dplyr::filter(ownership_df, .data$OrderNr == 1)
    }) |>
    purrr::map(\(ownership_df) {
      dplyr::mutate(
        ownership_df,
        name = paste(.data$Surname, .data$Firstname),
        email = .data$Email,
        instituteFullAcronym = .data$FullAcronym,
        .keep = "none"
      )
    }) |>
    purrr::list_rbind(names_to = "acoustic_project_code")


  # Combine the parsed information ------------------------------------------

  purrr::reduce(
    list(marineinfo_citation, marineinfo_ownerships),
    dplyr::full_join
  )
}
