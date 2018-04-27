#' Get project overview
#'
#' Get an overview of the projects available on ETN database.
#'
#' @param connection A connection to the ETN database.
#' @param project_type (string) Either animal or network.
#'
#' @return A data.frame.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @examples
#' \dontrun{
#' get_projects()
#' get_projects(project_type = "animal")
#' }
get_projects <- function(connection, project_type = NULL) {

  check_connection(connection)
  check_null_or_value(project_type, c("animal", "network"),
                      "project_type")

  projects <- glue_sql(
    "SELECT * FROM vliz.projects_view",
    .con = connection
  )
  projects <- dbGetQuery(connection, projects)

  if (!is.null(project_type)) {
    projects <- projects %>% filter(type == project_type)
  }
  projects
}
