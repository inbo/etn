#' Connect to the ETN database
#'
#' This function is `r lifecycle::badge("deprecated")` since etn version 2.3.0.
#' Its use is no longer supported or needed. All connections to the ETN database
#' are now made automatically when you use a function. If your credentials are not saved
#' in the system environement, you will be prompted to enter them.
#'
#' @param ... Any arguments passed to this function are ignored.
#'
#' @return This function is no longer in use, and returns NULL invisibly.
#'
#' @export
connect_to_etn <- function(...) {
  lifecycle::deprecate_warn(
    when = "3.0.0",
    what = "connect_to_etn()",
    details = cli::cli_fmt(
      cli::cli_text(
        "Database connections are handled automatically.
        See {.vignette etn::authentication} to configure authentication."
      )
    ),
    always = TRUE
  )
  invisible(NULL)
}
