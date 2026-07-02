# HELPER FUNCTIONS ----

#' Check input value against valid values
#'
#' This function checks if the input value(s) `x` are present in the valid
#' values `y`. If any value in `x` is not found in `y`, an error is thrown. If
#' `lowercase` is set to `TRUE`, the case of the values will be ignored during
#' the comparison, and the returned values will be converted to lowercase.
#'
#' A suggestion will be offered when a value is not found, based on the
#' Levenshtein distance to the valid values.
#'
#' @param x Value(s) to test.
#'   `NULL` values will automatically pass.
#' @param y Value(s) to test against.
#' @param name Name of the parameter.
#' @param lowercase If `TRUE`, the case of `x` and `y` values will ignored and
#'   `x` values will be returned lowercase.
#' @param max_dist Maximum Levenshtein distance to consider a value a typo.
#'   This variable is used to offer suggestions when a typo is suspected.
#' @returns Error or (lowercase) `x` values.
#' @family helper functions
#' @noRd
check_value <- function(x, y, name = "value", lowercase = FALSE, max_dist = 3) {
  # Remove NA from valid values
  y <- y[!is.na(y)]

  # Ignore case
  if (lowercase) {
    x <- tolower(x)
    y <- tolower(y)
  }
  # Check value(s) against valid values
  if (all(x %in% y)) {
    return(x)
  }
  missing_values <- x[!x %in% y]
  # If the value is not found, check if it's a typo by calculating the
  # Levenshtein distance.
  distances <- utils::adist(missing_values, y) |>
    # Transpose the matrix so we can get the minimum distance per candidate
    t() |>
    as.data.frame() |>
    purrr::set_names(missing_values)
  # If any candidate string is less 3 transformations away from the reference,
  # we can assume it's a typo and suggest it to the user.
  candidates_col <- cli::cli_vec(y, list("vec-trunc" = 5))
  if (any(purrr::map_lgl(distances, \(dist_for_value) {
    any(dist_for_value <= max_dist)
  }))) {
    # We need to repeat the candidates so we can get the minimum distance
    # for each missing value
    closest_match <-
      rep(y, length(missing_values))[purrr::map_int(distances, which.min)]
    # If there are many candidates, truncate the list to 5 items for the error
    # message.
    cli::cli_abort(
      "Can't find {.var {name}}: {.val {missing_values}} in: {.or {.str {candidates_col}}}.
      Did you mean {.strong {.val {closest_match}}}?",
      class = "etn_value_not_found_suggest",
      call = rlang::caller_env()
    )
  } else {
    # Sort the references so the closest matches are mentioned. Only show 5
    # members.
    candidates_col <- purrr::map(distances, \(dist_for_value){
      y[order(as.vector(dist_for_value))]
    }) |>
      # Convert into a vector and truncate for the error message
      purrr::reduce(rbind) |>
      c() |>
      # Don't repeat yourself
      unique() |>
      cli::cli_vec(list("vec-trunc" = 5))
    cli::cli_abort(
      "Can't find {.var {name}}: {.val {missing_values}} in: {.or {.str {candidates_col}}}.",
      class = "etn_value_not_found",
      call = rlang::caller_env()
    )
  }
}

