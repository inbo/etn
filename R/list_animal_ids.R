#' List all available animal ids
#'
#' @param api Logical. If `TRUE`, the function will use the API to access ETN.
#' @param connection `r lifecycle::badge("deprecated")` A connection to the ETN
#'   database. This argument is no longer used. You will be prompted for
#'   credentials instead.
#'
#' @return A vector of all unique `id_pk` present in `common.animal_release`.
#'
#' @export
list_animal_ids <- function(connection,
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

