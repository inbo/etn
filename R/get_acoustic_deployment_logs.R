#' Get acoustic deployment logs
#'
#' Get log data for deployments of acoustic receivers.
#' These contain diagnostic information that may be helpful to figure what
#' happened with a receiver during deployment.
#' For example, a deviation in tilt angle may decrease detection capabilities.
#' For some receivers, other information such as water temperature is available.
#'
#' The log data are returned as a tibble with one row per log entry.
#' The columns of the tibble may vary depending on the deployment and receiver.
#' If no log entries are found for a deployment id, an empty tibble is returned.
#'
#' @inheritParams get_acoustic_deployments
#' @inheritParams get_acoustic_detections
#' @returns A tibble with acoustic deployment log data.
#' @family access functions
#' @export
#' @section Name repair:
#'
#' It is possible that the columns contained in the log data overlap with the
#' default columns always returned by `get_acoustic_deployment_logs()`.
#' If duplicate columns are found, their names are made unique with
#' [make.unique()] and a message is returned, which can be silenced with
#' [suppressMessages()].
#'
#' @examplesIf etn:::credentials_are_set()
#' get_acoustic_deployment_logs(deployment_id = 25259, limit = TRUE)
#' get_acoustic_deployment_logs(deployment_id = 74535)
get_acoustic_deployment_logs <- function(deployment_id, limit = FALSE) {
    # Return error on missing required arguments: deployment_id
  if (missing(deployment_id)) {
    cli::cli_abort(
      message = "Please provide at least one {.arg deployment_id}.",
      class = "etn_error_no_dep_id_supplied"
    )
  }

  # Either use the API, or the SQL helper.
  api_return <- conduct_parent_to_helpers(protocol = select_protocol())

  # Warn for deployment_ids for which we couldn't retrieve log data
  ids_with_data <- dplyr::pull(api_return, "deployment_id")
  if(!all(deployment_id %in% ids_with_data)){
    ids_no_logs <- setdiff(deployment_id, ids_with_data) |>
      # Convert to a character in order for cli pluralisation to work
      as.character()
    cli::cli_warn(
      c("x" = "Can't find any logs for {.arg deployment_id}
               {.val {ids_no_logs}}.",
        "i" = "Use {.fun get_acoustic_deployments} to get general information
               for these deployment(s)."),
      class = "etn_warning_no_deployment_logs_found"
    )
  }

  ## combine json strings into single array and parse
  log_data <-
    paste0("[", paste(api_return$log_data, collapse = ","), "]") |>
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
    dplyr::mutate(dplyr::across(dplyr::where(is.character),
                                ~ dplyr::na_if(.x, "")))

  # Tidy up column names
  diagnostics <-
    diagnostics |>
    ## Remove UPPERCASE except for the units in brackets
    dplyr::rename_with(
      ~ stringr::str_replace_all(.x, "[A-Z](?=[a-z])", tolower)
    ) |>
    ## Remove braces
    dplyr::rename_with(~ stringr::str_remove_all(.x, "[\\(\\)]")) |>
    ## Remove spaces
    dplyr::rename_with(\(old_name) {
      new_name <-
        stringr::str_replace_all(old_name, stringr::fixed(" "), "_")

      new_name_repaired <-
        make.unique(new_name)
      # Inform about name repair if any names were repaired, but only when
      # not testing
      if (!is_testing() && any(new_name != new_name_repaired)) {
        cli::cli_inform(
          "Not all field names were unique. Name repair took place:",
          class = "etn_message_name_repair"
        )
        rlang::names_inform_repair(old_name, new_name_repaired)
      }
      new_name_repaired
    })

  # Drop duplicate rows
  diagnostics <- dplyr::distinct(diagnostics)

  # Collapse log_data columns into single rows per deployment_id, receiver_id,
  # record_type, datetime combination

  diagnostics <-
    diagnostics |>
    ## Drop any columns that are all NA
    dplyr::select(dplyr::where(~ any(!is.na(.)))) |>
    ## If a column only contains NA values, keep it, if not, keep the first non
    ## NA value per group
    dplyr::summarise(
      dplyr::across(
        dplyr::everything(),
        # Use a base primitive to get the first non NA value per column, much
        # faster than dplyr::first()
        ~.x[!is.na(.x)][1L]
      ),
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
    dplyr::mutate(
      dplyr::across(
        dplyr::where(is.character),
        ~ type.convert(.x, as.is = TRUE)
      ),
      dplyr::across(
        dplyr::ends_with("_UTC"),
        lubridate::ymd_hms
      )
    )

  # Return a tibble
  dplyr::as_tibble(diagnostics) |>
    dplyr::arrange(
      # Logically order, oldest records first. Keep deployment_ids together.
      "deployment_id", "datetime"
    )
}
