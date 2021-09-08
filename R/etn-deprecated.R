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
get_transmitters <- function(...) {
  .Deprecated("get_tags")
  get_tags(...)
}

#' @rdname etn-deprecated
#' @export
list_tag_ids <- function(...) {
  .Deprecated("list_acoustic_tag_ids")
  list_acoustic_tag_ids(...)
}
