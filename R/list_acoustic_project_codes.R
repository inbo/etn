#' List all available acoustic project codes
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `project_code` of `type = "acoustic"` in
#'   `project.sql`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom readr read_file
list_acoustic_project_codes <- function(connection = con) {
  project_sql <- glue_sql(read_file(system.file("sql", "project.sql", package = "etn")), .con = connection)
  query <- glue_sql(
    "SELECT DISTINCT project_code FROM ({project_sql}) AS project WHERE project_type = 'acoustic'",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  sort(data$project_code)
}
