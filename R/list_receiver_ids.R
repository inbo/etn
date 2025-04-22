#' List all available receiver ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `receiver` present in `acoustic.receivers`.
#'
#' @export
list_receiver_ids <- function(connection = con) {
  query <- glue::glue_sql(
    "SELECT DISTINCT receiver FROM acoustic.receivers",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Return receiver_ids and drop NA (issue on database side inbo/etn#333)
  receiver_ids <- stringr::str_sort(data$receiver, numeric = TRUE)

  return(receiver_ids[!is.na(receiver_ids)])
}
