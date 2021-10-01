# SUPPORT FUNCTIONS

#' Check the validity of the database connection
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @keywords internal
#'
#' @noRd
#'
#' @importFrom methods is
#'
#' @keywords internal
check_connection <- function(connection) {
  assert_that(is(connection, "PostgreSQL"),
    msg = "Not a connection object to database."
  )
  assert_that(connection@info$dbname == "ETN")
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
#' @keywords internal
#'
#' @noRd
#'
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' # Valid inputs for project_type
#' check_value("animal", c("animal", "network"), "project_type")
#' check_value(NULL, c("animal", "network"), "project_type")
#' check_value(c("animal", "network"), c("animal", "network"), "project_type")
#'
#' # Invalid inputs for project_type
#' check_value("ddsf", c("animal", "network"), "project_type")
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
    assert_that(
      all(arg %in% options),
      msg = glue(
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
#' @keywords internal
#'
#' @noRd
#'
#' @importFrom glue glue_collapse
#'
#' @keywords internal
collapse_transformer <- function(regex = "[*]$", ...) {
  function(code, envir) {
    if (grepl(regex, code)) {
      code <- sub(regex, "", code)
    }
    res <- eval(parse(text = code), envir)
    glue_collapse(res, ...)
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
#' @importFrom glue glue
#' @importFrom lubridate parse_date_time
#'
#' @keywords internal
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
    parse_date_time(date_time, orders = c("ymd", "ym", "y")),
    warning = function(warning) {
      if (grepl("No formats found", warning$message)) {
        stop(glue(
          "The given {date_name}, {date_time}, is not in a valid ",
          "date format. Use a yyyy-mm-dd format or shorter, ",
          "e.g. 2012-11-21, 2012-11 or 2012."
        ))
      } else {
        stop(glue(
          "The given {date_name}, {date_time} can not be interpreted ",
          "as a valid date."
        ))
      }
    }
  )
  as.character(parsed)
}

#' Get all distinct values from a specific column of a data.frame
#'
#' This function extracts all distinct values from a given column of a
#' data.frame. If a character column is provided, multiple values in the same
#' row are split as well.
#' @param .data A data frame, data frame extension (e.g. a tibble)
#' @param column unquoted column name or column position
#' @param split character vector containing regular expression(s) to use for
#'   splitting. `split` is internally passed to argument `split` of base R function
#'   `strsplit()`
#'
#' @return a vector of the same type as the given column
#'
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#'
#' @keywords internal
#'
#' @noRd
#'
#' @examples
#' df <- data.frame(
#'   chr_col = c("A", "B,C", "C,A","D"),
#'   num_col = c(1,2,2,3),
#'   dot_sep_col = c("A", "B.C", "C.A","D"))
#' # split by comma  (default)
#' list_values(df, chr_col) # same as
#' list_values(df, chr_col, split = ",")
#' # access column by column position
#' list_values(df, 1)
#' # split by dot (regex expression: "\\.")
#' list_values(df, dot_sep_col, split = "\\.")
#' # non character column
#' list_values(df, num_col)
list_values <- function(.data, column, split = ",") {
  # check .data
  assert_that(is.data.frame(.data))
  # check split
  assert_that(is.character(split))

  arguments <- as.list(match.call())

  if (is.numeric(arguments$column)){
    col_number <- arguments$column
    n_col_df <- ncol(.data)
    assert_that(as.integer(col_number) == col_number,
                msg = "column number must be an integer")
    assert_that(col_number <= ncol(.data),
                msg = glue("column number exceeds the number of columns ",
                           "of .data ({n_col_df})"))
    # extract values
    values <- .data[,col_number]
  } else {
    #check column name
    col_name <- as.character(arguments$column)
    assert_that(length(col_name) == 1,
                msg = "invalid column value")
    assert_that(col_name %in% names(.data),
                msg = glue("column {col_name} not found in .data"))

    # extract values
    if (class(arguments$column) == "name") {
      values <- eval(arguments$column, .data)
    } else {
      if (is.character(arguments$column)) {
        values <- .data[[arguments$column]]
      }
    }
  }

  if (is.character(values))
    # extract all values by splitting strings using split value
    values <- unlist(strsplit(x = values, split = split))
  return(unique(values))
}
