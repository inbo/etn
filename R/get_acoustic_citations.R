#' Get Acoustic Citations
#'
#' This function returns the the citations for all acoustic (= network) projects
#' included in a dataset. These citations will be retrieved from
#' [IMIS](https://www.vliz.be/nl/imis).
#'
#' @inheritParams get_acoustic_projects
#'
#' @returns (Invisible) A named vector citations for the specified acoustic
#'   projects. And prints to console the formatted citations as shown on IMIS.
#' @export
#'
#' @examples
#' get_acoustic_citations("2004_Gudena")
get_acoustic_citations <- function(acoustic_project_code = NULL) {
  # Query the IMIS dataset ids ----------------------------------------------
  imis_dataset_ids <-
    get_acoustic_projects(acoustic_project_code = acoustic_project_code) |>
    dplyr::pull("imis_dataset_id")


  # Handle missing IMIS dataset ids -----------------------------------------

  if (all(is.na(imis_dataset_ids))) {
    cli::cli_abort(
      message =
        "No IMIS dataset ids found for: {codes_col}",
        .envir = list2env(list(codes_col = glue::glue_collapse(acoustic_project_code,
                                        sep = ", ",
                                        last = " & ")))
      ,
      class = "etn_none_imis_dataset_id"
    )
    return(invisible(NULL))
  }

  if(any(is.na(imis_dataset_ids))) {
    cli::cli_warn(
      message = "No IMIS dataset ids found for: {codes_col}",
      .envir = list2env(list(codes_col = acoustic_project_code[is.na(imis_dataset_ids)])),
      class = "etn_some_imis_dataset_id"
    )

    imis_dataset_ids <-
      imis_dataset_ids[!is.na(imis_dataset_ids)]
  }

  # Query the IMIS API ------------------------------------------------------

  marineinfo_dataset_endpoints <-
    glue::glue("https://marineinfo.org/id/dataset/{imis_dataset_ids}.json")

  imis_metadata <-
    purrr::map(marineinfo_dataset_endpoints, from_json) |>
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

  # Attempt to read citations for all acoustic project codes from the api
  # response
  citations <- purrr::map(imis_metadata, list("datasetrec", "Citation"),
                          .default = NA) |>
    # Citations sometimes contain HTML formatting, let's remove them.
    purrr::map(remove_html_tags)

  if (any(is.na(citations))) {
    cli::cli_warn(
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

  citations <- purrr::discard(citations, is.na)

  # Get dataset title and acroynm
  acronym <- purrr::map(imis_metadata, list("datasetrec", "Acronym")) |>
    purrr::map(remove_html_tags)
  title <- purrr::map(imis_metadata, list("datasetrec", "StandardTitle")) |>
    purrr::map(remove_html_tags)

  # If a doi is registered, fetch and format it
  publication_dois <-
    purrr::map(imis_metadata, list("dois", "DOI"), .default = NA)

  # Format and output the citation
  purrr::pwalk(list(acronym, title, citations, publication_dois), \(acronym, title, citations, publication_dois){
    cli::cli({
      cli::cli_h2("{acronym} : {title}")
      doi_urls <-
        glue::glue("https://doi.org/","{publication_dois}",
                   .na = NULL)
      cli::cli_ul(paste(
        "{citations}",
        ifelse(is.na(publication_dois), yes = "", no = "{.url {doi_urls}}")
      ))
    })
  })


  # Invisibly return citations ----------------------------------------------
  invisible(citations)
}
