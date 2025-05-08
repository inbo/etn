#' Get acoustic deployment data
#'
#' Get data for deployments of acoustic receivers, with options to filter
#' results.
#'
#' @param deployment_id Integer (vector). One or more deployment identifiers.
#' @param receiver_id Character (vector). One or more receiver identifiers.
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
#' @param station_name Character (vector). One or more deployment station
#'   names.
#' @param open_only Logical. Restrict deployments to those that are currently
#'   open (i.e. no end date defined). Defaults to `FALSE`.
#'
#' @inheritParams list_animal_ids
#' @return A tibble with acoustic deployment data, sorted by
#'   `acoustic_project_code`, `station_name` and `deploy_date_time`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @examples
#' # Get all acoustic deployments
#' get_acoustic_deployments()
#'
#' # Get specific acoustic deployment
#' get_acoustic_deployments(deployment_id = 1437)
#'
#' # Get acoustic deployments for a specific receiver
#' get_acoustic_deployments(receiver_id = "VR2W-124070")
#'
#' # Get open acoustic deployments for a specific receiver
#' get_acoustic_deployments(receiver_id = "VR2W-124070", open_only = TRUE)
#'
#' # Get acoustic deployments for a specific acoustic project
#' get_acoustic_deployments(acoustic_project_code = "demer")
#'
#' # Get acoustic deployments for two specific stations
#' get_acoustic_deployments(station_name = c("de-9", "de-10"))
get_acoustic_deployments <- function(connection,
                                     deployment_id = NULL,
                                     receiver_id = NULL,
                                     acoustic_project_code = NULL,
                                     station_name = NULL,
                                     open_only = FALSE,
                                     api = TRUE) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api)
  return(out)
}
