#' List all available receiver ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `id_pk` present in `acoustic.deployments`.
#'
#' @export
list_deployment_ids <- function(connection = con) {
  query <- glue::glue_sql(
    "SELECT DISTINCT id_pk FROM acoustic.deployments",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  stringr::str_sort(data$id, numeric = TRUE)
}
