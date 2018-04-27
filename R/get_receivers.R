
#' Get receiver data
#'
#' @param connection
#' @param network_project
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' get_receivers(connection)
#' get_receivers(connection, network_project = c("demer", "dijle"))
#' }
get_receivers <- function(connection,
                          network_project = NULL) {
  check_connection(connection)

  # valid inputs on animal projects
  valid_network_projects <-
    get_projects(connection, project_type = "network") %>%
    pull(projectcode)
  check_null_or_value(network_project,  valid_network_projects, "network_project")
  if (is.null(network_project)) {
    network_project = valid_network_projects
  }

  receivers_query <- glue_sql("
      SELECT receivers.* , deployments.projectcode
      FROM vliz.receivers
        JOIN vliz.deployments_view deployments ON (receivers.id_pk = deployments.receiver_fk)
      WHERE projectcode IN ({project*})",
                              project = network_project,
                              .con = connection
  )
  receivers <- dbGetQuery(connection, receivers_query)
  receivers
}
