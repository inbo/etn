#' Get diagnostics information for a receiver for a deployment id.
#'
#' This function retrieves diagnostics information for a receiver for a
#' deployment id. This may be useful to figure out what happened to a receiver
#' during deployment. For example, a deviation in tilt angle may decrease
#' detection capabilities. For some receivers, information about the water
#' temperature can be available.
#'
#' The diagnostics information is returned as a tibble with one
#' row per log entry. The columns of the tibble may vary depending on the
#' deployment and receiver. If no log entries are found for the specified
#' arguments, an 0-row tibble is returned.
#'
#' @param deployment_id Integer (vector). One or more deployment identifiers.
#' @inheritParams get_acoustic_detections
#' @inheritParams get_acoustic_deployments
#'
#' @section Name repair:
#'
#' It is possible that the columns contained in a receiver log overlap with
#' the default columns always returned by `get_receiver_logs()`. If
#' duplicate columns are found, their names are made unique with
#' [base::make.unique()]. When this happens, a message is printed to the
#' console. The message can be muffled with [base::suppressMessages()] or
#' silenced with the global option `rlib_name_repair_verbosity`. See
#' [rlang::names_inform_repair()] for more information.
#' @name get_receiver_logs
#'
NULL
#' @return A tibble with receiver diagnostics data
#' @export
#' @examplesIf etn:::credentials_are_set()
#' get_receiver_logs(deployment_id = 25259, limit = TRUE)
#' get_receiver_logs(deployment_id = 74535,
#'                   station_name = "Tijdenskan. - Hamdijk 12 Bad Nieuwesch")
#' get_receiver_logs(deployment_id = 6028,
#'                   start_date = "2020",
#'                   end_date = "2020-02-01")
get_receiver_logs <- function(
                                     deployment_id,
                                     receiver_id = NULL,
                                     station_name = NULL,
                                     start_date = NULL,
                                     end_date = NULL,
                                     limit = FALSE) {

  # Return error on missing required arguments: deployment_id
  if (missing(deployment_id)) {
    cli::cli_abort(
      message = "Please provide at least one {.arg deployment_id}.",
      class = "etn_no_dep_id_supplied"
    )
  }

  # Either use the API, or the SQL helper.
  api_return <- conduct_parent_to_helpers(protocol = select_protocol())
  ## combine json strings into single array and parse
  log_data <-
    paste0("[",paste(api_return$log_data, collapse = ","), "]") |>
    jsonlite::fromJSON()

  # Add log data as seperate columns

  diagnostics <- dplyr::bind_cols(
    dplyr::select(api_return, -dplyr::all_of("log_data")),
    log_data
    )

  # Early return when no log_data has been found
  if (nrow(diagnostics) == 0) {
    return(diagnostics)
  }

  # Replace empty strings with NA
  diagnostics <-
    diagnostics |>
    dplyr::mutate(dplyr::across(is.character, ~dplyr::na_if(.x, "")))

  # Tidy up column names
  diagnostics <-
    diagnostics |>
      ## Remove UPPERCASE except for the units in brackets
      dplyr::rename_with(
        ~stringr::str_replace_all(.x, "[A-Z](?=[a-z])", tolower)
      ) |>
      ## Remove braces
      dplyr::rename_with(~ stringr::str_remove_all(.x, "[\\(\\)]")) |>
      ## Remove spaces
      dplyr::rename_with(
        \(old_name) {
          new_name <-
          stringr::str_replace_all(
          old_name,
          stringr::fixed(" "),
          "_"
          )

          new_name_repaired <-
            make.unique(new_name)
          # Inform about name repair if any names were repaired, but only when
          # not testing
          if(!is_testing()) {
            cli::cli_inform("Not all field names were unique."
                            ,"Name repair took place:")
            rlang::names_inform_repair(new_name, new_name_repaired)
          }
          new_name_repaired}
      )

  # Drop duplicate rows
  diagnostics <- dplyr::distinct(diagnostics)

  # Collapse log_data columns into single rows per deployment_id, receiver_id,
  # record_type, datetime combination

  diagnostics <-
    diagnostics |>
    ## Drop any columns that are all NA
    dplyr::select(dplyr::where(~ any(!is.na(.)))) |>
    # dplyr::group_by(.data$deployment_id,
    #                 .data$receiver_id,
    #                 .data$record_type,
    #                 .data$datetime) |>
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
    diagnostics |>
    dplyr::mutate(dplyr::across(dplyr::where(is.character),
                                ~ type.convert(.x, as.is = TRUE)),
                  dplyr::across(dplyr::ends_with("_UTC"),
                                lubridate::ymd_hms)
                  )

  # Return a tibble
  dplyr::as_tibble(diagnostics)
}
