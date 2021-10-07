#' List all available scientific names
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all unique `scientific_name` present in `animals_view2`.
list_scientific_names <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT scientific_name FROM acoustic.animals_view2 ORDER BY scientific_name",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  sort(data$scientific_name)
}
