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
  citation_df <- imis_metadata[["dois"]]
  citations <- dplyr::pull(citation_df, "Citation")

  acronym <- purrr::chuck(imis_metadata, "datasetrec", "Acronym")
  title <- purrr::chuck(imis_metadata, "datasetrec", "StandardTitle")
  doi_urls <- glue::glue_col("https://doi.org/",
                                   dplyr::pull(citation_df, "DOI"))
  cli::cli_h2("{acronym} : {title}")
  cli::cli_ul("{citations}. {.url {doi_urls}}")
}
