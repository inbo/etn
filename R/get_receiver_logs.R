#' Get diagnostics information for a receiver for a deployment id.
#'
#'
#' @param deployment_id Integer (vector). One or more deployment identifiers.
#' @inheritParams get_acoustic_detections
#' @inheritParams get_acoustic_deployments
#'
#' @return A tibble with receiver diagnostics data
#' @export
get_receiver_logs <- function(
                                     deployment_id,
                                     start_date = NULL,
                                     end_date = NULL,
                                     receiver_id = NULL,
                                     limit = FALSE) {

  # Either use the API, or the SQL helper.
  log_data <- conduct_parent_to_helpers(protocol = select_protocol())
  ## combine json strings into single array and parse
  log_data <-
    paste0("[",paste(diagnostics$log_data, collapse = ","), "]") |>
    yyjsonr::read_json_str()

  # Add log data as seperate columns

  diagnostics <- dplyr::bind_cols(
    dplyr::select(diagnostics, -dplyr::all_of("log_data")),
    log_data
    )

  # Replace empty strings with NA
  diagnostics <-
    diagnostics %>%
    dplyr::mutate(dplyr::across(is.character, ~dplyr::na_if(.x, "")))

  # Tidy up column names
  diagnostics <-
    diagnostics %>%
      ## Remove UPPERCASE except for the units in brackets
      dplyr::rename_with(
        ~stringr::str_replace_all(.x, "[A-Z](?=[a-z])", tolower)
      ) %>%
      ## Remove braces
      dplyr::rename_with(~ stringr::str_remove_all(.x, "[\\(\\)]")) %>%
      ## Remove spaces
      dplyr::rename_with(
        ~ stringr::str_replace_all(
          .x,
          stringr::fixed(" "),
          "_"
        )
      )

  # Drop duplicate rows
  diagnostics <- dplyr::distinct(diagnostics)

  # Collapse log_data columns into single rows per deployment_id, receiver_id,
  # record_type, datetime combination

  # diagnostics <- arrow::as_arrow_table(diagnostics)

  diagnostics <-
    diagnostics %>%
    ## Drop any columns that are all NA
    dplyr::select(dplyr::where(~ !all(is.na(.)))) |>
    # dplyr::group_by(.data$deployment_id,
    #                 .data$receiver_id,
    #                 .data$record_type,
    #                 .data$datetime) %>%
    ## If a column only contains NA values, keep it, if not, keep the first non
    ## NA value per group
    dplyr::summarise(
      dplyr::across(
        dplyr::everything(),
        # ~ ifelse(all(is.na(.)),
        #   NA,
        #   dplyr::coalesce(.[!is.na(.)], .)
        # )
        ~dplyr::first(.x, na_rm = TRUE)
      ),
      # .groups = "drop",
      .by = dplyr::all_of(c(
        "deployment_id",
        "receiver_id",
        "record_type",
        "datetime"
      ))
    )

  # Convert column classes to classes based on base parsing
  diagnostics <-
    diagnostics %>%
    dplyr::mutate(dplyr::across(dplyr::where(is.character),
                                ~ type.convert(.x, as.is = TRUE)),
                  dplyr::across(dplyr::ends_with("_UTC"),
                                lubridate::ymd_hms)
                  )

  # Return a tibble
  dplyr::as_tibble(diagnostics)
}
