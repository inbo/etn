#' Get acoustic detections data
#'
#' Get data for acoustic detections, with options to filter results. Use
#' `limit` to limit the number of returned records.
#'
#' @param start_date Character. Start date (inclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param end_date Character. End date (exclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param acoustic_tag_id Character (vector). One or more acoustic tag ids.
#' @param animal_project_code Character (vector). One or more animal project
#'   codes. Case-insensitive.
#' @param scientific_name Character (vector). One or more scientific names.
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
#' @param deployment_id Character (vector). One or more deployment ids.
#' @param receiver_id Character (vector). One or more receiver identifiers.
#' @param station_name Character (vector). One or more deployment station
#'   names.
#' @param limit Logical. Limit the number of returned records to 100 (useful
#'   for testing purposes). Defaults to `FALSE`.
#' @param progress Logical. Show a progress bar while fetching data. Defaults to
#'   `TRUE`.
#' @inheritParams list_animal_ids
#'
#' @return A tibble with acoustic detections data, sorted by `acoustic_tag_id`
#'  and `date_time`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @examples
#' # Get limited sample of acoustic detections
#' get_acoustic_detections(limit = TRUE)
#'
#' # Get all acoustic detections from a specific animal project
#' get_acoustic_detections(animal_project_code = "2014_demer")
#'
#' # Get 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   animal_project_code = "2014_demer",
#'   start_date = "2015",
#'   end_date = "2016",
#' )
#'
#' # Get April 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   animal_project_code = "2014_demer",
#'   start_date = "2015-04",
#'   end_date = "2015-05",
#' )
#'
#' # Get April 24, 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   animal_project_code = "2014_demer",
#'   start_date = "2015-04-24",
#'   end_date = "2015-04-25",
#' )
#'
#' # Get acoustic detections for a specific tag at two specific stations
#' get_acoustic_detections(
#'   acoustic_tag_id = "A69-1601-16130",
#'   station_name = c("de-9", "de-10")
#' )
#'
#' # Get acoustic detections for a specific species, receiver and acoustic project
#' get_acoustic_detections(
#'   scientific_name = "Rutilus rutilus",
#'   receiver_id = "VR2W-124070",
#'   acoustic_project_code = "demer"
#' )
get_acoustic_detections <- function(connection,
                                    start_date = NULL,
                                    end_date = NULL,
                                    acoustic_tag_id = NULL,
                                    animal_project_code = NULL,
                                    scientific_name = NULL,
                                    acoustic_project_code = NULL,
                                    deployment_id = NULL,
                                    receiver_id = NULL,
                                    station_name = NULL,
                                    limit = FALSE,
                                    progress = TRUE,
                                    api = TRUE) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  assertthat::assert_that(assertthat::is.flag(api))
  assertthat::assert_that(assertthat::is.flag(limit))

  # Control progress reporting
  # Don't show the progress bar when testing: clutters up console and CI output
  if (is_testing()) {
    progress <- FALSE
  }
  # Only show the progress bar if less than 50% of records have been fetched in
  # 24h
  if (!progress) {
    withr::local_options(cli.progress_show_after = 60 * 60 * 24)
  }
  # Some arguments don't need to be send to etnservice
  arguments_to_pass <-
    return_parent_arguments(depth = 1)[
      !names(return_parent_arguments(depth = 1)) %in% c(
        "api",
        "progress",
        "connection",
        "limit" # handled client side
      )
    ]

  # Initialize progress bar
  cli::cli_progress_bar(auto_terminate = FALSE)

  # Calculate the number of records we expect: for progress bar + page_size
  n_records_expected <-
    if (limit) {
      # If limit is set to TRUE, we expect 100 records
      100
    } else {
      # otherwise query the number of records

      do.call(count_acoustic_detections, append(
        arguments_to_pass,
        list(api = api)
      ))
    }

  # Return early if query didn't result in any rows
  if (n_records_expected == 0) {
    return(
      dplyr::tibble(
        .rows = 0,
        detection_id = NA,
        date_time = NA,
        tag_serial_number = NA,
        acoustic_tag_id = NA,
        animal_project_code = NA,
        animal_id = NA,
        scientific_name = NA,
        acoustic_project_code = NA,
        receiver_id = NA,
        station_name = NA,
        deploy_latitude = NA,
        deploy_longitude = NA,
        sensor_value = NA,
        sensor_unit = NA,
        sensor2_value = NA,
        sensor2_unit = NA,
        signal_to_noise_ratio = NA,
        source_file = NA,
        qc_flag = NA,
        deployment_id = NA
      )
    )
  }

  # Control number of objects to fetch per page, 100k default, up to 1M for
  # big queries
  page_size <- dplyr::case_when(
    limit ~ 100,
    n_records_expected > 5e6 ~ 1e6,
    .default = 100000
  )

  # Update progress bar with total number of pages expected: plus one for the
  # count query
  n_pages_expected <- ceiling(n_records_expected / page_size)
  cli::cli_progress_update(total = n_pages_expected + 1)

  # Init object to store pages
  combined_results <- list()

  # Fetch credentials only once and reuse for every page
  if (!api) credentials <- get_credentials()

  repeat {
    # Pagination arguments
    # If not set, next_id_pk starts at 0 (used to paginate), page_size at 100k.
    # Also includes credentials.
    pagination_arguments <-
      mget(
        # Get the following objects from the enclosing frame
        c("next_id_pk", "page_size", "credentials"),
        # With the following default values if not set:
        ifnotfound = list(0, 100000, NULL),
        inherits = FALSE
      )

    # Combine arguments to pass to helper function
    payload <- append(arguments_to_pass, pagination_arguments)

    # Decide what helper to use, add any extra required arguments
    if (api) {
      helper_to_use <- forward_to_api
      arguments_for_helper <-
        list(
          function_identity = "get_acoustic_detections_page",
          payload = payload
        )
    } else {
      helper_to_use <- etnservice::get_acoustic_detections_page
      arguments_for_helper <- payload
    }

    # Fetch page
    fetched_page <- do.call(helper_to_use, arguments_for_helper)

    # Iterate the progress bar by one page
    cli::cli_progress_update(inc = 1)

    # The next page will be fetched with detection_ids higher than the current
    # max detection_id
    next_id_pk <- max(fetched_page$detection_id)

    # store page: use next_id_pk as name to avoid iterating page number
    combined_results[[as.character(next_id_pk)]] <- fetched_page

    # Iterate the progress bar: we fetched one page
    cli::cli_progress_update(inc = 1)

    if (nrow(fetched_page) < page_size || limit) {
      # Page isn't full = end of results.
      cli::cli_progress_done()
      break
    }
  }

  # Combine pages and sort on acoustic_tag_id
  dplyr::bind_rows(combined_results) %>%
    dplyr::arrange(stringr::str_rank(.data$acoustic_tag_id, numeric = TRUE))
}

