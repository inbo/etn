# HELPER FUNCTIONS

#' Check the validity of the database connection
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @noRd
check_connection <- function(connection) {
  assertthat::assert_that(methods::is(connection, "PostgreSQL"),
    msg = "Not a connection object to database."
  )
  assertthat::assert_that(connection@info$dbname == "ETN")
}

#' Check input value against list of provided values
#'
#' Will return error message if an input value cannot be found in list of provided
#' values. NULL values are allowed.
#'
#' @param arg Character. The input argument provided by the user.
#' @param options Character vector of valid inputs for the argument.
#' @param arg_name Character. The name of the argument used in the function to
#'   test.
#'
#' @return If no error, `TRUE`.
#'
#' @noRd
#'
#' @examples
#' \dontrun{
#' # Valid inputs for tag_type
#' check_value("acoustic", c("acoustic", "archival"), "tag_type")
#' check_value(NULL, c("acoustic", "archival"), "tag_type")
#' check_value(c("acoustic", "archival"), c("acoustic", "archival"), "tag_type")
#'
#' # Invalid inputs for tag_type
#' check_value("ddsf", c("acoustic", "archival"), "tag_type")
#' }
check_value <- function(arg, options = NULL, arg_name) {
  max_print <- 20

  # Drop NA
  options <- options[!is.na(options)]

  # Suppress long messages
  if (length(options) > max_print) {
    options_to_print <- c(options[1:max_print], "others..")
  } else {
    options_to_print <- options
  }
  # Provide user message
  if (!is.null(arg)) {
    assertthat::assert_that(
      all(arg %in% options),
      msg = glue::glue(
        "Invalid value(s) for {arg_name} argument.
        Valid inputs are: {options_to_print*}.",
        .transformer = collapse_transformer(
          sep = ", ",
          last = " and "
        )
      )
    )
  } else {
    TRUE
  }
}

#' Print list of options
#'
#' @param regex Character. A regular expression to parse.
#' @param ... Additional arguments passed to the collapse.
#'
#' @noRd
collapse_transformer <- function(regex = "[*]$", ...) {
  function(code, envir) {
    if (grepl(regex, code)) {
      code <- sub(regex, "", code)
    }
    res <- eval(parse(text = code), envir)
    glue::glue_collapse(res, ...)
  }
}

#' Check if the string input can be converted to a date
#'
#' Returns `FALSE`` or the cleaned character version of the date
#' (acknowledgments to micstr/isdate.R).
#'
#' @param date_time Character. A character representation of a date.
#' @param date_name Character. Informative description to user about type of
#'   date.
#'
#' @return `FALSE` | character
#'
#' @noRd
#'
#' @examples
#' \dontrun{
#' check_date_time("1985-11-21")
#' check_date_time("1985-11")
#' check_date_time("1985")
#' check_date_time("1985-04-31") # invalid date
#' check_date_time("01-03-1973") # invalid format
#' }
check_date_time <- function(date_time, date_name = "start_date") {
  parsed <- tryCatch(
    lubridate::parse_date_time(date_time, orders = c("ymd", "ym", "y")),
    warning = function(warning) {
      if (grepl("No formats found", warning$message)) {
        stop(glue::glue(
          "The given {date_name}, {date_time}, is not in a valid ",
          "date format. Use a yyyy-mm-dd format or shorter, ",
          "e.g. 2012-11-21, 2012-11 or 2012."
        ))
      } else {
        stop(glue::glue(
          "The given {date_name}, {date_time} can not be interpreted ",
          "as a valid date."
        ))
      }
    }
  )
  as.character(parsed)
}
