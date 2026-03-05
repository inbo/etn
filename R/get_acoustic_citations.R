#' Get Acoustic Citations
#'
#' This function returns the the citations for all acoustic (= network) projects
#' included in a dataset. These citations will be retrieved from
#' [IMIS](https://www.vliz.be/nl/imis).
#'
#' @inheritParams get_acoustic_projects
#'
#' @returns (Invisible) A tibble with the citations for the specified acoustic
#'   projects. And prints to console the formatted citations as shown on IMIS.
#' @export
#'
#' @examples
#' get_acoustic_citations("2004_Gudena")
get_acoustic_citations <- function(acoustic_project_code = NULL) {
  # Check if required packages are installed --------------------------------
  rlang::check_installed("jsonlite",
    reason = "To read metadata from the IMIS/MarineINFO API"
  )

    # Query the IMIS dataset ids ----------------------------------------------
  imis_dataset_ids <-
    get_acoustic_projects(acoustic_project_code = acoustic_project_code) |>
    dplyr::pull("imis_dataset_id")

  # Query the IMIS API ------------------------------------------------------

  marineinfo_dataset_endpoints <-
    glue::glue("https://marineinfo.org/id/dataset/{imis_dataset_ids}.json")

  imis_metadata <-
    purrr::map(marineinfo_dataset_endpoints, jsonlite::fromJSON) |>
    # Set names to acronym, get_acoustic_projects() doesn't guarantee order of
    # results so we can't just get this from the acoustic_project_codes argument
    (\(returned_list) {
      purrr::set_names(
        returned_list,
        purrr::map(
          returned_list,
          list("datasetrec", "Acronym")
        )
      )
    })()

  # Parse the returned value ------------------------------------------------

  # Get dataset title and acroynm
  acronym <- purrr::map(imis_metadata, list("datasetrec", "Acronym"))
  title <- purrr::map(imis_metadata, list("datasetrec", "StandardTitle"))
  citations <- purrr::map(imis_metadata, list("datasetrec", "Citation"),
                          .default = NA) |>
    # Citations sometimes contain HTML formatting, let's remove them.
    purrr::map(remove_html_tags)

  if (any(is.na(citations))) {
    rlang::warn(
      message = glue::glue("No citation found on IMIS for: {names(citations)[is.na(citations)]}"),
      class = "etn_no_citation_found"
    )
  }

  # Drop any acoustic project codes for which no Citations exist
  imis_metadata <-
    imis_metadata |>
    purrr::discard(~ is.na(purrr::pluck(.x, "datasetrec", "Citation",
      .default = NA
    )))


  # If a doi is registered, fetch and format it
  publication_dois <-
    purrr::map(imis_metadata, list("dois", "DOI"), .default = NA)
  doi_urls <-
    glue::glue("https://doi.org/","{publication_dois}",
               .na = NULL)
  # Format and output the citation
  cli::cli_h2("{acronym} : {title}")
  cli::cli_ul(paste(
    "{citations}",
    ifelse(is.null(citation_df), yes = "", no = "{.url {doi_urls}}")
  ))


  # Invisibly return citations ----------------------------------------------
  invisible(citation_df)
}
