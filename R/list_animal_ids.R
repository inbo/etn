#' List all available animal ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all unique `animal_id` present in `animals_view2`.
list_animal_ids <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT animal_id FROM acoustic.animals_view2",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  sort(data$animal_id)
}
