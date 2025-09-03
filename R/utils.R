# HELPER FUNCTIONS ----

#' Check input value against valid values
#'
#' @param x Value(s) to test.
#'   `NULL` values will automatically pass.
#' @param y Value(s) to test against.
#' @param name Name of the parameter.
#' @param lowercase If `TRUE`, the case of `x` and `y` values will ignored and
#'   `x` values will be returned lowercase.
#' @return Error or (lowercase) `x` values.
#' @family helper functions
#' @noRd
check_value <- function(x, y, name = "value", lowercase = FALSE) {
  # Remove NA from valid values
  y <- y[!is.na(y)]

  # Ignore case
  if (lowercase) {
    x <- tolower(x)
    y <- tolower(y)
  }

  # Check value(s) against valid values
  assertthat::assert_that(
    all(x %in% y), # Returns TRUE for x = NULL
    msg = glue::glue(
      "Can't find {name} `{x}` in: {y}",
      x = glue::glue_collapse(x, sep = "`, `", last = "` and/or `"),
      y = glue::glue_collapse(y, sep = ", ", width = 300)
    )
  )

  return(x)
}

#' Get the credentials from environment variables, or set them manually
#'
#' By default, it's not necessary to set any values in this function as it's
#' used in the background by other functions. However, if you wish to provide
#' your username and password on a per function basis, this function allows you
#' to do so.
#'
#' @param username ETN Data username, by default read from the environment, but
#'   you can set it manually too.
#' @param password ETN Data password, by default read from the environment, but
#'   you can set it manually too.
#' @return A string as it is ingested by other functions that need
#'   authentication
#' @family helper functions
#' @noRd
get_credentials <- function(username = Sys.getenv("ETN_USER"),
                            password = Sys.getenv("ETN_PWD")) {
  if (is.na(Sys.getenv("ETN_USER", unset = NA)) ||
    is.na(Sys.getenv("ETN_PWD", unset = NA))) {
    if (is_interactive()) {
      message("No credentials stored, prompting..")
      username <- prompt_user(prompt = "Please enter a userid: ")
      password <- ask_pass()
    } else {
      # No credentials, not interactive
      stop(
        glue::glue(
          "No credentials stored, not running in interactive mode. ",
          "Please set credentials as environemental variables or in the .Renviron file."
        )
      )
    }
  }
  invisible(list(username = username, password = password))
}

#' Lifecycle warning for the deprecated connection argument
#'
#' @param function_identity Character of length one with the name
#'   of the function the warning is being generated from
#'
#' @family helper functions
#' @noRd
deprecate_warn_connection <- function() {
  lifecycle::deprecate_warn(
    when = "v2.3.0",
    what = glue::glue("{function_identity}(connection)",
      function_identity = get_parent_fn_name(depth = 2)
    ),
    details = glue::glue(
      "The connection argument is no longer used. ",
      "You will be prompted for credentials instead."
    ),
    env = rlang::caller_env(),
    user_env = rlang::caller_env(2),
    always = TRUE
  )
}

#' Get the name (symbol) of the parent function
#'
#' @return A length one Character with the name of the parent function.
#'
#' @family helper functions
#' @noRd
#'
#' @examples
#' child_fn <- function() {
#'   get_parent_fn_name()
#' }
#'
#' parent_fn <- function() {
#'   print(get_parent_fn_name())
#'   print(paste("nested:", child_fn()))
#' }
#'
#' parent_fn()
get_parent_fn_name <- function(depth = 1) {
  rlang::call_name(rlang::frame_call(frame = rlang::caller_env(n = depth)))
}

# WRAPPER FUNCTIONS ----

#' Wrapper of askpass::askpass
#'
#' This function is wrapped so it can be mocked in
#' `testhat::with_mocked_bindings()` and thus allows for testing the prompting
#' behavior of `get_credentials()`
#'
#' @family wrappers
#' @noRd
ask_pass <- function(...) {
  askpass::askpass(...)
}

#' Wrapper of rlang::is_interactive
#'
#' This function is wrapped so it can be mocked in
#' `testhat::with_mocked_bindings()` and thus allows for testing the prompting
#' behaviour of `get_credentials()`
#'
#' @family wrappers
#' @noRd
is_interactive <- function(...) {
  rlang::is_interactive(...)
}

#' Wrapper for base::readline
#'
#' This function is wrapped because I find it easier to read, and so it can be
#' mocked in `testhat::with_mocked_bindings()` and thus allows for testing the prompting
#' behaviour of `get_credentials()`
#'
#' @family wrappers
#' @noRd
prompt_user <- function(...) {
  readline(...)
}

# onLoad ------------------------------------------------------------------

# Memoisation: Every 15 minutes, check the etnservice version compared to the
# version deployed via OpenCPU. Checking this on every call would slow down the
# package.
.onLoad <- function(libname, pkgname) {
  etnservice_version_matches <<- memoise::memoise(etnservice_version_matches,
                                      cache = cachem::cache_mem(max_age = 60 * 15)
  )
}
