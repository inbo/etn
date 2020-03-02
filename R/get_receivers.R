#' Get receiver metadata
#'
#' Get metadata for receivers, with option to filter on receiver id.
#'
#' @param connection A valid connection to the ETN database.
#' @param receiver_id (string) One or more receiver ids.
#' @param application_type (string) `acoustic_telemetry` or `cpod`.
#'
#' @return A tibble (tidyverse data.frame).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr pull %>% group_by mutate rename ungroup distinct
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # Get all receivers
#' get_receivers(con)
#'
#' # Get specific receivers
#' get_receivers(con, receiver_id = "VR2-4842c")
#' get_receivers(con, receiver_id = c("VR2AR-545719", "VR2AR-545720"))
#' }
get_receivers <- function(connection = con,
                          receiver_id = NULL,
                          application_type = NULL) {
  # Check connection
  check_connection(connection)

  # Check receiver_id
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
    valid_receiver_ids <- list_receiver_ids(connection)
    check_value(receiver_id, valid_receiver_ids, "receiver_id")
    receiver_id_query <- glue_sql("receiver_id IN ({receiver_id*})", .con = connection)
  }

  # Check application_type
  if (is.null(application_type)) {
    application_type_query <- "True"
  } else {
    check_value(application_type, c("acoustic_telemetry", "cpod"), "application_type")
    application_type_query <- glue_sql("application_type IN ({application_type*})", .con = connection)
  }

  # Build query
  query <- glue_sql("
    SELECT * FROM vliz.receivers_view2
    WHERE
      {receiver_id_query}
      AND {application_type_query}
    ", .con = connection)
  receivers <- dbGetQuery(connection, query)
  as_tibble(receivers)
}
