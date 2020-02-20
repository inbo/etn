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
  check_connection(connection)

  # Valid inputs on network projects
  valid_network_projects <-
    get_projects(connection, project_type = "network") %>%
    pull(.data$projectcode)
  check_null_or_value(
    network_project, valid_network_projects,
    "network_project"
  )
  if (is.null(network_project)) {
    network_project <- valid_network_projects
  }

  receivers_query <- glue_sql("
    SELECT *
    FROM vliz.receivers_view2
    WHERE network_project_code IN ({network_project*})
    ", .con = connection)
  receivers <- dbGetQuery(connection, receivers_query)

  # we still have multiple records of receivers, as project codes are coupled to
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
