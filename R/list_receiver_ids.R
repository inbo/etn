#' List all available receiver ids
#'
#' @inheritParams list_animal_ids
#' @return A vector of all unique `receiver` present in `acoustic.receivers`.
#'
#' @export
list_receiver_ids <- function(connection,
                              api = TRUE){
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api, json = TRUE)
  return(out)
}


#' list_receiver_ids() sql helper
#'
#' @inheritParams list_receiver_ids()
#' @noRd
#'
list_receiver_ids_sql <- function(){
  # Create connection
  connection <- create_connection(credentials = get_credentials())
  # Check connection
  check_connection(connection)

  query <- glue::glue_sql(
    "SELECT DISTINCT receiver FROM acoustic.receivers",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return receiver_ids and drop NA (issue on database side inbo/etn#333)
  receiver_ids <- stringr::str_sort(data$receiver, numeric = TRUE)

  return(receiver_ids[!is.na(receiver_ids)])
}
