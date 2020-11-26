#' List all available network project codes
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all unique `project_code` of `project_type="network"`
#'   present in `projects_view2`.
list_network_project_codes <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT project_code AS project_code FROM vliz.projects_view2 WHERE project_type = 'network'",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  sort(data$project_code)
}
