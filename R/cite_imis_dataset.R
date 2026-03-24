#' Get the citation and associated first author information for an IMIS dataset.
#'
#' This function returns the the citations and some information for the first
#' author for a dataset as stored on [IMIS](https://www.vliz.be/nl/imis) These
#' citations will be retrieved from
#' [MarineInfo](https://https://marineinfo.org).
#'
#' @inheritParams get_acoustic_projects
#' @param imis_dataset_ids A vector of IMIS dataset ids as returned by
#'   `get_acoustic_projects()` or `get_animal_projects()`.
#'
#' @returns A data.frame with 5 columns:
#'  - The `imis_dataset_id`
#'  - A formatted `citation` with DOI if available.
#'  - The `doi`.
#'  - The contact person, usually the first author. If no contact person is entered, the first author with status creator..
#'  - The corresponding `email`.
#'  - The corresponding `institute`.
#' @family citation helpers
#' @noRd
#'
#' @examplesIf interactive() # Cite the 2014_gudena acoustic project:
#'   cite_imis_dataset(8856)
cite_imis_dataset <- function(imis_dataset_ids = NULL) {

  # Handle missing IMIS dataset ids -----------------------------------------
  if (all(is.na(imis_dataset_ids))) {
    # Early return: if all dataset ids are NA, return an empty tibble with the
    # correct column names.
    return(
      dplyr::tibble(
        imis_dataset_id = NA,
        citation = NA,
        doi = NA,
        name = NA,
        email = NA,
        institute = NA
      )
    )
  }

  if (any(is.na(imis_dataset_ids))) {
    # Still query for any non NA dataset_ids.
    imis_dataset_ids <- imis_dataset_ids[!is.na(imis_dataset_ids)]
  }

  # Query the IMIS API ------------------------------------------------------

  marineinfo_dataset_endpoints <-
    glue::glue("https://marineinfo.org/id/dataset/{imis_dataset_ids}.json")

  marineinfo_metadata <-
    purrr::map(marineinfo_dataset_endpoints, jsonlite::fromJSON) |>
    # Set names to acronym, get_acoustic_projects() doesn't guarantee order of
    # results so we can't just get this from the acoustic_project_codes argument
    (\(returned_list) {
      purrr::set_names(returned_list,
                       purrr::map(returned_list, list("datasetrec", "DasID")))
    })()

  # Parse the Citation and DOI ----------------------------------------------

  # If there is no citation, return an empty string. If there is a doi, append
  # it with the `doi:` prefix and end on a period.
  marineinfo_citation <- purrr::map(marineinfo_metadata, "datasetrec") |>
    purrr::map(\(datasetrec) {
      dplyr::tibble(citation =
                      # Convert to character so the returned colclasses are as
                      # close to base as possible
      as.character(glue::glue(
        "{citation}.{doi_prefix}{doi}{doi_suffix}",
        citation = purrr::pluck(datasetrec, "Citation", .default = ""),
        doi = purrr::pluck(datasetrec, "DOI", .default = ""),
        doi_prefix = ifelse(doi != "", " doi:", ""),
        doi_suffix = ifelse(doi != "", ".", "")
      )),
      doi = purrr::pluck(datasetrec, "DOI", .default = NA)
      )
    }) |>
    purrr::list_rbind(names_to = "imis_dataset_id")

  # Parse the person information --------------------------------------------

  marineinfo_ownerships <- purrr::map(marineinfo_metadata, list("ownerships")) |>
    # Don't parse datasets without ownership information
    purrr::compact() |>
    purrr::map(\(ownership_df) {
      dplyr::filter(ownership_df, .data$OrderNr == 1)
    }) |>
    purrr::map(\(ownership_df) {
      dplyr::mutate(
        ownership_df,
        name = paste(.data$Surname, .data$Firstname),
        email = .data$Email,
        institute = .data$FullAcronym,
        .keep = "none"
      )
    }) |>
    purrr::list_rbind(names_to = "imis_dataset_id")

  # Combine the parsed information ------------------------------------------

  dplyr::full_join(
    marineinfo_citation,
    marineinfo_ownerships,
    dplyr::join_by("imis_dataset_id")
  ) |>
    dplyr::mutate(
      # Return as integer to match input.
      imis_dataset_id = as.integer(imis_dataset_id)
    ) |>
    # Return as tibble to be consistent within the package. Displays nice.
    dplyr::as_tibble()
}
