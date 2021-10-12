#' List all available cpod project codes
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `project_code` of `type = "cpod"` in
#'   `project.sql`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom readr read_file
list_cpod_project_codes <- function(connection = con) {
  project_query <- glue_sql(read_file(system.file("sql", "project.sql", package = "etn")), .con = connection)
  query <- glue_sql(
    "SELECT DISTINCT project_code FROM ({project_query}) AS project WHERE project_type = 'cpod'",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  sort(data$project_code)
}
