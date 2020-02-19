#' Get deployment metadata
#'
#' Get metadata for deployments, with options to filter on network project,
#' receiver status and/or open deployments.
#'
#' @param connection A valid connection to the ETN database.
#' @param network_project (string) One or more network projects.
#' @param open_only (logical) Restrict to deployments that are currently open (i.e. no end date defined).  Default:
#'   `TRUE`.
#'
#' @return A tibble (tidyverse data.frame).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr pull %>% filter
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
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
#' # Get open deployments from specific network project(s)
#' get_deployments(con, network_project = c("thornton", "leopold"))
#'
#' # Get open deployments with a specific receiver status
#' get_deployments(con, receiver_status = c("Broken", "Lost"))
#'
#' # Get open deployments from a specific project from active receivers
#' get_deployments(con, network_project = "thornton", receiver_status = "Active")
#' }
get_deployments <- function(connection,
                            network_project = NULL,
                            receiver_status = NULL,
                            open_only = TRUE) {
  receiver_status_vocabulary <- c("Available", "Lost", "Broken",
                                  "Active", "Returned to manufacturer")
  check_connection(connection)
  valid_networks <- get_projects(connection, project_type = "network") %>%
    pull(.data$projectcode)
  check_null_or_value(network_project, valid_networks, "network_project")
  check_null_or_value(receiver_status, receiver_status_vocabulary,
                      .data$receiver_status)
  if (is.null(network_project)) {
    network_project = valid_networks
  }
  if (is.null(receiver_status)) {
    receiver_status = receiver_status_vocabulary
  }

  deployments_query <- glue_sql("
    SELECT deployments.*,
      receivers.status AS receiver_status
    FROM vliz.deployments_view2 AS deployments
      LEFT JOIN vliz.receivers_view2 AS receivers
      ON deployments.receiver_id = receivers.receiver_id
    WHERE receivers.status IN ({receiver_status*})
      AND deployments.network_project_code IN ({network_project*})
    ", .con = connection
  )
  deployments <- dbGetQuery(connection, deployments_query)
  if (open_only) {
    deployments <- deployments %>% filter(is.na(.data$recover_date_time))
  }

  as_tibble(deployments)
}
