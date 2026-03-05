#' List all available animal ids
#'
#' @param connection `r lifecycle::badge("deprecated")` A connection to the ETN
#'   database. This argument is no longer used. You will be prompted for
#'   credentials instead.
#'
#' @return A vector of all unique `id_pk` present in `common.animal_release`.
#'
#' @export
#'
#' @examplesIf etn:::credentials_are_set()
#' list_animal_ids()
list_animal_ids <- function(connection) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  conduct_parent_to_helpers(protocol = select_protocol(), json = TRUE)
}
