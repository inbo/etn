#' Get project overview
#'
#' Get an overview of the projects available on ETN database.
#'
#' @param connection A valid connection with the ETN database.
#' @param project_type (string) Either \code{animal} or \code{network}.
#'
#' @return A tibble (tidyverse data.frame).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr filter %>%
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # Get a list of all projects
#' get_projects(con)
#'
#' # Get a list of all animal projects
#' get_projects(con, project_type = "animal")
#'
#' # Get a list of all network projects
#' get_projects(con, project_type = "network")
#' }
get_projects <- function(connection, project_type = NULL) {

  animal_network <- project_type

  check_connection(connection)
  check_null_or_value(project_type, c("animal", "network"),
                      "project_type")

  projects <- glue_sql(
    "SELECT * FROM vliz.projects_view",
    .con = connection
  )
  projects <- dbGetQuery(connection, projects)

  if (!is.null(project_type)) {
    projects <- projects %>% filter(.data$type == animal_network)

  }
  as_tibble(projects)
}
