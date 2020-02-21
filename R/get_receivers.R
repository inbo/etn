#' Get receiver metadata
#'
#' Get metadata for receivers, with option to filter on network project.
#'
#' @param connection A valid connection to the ETN database.
#' @param network_project (string) One or more network projects.
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
#' # Get receivers linked to specific network project(s)
#' get_receivers(con, network_project = "thornton")
#' get_receivers(con, network_project = c("thornton", "2012_leopoldkanaal"))
#' }
get_receivers <- function(connection,
                          network_project = NULL) {
  # Check connection
  check_connection(connection)

  # Check network_project
  if (is.null(network_project)) {
    network_project_query <- "True"
  } else {
    valid_network_projects <- network_projects(connection)
    check_value(network_project, valid_network_projects, "network_project")
    network_project_query <- glue_sql("network_project_code IN ({network_project*})", .con = connection)
  }

  # Build query
  query <- glue_sql("
    SELECT *
    FROM vliz.receivers_view2
    WHERE
      {network_project_query}
    ", .con = connection
  )
  receivers <- dbGetQuery(connection, query)

  # We still have multiple records of receivers, as project codes are coupled to
  # deployments and a receiver can have multiple deployments aka projects.
  # combine the individual network projects in a single row:
  # receivers %>%
  #   group_by(.data$id_pk) %>%
  #   mutate(projectcode = paste(.data$projectcode, collapse = ",")) %>%
  #   rename(network_projectcode = .data$projectcode) %>%
  #   ungroup() %>%
  #   distinct()

  as_tibble(receivers)
}
