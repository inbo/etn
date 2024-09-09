
#' Get diagnostics information for a receiver
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param limit Logical. Limit the number of returned records to 100 (useful
#'   for testing purposes). Defaults to `FALSE`.
#'
#' @return A tibble with receiver diagnostics data
#' @export
get_receiver_diagnostics <- function(connection = con, limit = FALSE) {
  # Check connection
  check_connection(connection)

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
      "SELECT id_pk AS receiver_id,
    deployment_fk AS deployment_id,
    record_type,
    log_data,
    datetime FROM acoustic.receiver_logs_data
    {limit_query}",
      .con = connection,
      .null = "NULL"
    )

  diagnostics <- DBI::dbGetQuery(connection, query)

  # parse out log_data column into wider format
  diagnostics <-
    diagnostics %>%
    dplyr::mutate(log_data = purrr::map(log_data, jsonlite::fromJSON)) %>%
    tidyr::unnest_wider(log_data)

  # drop Device Time (UTC) column, is identical to datetime
  diagnostics <- dplyr::select(diagnostics, -`Device Time (UTC)`)

  # Return a tibble
  dplyr::as_tibble(diagnostics)
}