#' Get credentials from environment variables, or set them manually
#'
#' By default, it's not necessary to set any values in this function as it's
#' used in the background by other functions. However, if you wish to provide
#' your username and password on a per function basis, this function allows you
#' to do so.
#'
#' @param username Username to the ETN database. By default read from the
#'   environment, but you can set it manually too.
#' @param password Password to the ETN database. By default read from the
#'   environment, but you can set it manually too.
#' @returns A string as it is ingested by other functions that need
#'   authentication.
#' @family helper functions
#' @noRd
get_credentials <- function(username = Sys.getenv("ETN_USER"),
                            password = Sys.getenv("ETN_PWD")) {
  if (is.na(Sys.getenv("ETN_USER", unset = NA)) ||
    is.na(Sys.getenv("ETN_PWD", unset = NA))) {
    if (is_interactive()) {
      cli::cli_alert_info(
        "No credentials stored. See {.vignette etn::authentication} to configure
         credentials."
      )
      username <- prompt_user(prompt = "Please enter your username: ")
      password <- ask_pass()
    } else {
      # No credentials, not interactive
      cli::cli_abort(
        c(
          "No credentials stored. Can't prompt for credentials since this is not
           running in interactive mode.",
          "i" = "See {.vignette etn::authentication} to configure credentials."
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
    when = "3.0.0",
    what = glue::glue("{function_identity}(connection)",
      function_identity = get_parent_fn_name(depth = 2)
    ),
    details = cli::format_inline(
      "Database connections are handled automatically.
       See {.vignette etn::authentication} to configure credentials."
    ),
    env = rlang::caller_env(),
    user_env = rlang::caller_env(2),
    always = TRUE
  )
}

#' Get the name (symbol) of the parent function
#'
#' @returns A length one Character with the name of the parent function.
#' @family helper functions
#' @noRd
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

#' Determine testing status
#'
#' Copy of testthat::is_testing() implementation to avoid a runtime dependency
#' on testthat.
#'
#' @returns `TRUE` inside a test.
#' @family helper functions
#' @noRd
is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

#' Get the system's nodename
#'
#' A simple wrapper around `Sys.info()["nodename"]` to facilitate mocking in
#' tests.
#'
#' @returns Character of length one with the system's nodename.
#' @family helper functions
#' @noRd
#' @examples
#' get_nodename()
get_nodename <- function() {
  Sys.info()["nodename"]
}

#' Check if the local database protocol is available
#'
#' This function checks if the local database is available by checking the
#' nodename.
#'
#' The nodename check is a simple string check to see if the system's nodename
#' ends with "vliz.be", which is a convention for systems that have access to
#' the local database.#'
#'
#' @returns Logical. `TRUE` if the local database is available, `FALSE`
#'   otherwise.
#' @family helper functions
#' @noRd
#' @examples
#' # This should return FALSE unless you are running this example from the VLIZ
#' # RStudio server.
#' localdb_is_available()
localdb_is_available <- function() {
  # As discussed with VLIZ, all systems that have access to the local database
  # should have nodenames ending on vliz.be
  endsWith(get_nodename(), "vliz.be") |
    endsWith(get_nodename(), "europeantrackingnetwork.org")
}

#' Select the protocol to use
#'
#' The protocol is the way data is fetched. This is in addition to the source,
#' which is where the data comes from.
#'
#' This function is used to centrally control the decision tree for which
#' protocol to use for ´conduct_parent_to_helper()´. When there is a local
#' database connection available, use this by default. If not, use the OpenCPU
#' API. Both these protocols use the ETN database as a source.
#'
#' @returns Character of length one with one of the available protocols.
#' @family helper functions
#' @noRd
select_protocol <- function() {
  # ALlow overwriting of protocol logic by environmental variable
  user_selected_protocol <- Sys.getenv("ETN_PROTOCOL",
    unset = "no_protocol_set"
  )
  if (user_selected_protocol != "no_protocol_set") {
    return(user_selected_protocol)
  }

  # If there is a local database connection available, use it.
  if (localdb_is_available()) {
    return("localdb")
  }

  # Fallback on API
  return("opencpu")
}

#' Remove HTML tags from a string
#'
#' This function uses the xml2 package to parse the HTML and extract the text
#' content.
#'
#'
#' @param x Character string with HTML tags.
#' @returns Character string without HTML tags.
#' @family helper functions
#' @noRd
#' @examples
#' remove_html_tags("<p>This is an <strong>amazing example</strong>.</p>")
remove_html_tags <- function(x) {
  # Check if xml2 is installed
  rlang::check_installed("xml2", reason = "To parse HTML")


  purrr::map_chr(x, \(string) {
    if (is.na(string)) {
      return(NA_character_)
    }
    # Remove HTML non breaking spaces explicitly, this causes encoding issues
    # due to differences between ISO-8859-1 and UTF-8.
    stringr::str_remove(string, stringr::fixed("&nbsp;")) |>
      # Convert to raw so it's not interpreted as a path
      charToRaw() |>
      xml2::read_html() |>
      xml2::xml_text()
  })
}

#' Test if ETN credentials are stored
#'
#' This function checks if the ETN credentials are set in the environment
#' variables. It returns `TRUE` if both credentials are set, and `FALSE`
#' otherwise. This can be used in tests or examples to conditionally skip if the
#' credentials are not available.
#'
#' @returns A boolean indicating whether the ETN credentials are set in the
#'   environment variables.
#' @family helper functions
#' @noRd
credentials_are_set <- function() {
  nzchar(Sys.getenv("ETN_USER")) && nzchar(Sys.getenv("ETN_PWD"))
}

#' Get the citation for the etn package as plain text
#'
#' This function retrieves the citation information for the `etn` package and
#' formats it as plain text.
#'
#' @returns A character vector containing the citation information for the `etn`
#'   package in plain text format.
#'
#' @family helper functions
#' @noRd
etn_citation <- function() {
  authors <-
    "Huybrechts P, Desmet P, Govaert S, Oldoni D, Van Hoey S"
  title <-
    "etn: Access Data from the European Tracking Network"

  doi_url <- "https://doi.org/10.5281/zenodo.15235747"

  version_str <- paste("R package version", utils::packageVersion("etn"))

  docs_url <- "https://inbo.github.io/etn/"

  sprintf("%s. %s. %s, %s, %s.", authors, title, doi_url, version_str, docs_url)
}

# WRAPPER FUNCTIONS ----

#' Wrapper of askpass::askpass
#'
#' This function is wrapped so it can be mocked in
#' `testhat::with_mocked_bindings()` and thus allows for testing the prompting
#' behaviour of `get_credentials()`
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

# rlang null handling -----------------------------------------------------
#' @importFrom rlang %||%
NULL


# onLoad ------------------------------------------------------------------

.onLoad <- function(libname, pkgname) {
  # Memoisation: Every 15 minutes, check the deployed version of etnservice.
  # Checking this on every call would slow down the package.
  get_etnservice_version <<-
    memoise::memoise(get_etnservice_version,
      cache = cachem::cache_mem(max_age = 60 * 15)
    )
  # Memoisation: only validate the login credentials every 15 minutes.
  validate_login <<-
    memoise::memoise(validate_login,
      cache = cachem::cache_mem(max_age = 60 * 15)
    )
}

#' Expand columns
#'
#' Expands a data frame with columns. Added columns will have `NA_character_`
#' values, existing columns of the same name will not be overwritten.
#'
#' @param df A data frame.
#' @param colnames A character vector of column names.
#' @returns Data frame expanded with columns that were not yet present.
#' @family helper functions
#' @noRd
expand_cols <- function(df, colnames) {
  cols_to_add <- setdiff(colnames, colnames(df))
  df[, cols_to_add] <- NA_character_
  df
}
