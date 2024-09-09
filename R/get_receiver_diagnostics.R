
#' Get diagnostics information for a receiver
#'
#' @inheritParams get_acoustic_detections
#' @inheritParams get_acoustic_deployments
#'
#' @return A tibble with receiver diagnostics data
#' @export
get_receiver_diagnostics <- function(connection = con,
                                     deployment_id = NULL,
                                     start_date = NULL,
                                     end_date = NULL,
                                     receiver_id = NULL,
                                     limit = FALSE) {
  # Check connection
  check_connection(connection)

  # Check deployment_id
  if (is.null(deployment_id)) {
    deployment_id_query <- "True"
  } else {
    deployment_id <- check_value(
      deployment_id,
      list_deployment_ids(connection),
      "deployment_id"
    )
    deployment_id_query <- glue::glue_sql(
      "deployment_fk IN ({deployment_id*})",
      .con = connection
    )
  }

  # Check start_date
  if (is.null(start_date)) {
    start_date_query <- "True"
  } else {
    start_date <- check_date_time(start_date, "start_date")
    start_date_query <- glue::glue_sql("datetime >= {start_date}", .con = connection)
  }

  # Check end_date
  if (is.null(end_date)) {
    end_date_query <- "True"
  } else {
    end_date <- check_date_time(end_date, "end_date")
    end_date_query <- glue::glue_sql("datetime < {end_date}", .con = connection)
  }

  # Check receiver_id
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
    receiver_id <- check_value(
      receiver_id,
      list_receiver_ids(connection),
      name = "receiver_id"
    )
    receiver_id_query <- glue::glue_sql(
      "receiver.receiver IN ({receiver_id*})",
      .con = connection
    )
  }

  # Check limit
  assertthat::assert_that(is.logical(limit), msg = "limit must be a logical: TRUE/FALSE.")
  if (limit) {
    limit_query <- glue::glue_sql("LIMIT 100", .con = connection)
  } else {
    limit_query <- glue::glue_sql("LIMIT ALL}", .con = connection)
  }

  # Build query
  query <-
    glue::glue_sql(
    "SELECT
    receiver.receiver AS receiver_id,
    deployment_fk AS deployment_id,
    record_type,
    log_data,
    datetime
    FROM
      acoustic.receiver_logs_data
      LEFT JOIN acoustic.receivers AS receiver
      ON deployment_fk = receiver.id_pk
    WHERE
      {start_date_query}
      AND {end_date_query}
      AND {deployment_id_query}
      AND {receiver_id_query}
    {limit_query}",
    .con = connection,
    .null = "NULL"
    )

  ## Query database
  diagnostics <- DBI::dbGetQuery(connection, query)

  # Parse out log_data column into wider format
  diagnostics <-
    diagnostics %>%
    dplyr::mutate(log_data = purrr::map(log_data, jsonlite::fromJSON)) %>%
    tidyr::unnest_wider(log_data)

  # Drop Device Time (UTC) column, is identical to datetime
  diagnostics <- dplyr::select(diagnostics, -dplyr::any_of("Device Time (UTC)"))

  # Replace empty strings with NA
  diagnostics <-
    diagnostics %>%
    dplyr::mutate(dplyr::across(is.character, ~dplyr::na_if(.x, "")))

  # Tidy up column names
  diagnostics <-
    diagnostics %>%
      ## Remove UPPERCASE except for the units in brackets
      dplyr::rename_with(
        ~stringr::str_replace_all(.x, "[A-Z](?!\\))", tolower)
      ) %>%
      ## Remove braces
      dplyr::rename_with(~stringr::str_remove_all(.x, "[\\(\\)]")) %>%
      ## Remove spaces
      dplyr::rename_with(~stringr::str_replace_all(.x, stringr::fixed(" "), "_"))

  # Return a tibble
  dplyr::as_tibble(diagnostics)
}

