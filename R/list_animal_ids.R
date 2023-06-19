#' List all available animal ids
#'
#'
#' @return A vector of all unique `id_pk` present in `common.animal_release`.
#'
#' @export
list_animal_ids <- function(api = TRUE,
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

#' list_animal_ids() sql helper
#'
#' @inheritParams list_animal_ids()
#' @noRd
#'
list_animal_ids_sql <- function() {
  # Create connection
  connection <- do.call(connect_to_etn, get_credentials())
  # Check connection
  check_connection(connection)

  query <- glue::glue_sql(
    "SELECT DISTINCT id_pk FROM common.animal_release",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return animal ids
  sort(data$id_pk)
}
