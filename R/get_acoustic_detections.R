#' Get acoustic detections data
#'
#' Get data for acoustic detections, with options to filter results. Use
#' `limit` to limit the number of returned records.
#'
#' @param start_date Character. Start date (inclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param end_date Character. End date (exclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param detection_id Character (vector). One or more detection ids.
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
#'
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
                                    detection_id = NULL,
                                    acoustic_tag_id = NULL,
                                    animal_project_code = NULL,
                                    scientific_name = NULL,
                                    acoustic_project_code = NULL,
                                    receiver_id = NULL,
                                    station_name = NULL,
                                    limit = FALSE,
                                    api = TRUE) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  assertthat::assert_that(assertthat::is.flag(api))
  assertthat::assert_that(assertthat::is.flag(limit))

  # Some arguments don't need to be send to etnservice
  arguments_to_pass <-
    return_parent_arguments(depth = 1)[
      !names(return_parent_arguments(depth = 1)) %in% c(
        "api",
        "connection",
        "limit" # handled client side
      )
    ]

  # Either use the API, or the SQL helper
  if (api) {
    n_records_returned <- forward_to_api("get_acoustic_detections_page",
      payload = append(
        arguments_to_pass,
        list(count = TRUE)
      ),
      json = TRUE
    ) %>%
      dplyr::pull("count")
  } else {
    n_records_returned <- do.call(etnservice::get_acoustic_detections_page,
      args = append(
        arguments_to_pass,
        list(count = TRUE)
      )
    ) %>%
      dplyr::pull("count")
  }

  # Initialise progress bar with total records expected
  cli::cli_progress_bar(total = n_records_returned)

  # Control number of objects to fetch per page, 100k default, up to 1M for
  # big queries
  page_size <- dplyr::case_when(
    limit ~ 100,
    n_records_returned > 5e6 ~ 1e6,
    .default = 100000
  )

  # Init object to store pages
  combined_results <- list()

  if (api) {
    # Keep repeating until the last page is smaller than the page_size
    repeat {
      fetched_page <-
        forward_to_api(
          function_identity = "get_acoustic_detections_page",
          payload = append(
            arguments_to_pass,
            # use the next_id_pk to paginate, if we are on the first page, start
            # at 0
            mget(
              # Get the following objects from the enclosing frame
              c("next_id_pk", "page_size"),
              # With the following default values if not set:
              ifnotfound = list(0, 100000),
              inherits = FALSE
            ),
            after = 0
          )
        )

      # Iterate the progress bar
      cli::cli_progress_update(inc = nrow(fetched_page))

      # The next page will be fetched with detection_ids higher than the current
      # max detection_id

      next_id_pk <- max(fetched_page$detection_id)

      # store page: use next_id_pk as name to avoid iterating page number
      combined_results[[as.character(next_id_pk)]] <- fetched_page

      if (nrow(fetched_page) < page_size || limit) {
        # Page isn't full = end of results.
        break
      }
    }
  } else { # Use a local database connection instead

    # Keep repeating until the last page is smaller than the page_size
    repeat {
      fetched_page <- do.call(
        etnservice::get_acoustic_detections_page,
        args = append(
          arguments_to_pass,
          # use the next_id_pk to paginate, if we are on the first page, start
          # at 0
          mget(
            # Get the following objects from the enclosing frame
            c("next_id_pk", "page_size"),
            # With the following default values if not set:
            ifnotfound = list(0, 100000),
            inherits = FALSE
          ),
          after = 0
        )
      )
      # Iterate the progress bar
      cli::cli_progress_update(inc = nrow(fetched_page))

      # The next page will be fetched with detection_ids higher than the current
      # max detection_id

      next_id_pk <- max(fetched_page$detection_id)

      # store page: use next_id_pk as name to avoid iterating page number
      combined_results[[as.character(next_id_pk)]] <- fetched_page

      if (nrow(fetched_page) < page_size || limit) {
        # Page isn't full = end of results.
        break
      }
    }
  }
  dplyr::bind_rows(combined_results)
}
