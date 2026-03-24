#' Get acoustic detections data
#'
#' Get data for acoustic detections, with options to filter results. Use
#' `limit` to limit the number of returned records.
#'
#' @param start_date Character. Start date (inclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param end_date Character. End date (exclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param tag_serial_number Character (vector). One or more acoustic tag serial
#'  numbers.
#' @param acoustic_tag_id Character (vector). One or more acoustic tag ids.
#' @param animal_project_code Character (vector). One or more animal project
#'   codes. Case-insensitive.
#' @param scientific_name Character (vector). One or more scientific names.
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
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
#'  and `date_time`.
#'
#' @export
#'
#' @examplesIf etn:::credentials_are_set()
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
                                    tag_serial_number = NULL,
                                    acoustic_tag_id = NULL,
                                    animal_project_code = NULL,
                                    scientific_name = NULL,
                                    acoustic_project_code = NULL,
                                    receiver_id = NULL,
                                    station_name = NULL,
                                    limit = FALSE,
                                    progress = TRUE) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  assertthat::assert_that(assertthat::is.flag(limit))

  # Decide how we're going to retrieve the data
  protocol <- select_protocol()

  # Control progress reporting
  # Don't show the progress bar when testing: clutters up console and CI output
  if (is_testing()) {
    progress <- FALSE
  }
  # Only show the progress bar if less than 50% of records have been fetched in
  # 24h: workaround to control progress reporting
  if (!progress) {
    withr::local_options(cli.progress_show_after = 60 * 60 * 24)
  }
  # Some arguments don't need to be sent to etnservice, drop arguments set to
  # NULL
  arguments_to_pass <-
    return_parent_arguments(depth = 1, compact = TRUE)[
      !names(return_parent_arguments(depth = 1)) %in% c(
        "api",
        "progress",
        "connection",
        "limit" # handled client side
      )
    ]

  # Estimate number of pages ------------------------------------------------

  # Calculate the number of records we expect: for progress bar + page_size
  # Report on this step as it can take a while for large queries
  if (progress) {
    # you need to init a message to pass it to cli, we'll update it as we get a
    # count
    exp_records_msg <- ""
    cli::cli_progress_step("Preparing {exp_records_msg}")
  }

  n_records_expected <-
    if (limit) {
      # If limit is set to TRUE, we expect 100 records
      100
    } else {
      # otherwise query the number of records

      do.call(count_acoustic_detections, append(
        arguments_to_pass,
        list(protocol = protocol)
      ))
    }

  # Update progress step with number of records we'll be fetching.
  if (progress) {
    exp_records_msg <-
      glue::glue(": will fetch {n_records_pretty} detections",
        n_records_pretty = prettyunits::pretty_num(n_records_expected)
      )
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
  if (limit) {
    # Only fetch 100 records
    page_size <- 100
  } else if (n_records_expected > 5e6) {
    # Increase page_size in case of over 5M records
    page_size <- 1e6
  } else {
    # default page size
    page_size <- 1e5
  }

  # Update progress bar with total number of pages expected: plus one for the
  # count query, this update doesn't count as a progress step. Otherwise we'd
  # have to add 1 more to the total number of steps.
  n_pages_expected <- ceiling(n_records_expected / page_size)

  # Fetch credentials only once and reuse for every page, if the call is
  # forwarded to openCPU, credentials are appended by default
  if (protocol != "opencpu") credentials <- get_credentials()

  # Fetch pages -------------------------------------------------------------
  # Path to store pages on disk
  tmp_pagedir <- withr::local_tempdir(pattern = "detection_pages-")

  # Initialize progress bar for fetching the pages
  cli::cli_progress_bar(
    name = "Getting detections.",
    total = n_pages_expected,
    format =
      "{cli::pb_name}{cli::pb_bar} {cli::pb_percent} [{cli::pb_elapsed}] | {cli::pb_eta_str}"
  )

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


    ## store pages on disk -----------------------------------------------------


    # Decide what helper to use, add any extra required arguments. Regardless of
    # helper, return temppath where page was written.
    if (protocol == "opencpu") {
      arguments_for_helper <-
        list(
          function_identity = "get_acoustic_detections_page",
          payload = payload,
          # Set the format to feather because it's faster more memory efficient
          # and faster than rds
          format = "feather"
        )
      # Save the feather file to disk
      helper_to_use <- \(..., path) {
        forward_to_api(...,
          return_url = TRUE,
          compression = "lz4",
        ) |>
          httr2::request() |>
          req_perform_opencpu(path = path)
        invisible(path)
      }
    }

    if (protocol == "localdb") {
      arguments_for_helper <- payload
      # Save the DBI returned data.frame as a feather file
      helper_to_use <- \(..., path) {
        etnservice::get_acoustic_detections_page(...) |>
          arrow::write_feather(path, compression = "lz4")
        invisible(path)
      }
    }

    # Fetch page
    fetched_page_path <- do.call(
      helper_to_use,
      append(
        arguments_for_helper,
        list(
          path =
            tempfile(
              tmpdir = tmp_pagedir,
              fileext = ".feather"
            )
        )
      )
    )

    # Get some metadata on the page we fetched
    fetched_page <- arrow::read_feather(fetched_page_path,
                                        # Only read what we need.
                                        col_select = "detection_id",
                                        # Windows suffers memory allocation
                                        # issues with the arrow::open_dataset()
                                        # call later on. mmap = FALSE and
                                        # read_feather over open_dataset force
                                        # eager read into RAM.
                                        mmap = FALSE)

    # Break the loop if the page is smaller than the page size, or limit is set
    # to TRUE (always only fetch one page).
    if (nrow(fetched_page) < page_size || limit) {
      # Page isn't full = end of results.
      break
    }

    # The next page will be fetched with detection_ids higher than the current
    # max detection_id
    next_id_pk <-
      fetched_page |>
      # Arrow does not support slicing with ties
      dplyr::slice_max(.data$detection_id, n = 1, with_ties = FALSE) |>
      dplyr::pull("detection_id")

    # Iterate the progress bar by one page
    cli::cli_progress_update()
  }

  # combine pages -----------------------------------------------------------

  # Update the user on final time consuming step.
  if (progress) {
    cli::cli_progress_step("Wrapping up")
  }

  # Combine pages and sort on acoustic_tag_id
  detections <-
    arrow::open_dataset(tmp_pagedir, format = "feather") |>
    # perform a natural sort via Arrow C++ mapping
    dplyr::mutate(
      text_part = stringr::str_remove_all(.data$acoustic_tag_id, "[0-9]"),
      num_part = as.numeric(
        stringr::str_remove_all(.data$acoustic_tag_id, "[^0-9]")
      )
    ) |>
    # Arrange by the text part, then the numeric part, then deployment_id to
    # ensure the same result regardless of protocol
    dplyr::arrange(.data$text_part, .data$num_part, .data$deployment_id) |>
    dplyr::select(-dplyr::all_of(c("text_part", "num_part"))) |>
    # Set the column classes explicitly
    dplyr::mutate(
      qc_flag = as.logical(.data$qc_flag)
    )

  # Return single detections table
  dplyr::collect(detections)

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
#' @inheritDotParams get_acoustic_detections start_date end_date detection_id acoustic_tag_id animal_project_code scientific_name acoustic_project_code receiver_id station_name
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
count_acoustic_detections <- function(...) {
  # Decide how we're going to retrieve the count
  protocol <- select_protocol()
  # If protocol is opencpu, use forward_to_api()
  if (protocol == "opencpu") {
    returned_count <- forward_to_api("get_acoustic_detections_page",
      payload = append(
        rlang::list2(...),
        list(count = TRUE)
      ),
      json = TRUE
    )
  }
  # If protocol is localdb, use etnservice::get_acoustic_detections_page()
  if (protocol == "localdb") {
    returned_count <- do.call(etnservice::get_acoustic_detections_page,
      args = append(
        rlang::list2(...),
        list(count = TRUE)
      )
    )
  }

  # Extract the count from the returned data.frame
  dplyr::pull(returned_count, "count") |>
    # If the count class is not numeric, convert it. DBI returns Integer64 which
    # causes issues with cli progress bars
    as.numeric()
}
