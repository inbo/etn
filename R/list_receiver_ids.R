#' List all available receiver ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `receiver` present in `acoustic.receivers`.
#'
#' @export
list_receiver_ids <- function(api = TRUE,
                              connection){
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection(function_identity)
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api)
  return(out)
}


#' list_receiver_ids() sql helper
#'
#' @inheritParams list_receiver_ids()
#' @noRd
#'
list_receiver_ids_sql <- function(){
  # Create connection
  connection <- do.call(connect_to_etn, get_credentials())
  # Check connection
  check_connection(connection)

  query <- glue::glue_sql(
    "SELECT DISTINCT receiver FROM acoustic.receivers",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  stringr::str_sort(data$receiver, numeric = TRUE)
}
