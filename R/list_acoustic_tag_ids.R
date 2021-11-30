#' List all available acoustic tag ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `acoustic_tag_id` in `acoustic_tag_id.sql`.
#'
#' @export
list_acoustic_tag_ids <- function(connection = con) {
  acoustic_tag_id_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "acoustic_tag_id.sql", package = "etn")),
    .con = connection
  )
  query <- glue::glue_sql("
    SELECT DISTINCT acoustic_tag_id
    FROM ({acoustic_tag_id_sql}) AS acoustic_tag_id
    WHERE acoustic_tag_id IS NOT NULL
  ", .con = connection)
  data <- DBI::dbGetQuery(connection, query)

  stringr::str_sort(data$acoustic_tag_id, numeric = TRUE)
}
