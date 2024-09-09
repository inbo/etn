
get_receiver_diagnostics <- function(connection) {

  # Build query
  query <-
    glue::glue_sql(
      "SELECT id_pk AS receiver_id,
    deployment_fk AS deployment_id,
    record_type, log_data, datetime FROM acoustic.receiver_logs_data
     LIMIT 100",
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

