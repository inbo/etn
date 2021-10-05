#' List all available tag serial numbers
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom stringr str_sort
#'
#' @return A vector of all unique `tag_serial_numbers` present in `common.tag_device`.
list_tag_serial_numbers <- function(connection = con) {
  query <- glue_sql(
    "SELECT DISTINCT serial_number FROM common.tag_device",
    .con = connection
  )
  data <- dbGetQuery(connection, query)

  str_sort(data$serial_number, numeric = TRUE)
}
