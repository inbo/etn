#' Deprecated functions in etn
#'
#' The functions listed below are deprecated or renamed and will be defunct in
#' the near future.
#'
#' @name etn-deprecated
#' @keywords internal
NULL

#' @rdname etn-deprecated
#' @export
get_deployments <- function(connection = con, network_project_code = NULL, ...) {
  .Deprecated("get_acoustic_deployments")
  get_acoustic_deployments(connection, acoustic_project_code = network_project_code, ...)
}

#' @rdname etn-deprecated
#' @export
get_detections <- function(connection = con, tag_id = NULL, network_project_code = NULL, ...) {
  .Deprecated("get_acoustic_detections")
  get_acoustic_detections(connection, acoustic_tag_id = tag_id, acoustic_project_code = network_project_code, ...)
}

#' @rdname etn-deprecated
#' @export
get_projects <- function(connection = con, project_type, application_type) {
  .Deprecated("get_animal_projects, get_acoustic_projects or get_cpod_projects")
  if (!missing("project_type")) {
    if (project_type == "network") {
      get_acoustic_projects(connection)
    } else {
      get_animal_projects(connection)
    }
  } else if (!missing("application_type")) {
    if (application_type == "cpod") {
      get_cpod_projects(connection)
    }
  } else {
    get_animal_projects(connection)
  }
}

#' @rdname etn-deprecated
#' @export
get_receivers <- function(...) {
  .Deprecated("get_acoustic_receivers")
  get_acoustic_receivers(...)
}

#' @rdname etn-deprecated
#' @export
list_network_project_codes <- function(...) {
  .Deprecated("list_acoustic_project_codes")
  list_acoustic_project_codes(...)
}

#' @rdname etn-deprecated
#' @export
list_tag_ids <- function(...) {
  .Deprecated("list_acoustic_tag_ids")
  list_acoustic_tag_ids(...)
}
