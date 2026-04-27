#' List all available acoustic tag ids
#'
#' @inheritParams list_animal_ids
#' @return A vector of all unique `acoustic_tag_id` values that are available.
#' @family list functions
#' @export
#' @examplesIf etn:::credentials_are_set()
#' list_acoustic_tag_ids()
list_acoustic_tag_ids <- function(connection) {
  # Check arguments
  # The connection argument has been deprecated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  conduct_parent_to_helpers(protocol = select_protocol(), json = TRUE)
}
