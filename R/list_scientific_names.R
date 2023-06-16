#' List all available scientific names
#'
#'
#' @return A vector of all unique `scientific_name` present in
#'   `common.animal_release`.
#'
#' @export
list_scientific_names <- function(api = TRUE,
                                  connection) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api)
  return(out)
}
#' list_scientific_names() sql helper
#'
#' @inheritParams list_scientific_names()
#' @noRd
#'
list_scientific_names_sql <- function(){
  # Create connection
  connection <- do.call(connect_to_etn, get_credentials())
  # Check connection
  check_connection(connection)

  query <- glue::glue_sql(
    "SELECT DISTINCT scientific_name FROM common.animal_release",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return scientific_names
  sort(data$scientific_name)
}
