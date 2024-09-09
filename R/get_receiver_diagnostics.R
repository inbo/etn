
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
    record_type, log_data, datetime FROM acoustic.receiver_logs_data
     {limit_query}",
      .con = connection,
      .null = "NULL"
    )

  diagnostics <- DBI::dbGetQuery(connection, query)
  DBI::dbDisconnect(connection)

  # parse out log_data column into wider format

  diagnostics <-
    diagnostics %>%
    mutate(log_data = purrr::map(log_data, jsonlite::fromJSON)) %>%
    tidyr::unnest_wider(log_data)

  # parse Device Time UTC to a datetime column



}

