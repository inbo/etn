#' Get deployment metadata
#'
#' Get metadata for deployments, with options to filter on network project,
#' receiver status and/or open deployments.
#'
#' @param connection A valid connection to the ETN database.
#' @param application_type (string) `acoustic_telemetry` or `cpod`.
#' @param network_project_code (string) One or more network projects.
#' @param receiver_status (string) One or more receiver status.
#' @param open_only (logical) Restrict to deployments that are currently open
#'   (i.e. no end date defined). Default: `TRUE`.
#'
#' @return A tibble (tidyverse data.frame) with metadata for deployments,
#'   sorted by `network_project_code`, `station_name` and `deploy_date_time`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr pull %>% filter as_tibble
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # Get all open deployments
#' get_deployments(con)
#'
#' # Get all deployments (including those with an end date)
#' get_deployments(con, open_only = FALSE)
#'
#' # Get open deployments for a specific application type
#' get_deployments(con, application_type = "cpod")
#'
#' # Get open deployments from specific network project(s)
#' get_deployments(con, network_project_code = c("ws1", "ws2"))
#'
#' # Get open deployments with a specific receiver status
#' get_deployments(con, receiver_status = c("Broken", "Lost"))
#'
#' # Get open deployments from a specific project from active receivers
#' get_deployments(con, network_project_code = "ws1", receiver_status = "Active")
#' }
get_deployments <- function(connection = con,
                            application_type = NULL,
                            network_project_code = NULL,
                            receiver_status = NULL,
                            open_only = TRUE) {
  # Check connection
  check_connection(connection)

  # Check application_type
  if (is.null(application_type)) {
    application_type_query <- "True"
  } else {
    check_value(application_type, c("acoustic_telemetry", "cpod"), "application_type")
    application_type_query <- glue_sql("deployments.application_type IN ({application_type*})", .con = connection)
  }

  # Check network_project_code
  if (is.null(network_project_code)) {
    network_project_code_query <- "True"
  } else {
    valid_network_project_codes <- list_network_project_codes(connection)
    check_value(network_project_code, valid_network_project_codes, "network_project_code")
    network_project_code_query <- glue_sql("deployments.network_project_code IN ({network_project_code*})", .con = connection)
  }

  # Check receiver_status
  if (is.null(receiver_status)) {
    receiver_status_query <- "True"
  } else {
    valid_receiver_status <- c("Available", "Lost", "Broken", "Active", "Returned to manufacturer")
    check_value(receiver_status, valid_receiver_status, "receiver_status")
    receiver_status_query <- glue_sql("receivers.status IN ({receiver_status*})", .con = connection)
  }

  # Build query
  query <- glue_sql("
    SELECT
      deployments.*,
      receivers.status AS receiver_status
    FROM
      vliz.deployments_view2 AS deployments
      LEFT JOIN vliz.receivers_view2 AS receivers
      ON deployments.receiver_id = receivers.receiver_id
    WHERE
      {application_type_query}
      AND {network_project_code_query}
      AND {receiver_status_query}
    ", .con = connection)
  deployments <- dbGetQuery(connection, query)

  # Filter on open deployments
  if (open_only) {
    deployments <- deployments %>% filter(is.na(.data$recover_date_time))
  }

  # Sort data
  deployments <- deployments %>%
    arrange(network_project_code, station_name, deploy_date_time)

  as_tibble(deployments)
}
