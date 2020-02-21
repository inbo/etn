#' List all available animal project codes
#'
#' @param connection A valid connection to the ETN database.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all unique `project_code` of `type="animal"` present in `projects`.
list_animal_project_codes <- function(connection) {
  query <- glue_sql("SELECT DISTINCT projectcode FROM vliz.projects WHERE type = 'animal'",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$projectcode
}
