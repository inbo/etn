#' Get project metadata
#'
#' Get metadata for projects, with option to filter on animal or network
#' projects.
#'
#' @param connection A valid connection to the ETN database.
#' @param project_type (string) Either `animal` or `network`.
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
#' # Get all projects
#' get_projects(con)
#'
#' # Get all animal projects
#' get_projects(con, project_type = "animal")
#'
#' # Get all network projects
#' get_projects(con, project_type = "network")
#' }
get_projects <- function(connection = con,
                         project_type = NULL) {
  # Check connection
  check_connection(connection)

  # Check project type
  if (is.null(project_type)) {
    project_type_query <- "True"
  } else {
    check_value(project_type, c("animal", "network"), "project_type")
    project_type_query <- glue_sql("project_type IN ({project_type*})", .con = connection)
  }

  # Build query
  query <- glue_sql("
    SELECT *
    FROM vliz.projects_view2
    WHERE
      {project_type_query}
    ", .con = connection)
  projects <- dbGetQuery(connection, query)
  as_tibble(projects)
}
