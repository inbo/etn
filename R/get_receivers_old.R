#' Get receiver data
#'
#' Get data for receivers, with options to filter results.
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param receiver_id Character (vector). One or more receiver ids.
#' @param application_type Character. `acoustic_telemetry` or `cpod`.
#' @param status Character. One or more statuses, e.g. `Available` or `Broken`.
#'
#' @return A tibble with receivers data, sorted by `receiver_id`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr %>% arrange as_tibble
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # Get all receivers
#' get_receivers_old(con)
#'
#' # Get specific receivers
#' get_receivers_old(con, receiver_id = "VR2-4842c")
#' get_receivers_old(con, receiver_id = c("VR2AR-545719", "VR2AR-545720"))
#'
#' # Get receivers for a specific application type
#' get_receivers_old(con, application_type = "cpod")
#'
#' # Get receivers with a specific status
#' get_receivers_old(con, status = c("Broken", "Lost"))
#' }
get_receivers_old <- function(connection = con,
                          receiver_id = NULL,
                          application_type = NULL,
                          status = NULL) {
  # Check connection
  check_connection(connection)

  # Check receiver_id
  valid_receiver_ids <- list_receiver_ids(connection)
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
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

  # Check status
  if (is.null(status)) {
    status_query <- "True"
  } else {
    valid_status <- c("Active", "Available", "Broken", "Lost", "Returned to manufacturer")
    check_value(status, valid_status, "status")
    status_query <- glue_sql("status IN ({status*})", .con = connection)
  }

  # Build query
  query <- glue_sql("
    SELECT
      *
    FROM
      acoustic.receivers_view2
    WHERE
      {receiver_id_query}
      AND {application_type_query}
      AND {status_query}
    ", .con = connection)
  receivers <- dbGetQuery(connection, query)

  # Sort data
  receivers <-
    receivers %>%
    arrange(factor(receiver_id, levels = valid_receiver_ids)) # valid_receiver_ids defined above

  as_tibble(receivers)
}
