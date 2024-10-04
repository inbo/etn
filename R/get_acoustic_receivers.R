#' Get acoustic receiver data
#'
#' Get data for acoustic receivers, with options to filter results.
#'
#' @param receiver_id Character (vector). One or more receiver identifiers.
#' @param status Character. One or more statuses, e.g. `available` or `broken`.
#'
#' @inheritParams list_animal_ids
#' @return A tibble with acoustic receiver data, sorted by `receiver_id`. See
#'   also
#'   [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'   Values for `owner_organization` will only be visible if you are member of
#'   the group.
#'
#' @export
#'
#' @examples
#' # Get all acoustic receivers
#' get_acoustic_receivers()
#'
#' # Get lost and broken acoustic receivers
#' get_acoustic_receivers(status = c("lost", "broken"))
#'
#' # Get a specific acoustic receiver
#' get_acoustic_receivers(receiver_id = "VR2W-124070")
get_acoustic_receivers <- function(connection,
                                   receiver_id = NULL,
                                   status = NULL,
                                   api = TRUE){
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api)
  return(out)
}
