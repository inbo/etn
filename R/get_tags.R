#' Get tag data
#'
#' Get data for tags, with options to filter results. Note that there
#' can be multiple records (`acoustic_tag_id`) per tag device
#' (`tag_serial_number`).
#'
#' @param tag_serial_number Character (vector). One or more tag serial numbers.
#' @param tag_type Character (vector). `acoustic` or `archival`. Some tags are
#'   both, find those with `acoustic-archival`.
#' @param tag_subtype Character (vector). `animal`, `built-in`, `range` or
#'   `sentinel`.
#' @param acoustic_tag_id Character (vector). One or more acoustic tag
#'   identifiers, i.e. identifiers found in [get_acoustic_detections()].
#' @inheritParams list_animal_ids
#' @return A tibble with tags data, sorted by `tag_serial_number`.
#'  Values for `owner_organization` and `owner_pi` will only be visible if you
#'  are member of the group.
#' @family access functions
#' @export
#' @examplesIf etn:::credentials_are_set()
#' # Get all tags
#' get_tags()
#'
#' # Get archival tags, including acoustic-archival
#' get_tags(tag_type = c("archival", "acoustic-archival"))
#'
#' # Get tags of specific subtype
#' get_tags(tag_subtype = c("built-in", "range"))
#'
#' # Get specific tags (note that these can return multiple records)
#' get_tags(tag_serial_number = "1187450")
#' get_tags(acoustic_tag_id = "A69-1601-16130")
#' get_tags(acoustic_tag_id = c("A69-1601-16129", "A69-1601-16130"))
get_tags <- function(connection,
                     tag_type = NULL,
                     tag_subtype = NULL,
                     tag_serial_number = NULL,
                     acoustic_tag_id = NULL) {
  # Check arguments
  # The connection argument has been deprecated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(protocol = select_protocol()) |>
    # Set the column classes explicitly
    dplyr::mutate(floating = as.logical(.data$floating))

  return(out)
}
