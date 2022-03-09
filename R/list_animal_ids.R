#' List all available animal ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `id_pk` present in `common.animal_release`.
#'
#' @export
list_animal_ids <- function(username = Sys.getenv("userid"),
                            password = Sys.getenv("pwd")) {

  connection <- connect_to_etn(username, password)

  query <- glue::glue_sql(
    "SELECT DISTINCT id_pk FROM common.animal_release",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  sort(data$id_pk)
}
