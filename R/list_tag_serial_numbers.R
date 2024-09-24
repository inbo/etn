#' List all available tag serial numbers
#'
#' @inheritParams list_animal_ids
#' @return A vector of all unique `tag_serial_numbers` present in
#'   `common.tag_device`.
#'
#' @export
list_tag_serial_numbers <- function(connection,
                                    api = TRUE) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api, json = TRUE)
  return(out)
}

#' list_tag_serial_numbers() sql helper
#'
#' @inheritParams list_tag_serial_numbers()
#' @noRd
#'
list_tag_serial_numbers_sql <- function() {
  # Create connection
  connection <- do.call(connect_to_etn, get_credentials())
  # Check connection
  check_connection(connection)

  query <- glue::glue_sql(
    "SELECT DISTINCT serial_number FROM common.tag_device",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return tag serial numbers
  stringr::str_sort(data$serial_number, numeric = TRUE)
}
