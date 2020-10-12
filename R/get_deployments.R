#' Get deployment metadata
#'
#' Get metadata for deployments, with options to filter results.
#'
#' @param connection A valid connection to the ETN database.
#' @param application_type (string) `acoustic_telemetry` or `cpod`.
#' @param network_project_code (string) One or more network projects.
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
#' @importFrom dplyr %>% arrange as_tibble filter
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
#' }
get_deployments <- function(connection = con,
                            application_type = NULL,
                            network_project_code = NULL,
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

  # Build query
  query <- glue_sql("
    SELECT
      *
    FROM
      vliz.deployments_view2 AS deployments
    WHERE
      {application_type_query}
      AND {network_project_code_query}
    ", .con = connection)
  deployments <- dbGetQuery(connection, query)

  # Filter on open deployments
  if (open_only) {
    deployments <- deployments %>% filter(is.na(.data$recover_date_time))
  }

  # Sort data
  deployments <-
    deployments %>%
    arrange(
      network_project_code,
      factor(station_name, levels = list_station_names(connection)),
      deploy_date_time
    )

  as_tibble(deployments)
}
