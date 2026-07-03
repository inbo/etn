#' Connect to the ETN database
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `connect_to_etn()` is deprecated. It is no longer supported or needed. All
#' connections to the ETN database are now handled automatically when you use a
#' function. If your credentials are not stored in the system environment, you
#' will be prompted to enter them.
#'
#' @param ... Any arguments passed to this function are ignored.
#' @returns This function is no longer in use, and returns `NULL` invisibly.
#' @family connect functions
#' @keywords internal
#' @export
#' @examples
#' \dontrun{
#' # Before
#' my_connection <- connect_to_etn()
#' get_animals(connection = my_connection)
#'
#' # Now
#' get_animals()
#' }
connect_to_etn <- function(...) {
  lifecycle::deprecate_warn(
    when = "3.0.0",
    what = "connect_to_etn()",
    details = cli::format_inline(
      "Database connections are handled automatically.
       See {.vignette etn::authentication} to configure credentials."
    ),
    always = TRUE
  )
  invisible(NULL)
}
