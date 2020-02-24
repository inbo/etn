#' Get receiver metadata
#'
#' Get metadata for receivers.
#'
#' @param connection A valid connection to the ETN database.
#'
#' @return A tibble (tidyverse data.frame).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr pull %>% group_by mutate rename ungroup distinct
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # Get all receivers
#' get_receivers(con)
#' }
get_receivers <- function(connection) {
  # Check connection
  check_connection(connection)

  # Build query
  query <- glue_sql("
    SELECT * FROM vliz.receivers_view2
    ", .con = connection)
  receivers <- dbGetQuery(connection, query)
  as_tibble(receivers)
}
