# projects_view


#' Get project overview
#'
#' When no project_type ...
#'
#'
#' @param connection
#' @param project_type animal | network
#'
#' @return data.frame
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @examples
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