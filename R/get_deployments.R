
receiver_status_vocabulary <- c("Available", "Lost", "Broken",
                                "Active", "Returned to manufacturer")

#' Get deployments data
#'
#' ...
#'
#' @param connection
#' @param network_project
#' @param receiver_status
#'
#' @return data.frame
#'
#' @export
#'
#' @examples
#' \notrun{
#' # All deployments
#' get_deployments(con)
#'
#' # Deployments subset of projects
#' get_deployments(con, network_project = c("zeeschelde", "ws1"))
#'
#' # Deployments subset of projects and receiver status
#' get_deployments(con, network_project = c("zeeschelde", "ws1"),
#'                 receiver_status = "Active")
#' # Deployments subset of receiver status
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
