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
get_detections <- function(connection = con, tag_id, ...) {
  .Deprecated("get_acoustic_detections")
  get_acoustic_detections(acoustic_tag_id = tag_id)
}

#' @rdname etn-deprecated
#' @export
get_transmitters <- function(connection = con, tag_id, ...) {
  .Deprecated("get_acoustic_tags")
  get_acoustic_tags(acoustic_tag_id = tag_id)
}

#' @rdname etn-deprecated
#' @export
list_tag_ids <- function(...) {
  .Deprecated("list_acoustic_tag_ids")
  list_acoustic_tag_ids(...)
}
