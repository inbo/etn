#' List all available receiver ids
#'
#' @inheritParams list_animal_ids
#' @return A vector of all unique `id_pk` present in `acoustic.deployments`.
#'
#' @export
list_deployment_ids <- function(connection, api = TRUE) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api, json = TRUE)
  return(out)
}

#' list_deployment_ids() sql helper
#'
#' @inheritParams list_deployment_ids()
#' @noRd
#'
list_deployment_ids_sql <- function() {
  # Create connection
  connection <- do.call(create_connection, get_credentials())
  # Check connection
  check_connection(connection)

  query <- glue::glue_sql(
    "SELECT DISTINCT id_pk FROM acoustic.deployments",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return deployment ids
  stringr::str_sort(data$id, numeric = TRUE)
}
