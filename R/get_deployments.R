#' Get deployments data
#'
#' Get all or specific, filtered by network project and/or the status of the
#' receiver, deployments data.
#'
#' @param connection A valid connection with the ETN database.
#' @param network_project (string) One or more network projects.
#' @param receiver_status (string) One or more receiver status.
#' @param open_only (logical) Default TRUE, returning only those deployments
#' that are currently open (i.e. no end date defined. If FALSE, all deployments
#' are returned.
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
#' # All open deployments
#' get_deployments(con)
#'
#' # All deployments (also deployments with an end date)
#' get_deployments(con, open_only = FALSE)
#'
#' # Open deployments of a subset of projects
#' get_deployments(con, network_project = c("thornton", "leopold"))
#'
#' # Open deployments of a subset of receiver status
#' get_deployments(con, receiver_status = c("Broken", "Lost"))
#'
#' # Open deployments of a subset of projects and receiver status
#' get_deployments(con, network_project = "thornton",
#'                 receiver_status = "Active")
#' }
get_deployments <- function(connection,
                            network_project = NULL,
                            receiver_status = NULL,
                            open_only = TRUE) {

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

  deployments_query <- glue_sql(
    "SELECT * FROM vliz.deployments_view
    WHERE receiver_status IN ({status*})
    AND projectcode IN ({project*})",
    status = receiver_status,
    project = network_project,
    .con = connection
  )
  deployments <- dbGetQuery(connection, deployments_query)
  if (open_only) {
    deployments %>% filter(is.na(.data$recover_date_time))
  } else {
    deployments
  }

  as_tibble(deployments)

}

receiver_status_vocabulary <- c("Available", "Lost", "Broken",
                                "Active", "Returned to manufacturer")