#' Count acoustic detections
#'
#' Count the number of acoustic detections that match the given parameters. This
#' is a helper function that uses
#' [`get_acoustic_detections_page()`][etnservice::get_acoustic_detections_page]
#' to count the number of records that would be returned by
#' [`get_acoustic_detections()`][get_acoustic_detections].
#'
#'
#' @inheritDotParams get_acoustic_detections start_date end_date detection_id acoustic_tag_id animal_project_code scientific_name acoustic_project_code receiver_id station_name api
#' @inheritParams get_acoustic_detections
#'
#' @return A numeric value with the number of acoustic detections that match the
#'     given parameters.
#' @family helper functions
#' @noRd
#' @examples
#' count_acoustic_detections(acoustic_project_code = "demer")
#' count_acoustic_detections(
#'   acoustic_tag_id = "A69-1601-16130",
#'   station_name = c("de-9", "de-10")
#' )
count_acoustic_detections <- function(..., api = TRUE) {
  if (api) {
    returned_count <- forward_to_api("get_acoustic_detections_page",
      payload = append(
        rlang::list2(...),
        list(count = TRUE)
      ),
      json = TRUE
    )
  } else {
    returned_count <- do.call(etnservice::get_acoustic_detections_page,
      args = append(
        rlang::list2(...),
        list(count = TRUE)
      )
    )
  }

  dplyr::pull(returned_count, "count") |>
    # If the count class is not numeric, convert it. DBI returns Integer64 which
    # causes issues with cli progress bars
    as.numeric()
}
