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
    reason = "To read metadata from the IMIS API"
  )

  rlang::check_installed("purrr",
    reason = "For list wrangling, to help format the citations."
  )
  # Query the IMIS dataset ids ----------------------------------------------
  imis_dataset_ids <-
    get_acoustic_projects(acoustic_project_code = acoustic_project_code) |>
    dplyr::pull("imis_dataset_id")

  # Query the IMIS API ------------------------------------------------------

  imis_metadata <-
    httr2::request("https://www.vliz.be/en/imis") |>
    httr2::req_url_query(
      dasid = imis_dataset_ids,
      show = "json"
    ) |>
    httr2::req_get_url() |>
    jsonlite::fromJSON()


  # Parse the returned value ------------------------------------------------

  # Get dataset title and acroynm
  acronym <- purrr::chuck(imis_metadata, "datasetrec", "Acronym")
  title <- purrr::chuck(imis_metadata, "datasetrec", "StandardTitle")
  citations <- purrr::chuck(imis_metadata, "datasetrec", "Citation") |>
    # Citations sometimes contain HTML formatting, let's ignore it for now.
    remove_html_tags()

  if(is.null(citations)){
    cli::cli_warn("No citation found on IMIS for: {acoustic_project_code}")
  }
  # If a doi is registered, fetch and format it
  citation_df <- purrr::pluck(imis_metadata, "dois")
  if (!is.null(citation_df)) {
    # citations <- dplyr::pull(citation_df, "Citation")
    doi_urls <- glue::glue_col(
      "https://doi.org/",
      dplyr::pull(citation_df, "DOI")
    )
  }
  # Format and output the citation
  cli::cli_h2("{acronym} : {title}")
  cli::cli_ul(paste(
    "{citations}",
    ifelse(is.null(citation_df), yes = "", no = "{.url {doi_urls}}")
  ))


  # Invisibly return citations ----------------------------------------------
  invisible(citation_df)
}
