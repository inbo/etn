#' Get the citation and associated first author information for an IMIS dataset.
#'
#' This function returns the the citations and some information for the first
#' author for a dataset as stored on [IMIS](https://www.vliz.be/nl/imis) These
#' citations will be retrieved from
#' [MarineInfo](https://https://marineinfo.org).
#'
#' @inheritParams get_acoustic_projects
#' @param imis_dataset_ids A vector of IMIS dataset ids as returned by
#'   `get_acoustic_projects()`, `get_animal_projects()` or
#'   `get_cpod_projects()`.
#' @param warn Logical. If `TRUE`, return a warning if any of the API requests
#'   fail, with the IMIS dataset id and error message for each failed request.
#' @param progress Logical. If `TRUE`, show a progress bar for the API requests.
#'   Default is `TRUE`, but will be automatically set to `FALSE` when testing to
#'   avoid cluttering testthat output.
#'
#' @returns A data.frame with 5 columns:
#'  - The `imis_dataset_id`
#'  - A formatted `citation` with DOI if available.
#'  - The `doi`.
#'  - The contact person, usually the first author. If no contact person is
#'   entered, the first author with status creator.
#'  - The corresponding `contact_email`.
#'  - The corresponding `contact_affiliation`.
#' @family citation helpers
#' @noRd
#'
#' @examplesIf interactive()
#' # Cite the 2014_gudena acoustic project:
#'   cite_imis_dataset(8856)
cite_imis_dataset <- function(imis_dataset_ids = NULL,
                              warn = FALSE,
                              progress = TRUE) {
  # Handle missing IMIS dataset ids -----------------------------------------
  early_return_object <-
    dplyr::tibble(
      imis_dataset_id = integer(),
      citation = character(),
      doi = character(),
      contact_name = character(),
      contact_email = character(),
      contact_affiliation = character()
    )

  if (all(is.na(imis_dataset_ids))) {
    # Early return: if all dataset ids are NA, return an empty tibble with the
    # correct column names.
    return(early_return_object)
  }

  if (any(is.na(imis_dataset_ids))) {
    # Still query for any non NA dataset_ids.
    imis_dataset_ids <- imis_dataset_ids[!is.na(imis_dataset_ids)]
  }

  # Query the IMIS API ------------------------------------------------------

  marineinfo_dataset_endpoints <-
    glue::glue("https://vliz.be/en/imis?dasid={imis_dataset_ids}&show=json")

  marineinfo_responses <-
    purrr::map(marineinfo_dataset_endpoints, httr2::request) |>
    # Retry if a request fails, max_tries is ignored for parallel requests but
    # will message if unset.
    purrr::map(httr2::req_retry, max_tries = 2) |>
    # Never place more then 2 requests a second
    purrr::map(\(req) httr2::req_throttle(req,
                                          capacity = 120,
                                          fill_time_s = 60)) |>
    httr2::req_perform_parallel(
      on_error = "continue",
      # Don't show progress bar when testing to avoid
      # cluttering testthat output, or when disabled.
      progress = ifelse(progress & !is_testing(),
        yes = "Getting citations",
        no = FALSE
      )
    )
  # Discard any responses that contain errors
  succesful_responses <- marineinfo_responses |>
    purrr::discard(rlang::is_condition)

  # Return a warning for any failed requests if any failed
  if (any(purrr::map_lgl(marineinfo_responses, rlang::is_condition)) && warn) {
    failed_ids <- marineinfo_responses |>
      purrr::keep(rlang::is_condition) |>
      purrr::map("resp", "url") |>
      purrr::map(\(resp) {
        purrr::set_names(
          httr2::resp_body_json(resp),
          # Name the response by the IMIS id extracted from the response url
          stringr::str_extract(httr2::resp_url(resp), "[0-9]+")
        )
      }) |>
      purrr::map(\(error) {
        paste(names(error), paste(error, collapse = " : "))
      }) |>
      purrr::list_c() |>
      unique()

    rlang::warn(c("!" = "MarineInfo API returned errors:"),
      footer = purrr::set_names(failed_ids, "*"),
      class = "marineinfo_api_warning"
    )
  }

  # Early return if all requests failed
  if (length(succesful_responses) == 0) {
    return(early_return_object)
  }

  # Parse the JSON ----------------------------------------------------------

  marineinfo_metadata <-
    succesful_responses |>
    purrr::map(httr2::resp_body_json, simplifyDataFrame = TRUE) |>
    # Set names to acronym, get_acoustic_projects() doesn't guarantee order of
    # results so we can't just get this from the acoustic_project_codes argument
    (\(returned_list) {
      purrr::set_names(returned_list, purrr::map(
        returned_list,
        list("datasetrec", "DasID")
      ))
    })()

  # Parse the Citation and DOI ----------------------------------------------

  # If there is no citation, return an empty string. If there is a doi, append
  # it with the `doi:` prefix and end on a period.
  marineinfo_citation <-
    marineinfo_metadata |>
    purrr::map(\(dataset_metadata) {
      # Using str_c so an NA results in NA_character_
      doi <-
        stringr::str_c(
          "https://doi.org/",
          purrr::pluck(dataset_metadata, "dois", "DOI",
            .default = NA_character_
          )
        )
      citation_raw <-
        purrr::pluck(dataset_metadata, "datasetrec", "Citation",
          .default = NA_character_
        )
      dplyr::tibble(
        citation =
          stringr::str_c(
            # Naming parts of the string just for readability
            "citation" = citation_raw,
            # Add a period between the citation and the doi if the citation
            # doesn't already end on one, if there is no doi, don't mess with
            # the citation.
            "dot" = ifelse(
              !is.na(citation_raw) &
                !stringr::str_ends(citation_raw, stringr::fixed(".")) &
                !is.na(doi),
              yes = ".",
              no = NA_character_
            ),
            # Only add a space when there is a doi
            "space" = ifelse(
              !is.na(doi),
              yes = " ",
              no = NA_character_
            ),
            "doi" = doi
          ),
        doi = doi
      )
    }) |>
    purrr::list_rbind(names_to = "imis_dataset_id") |>
    # Replace empty strings with NA
    dplyr::mutate(dplyr::across(dplyr::all_of("citation"), \(string) {
      dplyr::na_if(string, "")
    })) |>
    # Replace `n.a.` string value with NA
    dplyr::mutate(dplyr::across(dplyr::all_of("citation"), \(string) {
      dplyr::na_if(string, "n.a.") # Very strict matching on exactly this string
    })) |>
    # Citations sometimes contain HTML formatting, let's remove them.
    dplyr::mutate(dplyr::across(dplyr::all_of("citation"), \(string) {
      remove_html_tags(string)
    }))


  # Parse the person information --------------------------------------------

  marineinfo_ownerships <-
    purrr::map(marineinfo_metadata, \(dataset) {
      purrr::pluck(
        dataset,
        "ownerships",
        .default = dplyr::tibble(
          OrderNr = 1L,
          Firstname = NA_character_,
          Surname = NA_character_,
          Email = NA_character_,
          StandardName = NA_character_
        )
      )
    }) |>
    purrr::compact() |>
    purrr::map(\(ownership_df) {
      # Take the lowest rated owner, sometimes OrderNr 1 is missing.
      dplyr::slice_min(
        ownership_df,
        n = 1,
        order_by = .data$OrderNr,
        # Do not support shared first authorship
        with_ties = FALSE
      )
    }) |>
    purrr::map(\(ownership_df) {
      dplyr::mutate(
        ownership_df,
        # Support missing fields, fall back to NA.
        contact_name = stringr::str_c(.data$Firstname,
                                      .data$Surname,
                                      sep = " "),
        contact_email = purrr::pluck(ownership_df,
                                     "Email",
                                     .default = NA_character_),
        contact_affiliation = purrr::pluck(ownership_df,
                                           "StandardName",
                                           .default = NA_character_),
        .keep = "none"
      )
    }) |>
    purrr::list_rbind(names_to = "imis_dataset_id")

  # Combine the parsed information ------------------------------------------

  dplyr::full_join(
    marineinfo_citation,
    marineinfo_ownerships,
    dplyr::join_by("imis_dataset_id"),
    relationship = "many-to-many"
  ) |>
    dplyr::mutate(
      # Return as integer to match input.
      imis_dataset_id = as.integer(.data$imis_dataset_id)
    ) |>
    # Return as tibble to be consistent within the package. Displays nice.
    dplyr::as_tibble()
}
