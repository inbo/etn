#' List all available network project codes
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all unique `projectcode` of `type="network"` in
#'   `common.projects`.
list_network_project_codes <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT projectcode FROM common.projects WHERE type = 'network'",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  sort(data$projectcode)
}
