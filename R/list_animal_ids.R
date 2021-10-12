#' List all available animal ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `id_pk` present in `common.animal_release`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
list_animal_ids <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT id_pk FROM common.animal_release",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  sort(data$id_pk)
}
