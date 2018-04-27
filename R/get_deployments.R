#' Get deployments data
#'
#' This function retrieves all or specific deployments data.
#'
#' @param connection A valid connection with the ETN database.
#' @param network_project (string) One or more network projects.
#' @param receiver_status (string) One or more receiver status.
#'
#' @return A data.frame.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # All deployments
#' get_deployments(con)
#'
#' # Deployments of a subset of projects
#' get_deployments(con, network_project = c("zeeschelde", "ws1"))
#'
#' # Deployments of a subset of projects and receiver status
#' get_deployments(con, network_project = c("zeeschelde", "ws1"),
#'                 receiver_status = "Active")
#' # Deployments of a subset of receiver status
#' get_deployments(con, receiver_status = c("Broken", "Lost"))
#' }
get_deployments <- function(connection,
                            network_project = NULL,
                            receiver_status = NULL) {

  check_connection(connection)
  valid_networks <- get_projects(connection, project_type = "network") %>%
    pull(projectcode)
  check_null_or_value(network_project, valid_networks, "network_project")
  check_null_or_value(receiver_status, receiver_status_vocabulary,
                      "receiver_status")
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
  deployments
}

receiver_status_vocabulary <- c("Available", "Lost", "Broken",
                                "Active", "Returned to manufacturer")
