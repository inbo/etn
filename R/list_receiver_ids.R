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

