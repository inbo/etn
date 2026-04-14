#' List all available scientific names
#'
#' @inheritParams list_animal_ids
#' 
#' @return A vector of all unique `scientific_name` present in the animals table.
#'
#' @export
#'
#' @examplesIf etn:::credentials_are_set()
#' list_scientific_names()
list_scientific_names <- function(connection) {
  # Check arguments
  # The connection argument has been deprecated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  conduct_parent_to_helpers(protocol = select_protocol(), json = TRUE)
}
