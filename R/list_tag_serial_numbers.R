#' List all available tag serial numbers
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `tag_serial_numbers` present in
#'   `common.tag_device`.
#'
#' @export
list_tag_serial_numbers <- function(connection = con) {
  query <- glue::glue_sql(
    "SELECT DISTINCT serial_number FROM common.tag_device",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  stringr::str_sort(data$serial_number, numeric = TRUE)
}
