#' List all available network project codes
#'
#' @param connection A valid connection to the ETN database.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all unique `project_code` of `type="network"` present in `projects`.
list_network_project_codes <- function(connection) {
  query <- glue_sql("SELECT DISTINCT projectcode FROM vliz.projects WHERE type = 'network'",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$projectcode
}
