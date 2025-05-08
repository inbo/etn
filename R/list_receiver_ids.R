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
  ## Return receiver_ids and drop NA (issue on database side inbo/etn#333)
  receiver_ids <- conduct_parent_to_helpers(api, json = TRUE)

  return(receiver_ids[!is.na(receiver_ids)])
}
