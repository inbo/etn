#' List all available station names
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `station_name` present in
#'   `acoustic.deployments`.
#'
#' @export
list_station_names <- function(api = TRUE,
                               connection) {
  # check arguments
  assertthat::assert_that(assertthat::is.flag(api))
  # Lock in the name of the parent function
  function_identity <-
    get_parent_fn_name()

  # the connection argument has been depriciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection(function_identity)
  }

  arguments_to_pass <-
    return_parent_arguments()[
      !names(return_parent_arguments()) %in% c("api", "connection", "function_identity")]

  if(api){
    out <- do.call(
      forward_to_api,
      list(function_identity = function_identity, payload = arguments_to_pass)
    )
  } else {
    out <- do.call(glue::glue("{function_identity}_sql"), arguments_to_pass)
  }
  return(out)
}
#' list_station_names() sql helper
#'
#' @inheritParams list_station_names()
#' @noRd
#'
list_station_names_sql <- function(){
  # Create connection
  connection <- do.call(connect_to_etn, get_credentials())
  # Check connection
  check_connection(connection)

  query <- glue::glue_sql(
    "SELECT DISTINCT station_name FROM acoustic.deployments WHERE station_name IS NOT NULL",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  stringr::str_sort(data$station_name, numeric = TRUE)
}
