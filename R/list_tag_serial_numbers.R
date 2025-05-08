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
