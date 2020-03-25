#' List all available scientific names
#'
#' @param connection A valid connection to the ETN database.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all unique `scientific_name` present in `animals_view2`.
list_scientific_names <- function(connection = con) {
  query <- glue_sql("SELECT DISTINCT scientific_name FROM vliz.animals_view2",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$scientific_name
}
