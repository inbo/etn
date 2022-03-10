#' List all available animal ids
#'
#' @param connection A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `id_pk` present in `common.animal_release`.
#'
#' @export
list_animal_ids <- function(con = list(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)) {

  stopifnot(is.list(con))
  stopifnot(any(names(con) == c("username", "password")))

  connection <- connect_to_etn(con$username, con$password)

  query <- glue::glue_sql(
    "SELECT DISTINCT id_pk FROM common.animal_release",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  sort(data$id_pk)
}



