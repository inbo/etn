
MAX_PRINT <- 20

#' Support function to check the validity of the database connection
#'
#' @param connection A valid connection with the ETN database.
#'
#' @importFrom methods is
#'
check_connection  <- function(connection) {
  assert_that(is(connection, "PostgreSQL"),
              msg = "Not a connection object to database.")
  assert_that(connection@info$dbname == "ETN")
}

#' Valid input is either NULL or option of list
#'
#' @param arg The input argument provided by the user.
#' @param options A vector of valid inputs for the argument.
#' @param arg_name The name of the argument used in the function to test.
#'
#' @return If no error, TRUE.
#'
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' # Invalid inputs for project_type
#' check_null_or_value("ddsf", c("animal", "network"), "project_type")
#' check_null_or_value("ddsf", c("animal", "network", "sea"), "project_type")
#'
#' #Valid inputs for project_type
#' check_null_or_value("animal", c("animal", "network"), "project_type")
#' check_null_or_value(NULL, c("animal", "network"), "project_type")
#' check_null_or_value(c("animal", "network"), c("animal", "network"), "project_type")
#'
#'
#' # check network projects
#' valid_network_projects <- get_projects(connection = con,
#'                                        project_type = "network") %>%
#'                                        pull("projectcode")
#' check_null_or_value(c("thornton", "leopold"),
#'                     valid_network_projects, "network_project")
#' # check animal projects
#' valid_animal_projects <- get_projects(connection = con,
#'                                       project_type = "animal") %>%
#'                                       pull("projectcode")
#' check_null_or_value(c("2012_leopoldkanaal", "phd_reubens"),
#'                     valid_animal_projects, "animal_project")
#' }
check_null_or_value <- function(arg, options = NULL, arg_name) {
  # dropna
  options <- options[!is.na(options)]

  # suppress too long messages
  if (length(options) > MAX_PRINT) {
    options_to_print <- c(options[1:MAX_PRINT], "others..")
  } else {
    options_to_print <- options
  }
  # provide user message
  if (!is.null(arg)) {
    assert_that(all(arg %in% options),
        msg = glue("Not valid input value(s) for {arg_name} input argument.
                    Valid inputs are: {options_to_print*}.",
                   .transformer = collapse_transformer(sep = ", ",
                                                       last = " and ")
                   )
        )
  } else {
    TRUE
  }
}


#' Support function for printing option help message
#'
#' @param regex A regular expression to parse
#' @param ... Additional arguments passed to the collapse
#'
#' @importFrom glue glue_collapse
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
#' Returns FALSE or the cleaned character version of the date.
#' (acknowledgments to micstr/isdate.R)
#'
#' @param datetime A character representation of a date.
#' @param date_name Informative description to user about type of date
#'
#' @return FALSE | character
#'
#'
#' @importFrom glue glue
#' @importFrom lubridate parse_date_time
#'
#' @examples
#' \dontrun{
#' check_datetime("1985-11-21")
#' check_datetime("1985-11")
#' check_datetime("1985")
#' check_datetime("1985-04-31")  # invalid date
#' check_datetime("01-03-1973")  # invalid format
#' }
check_datetime <- function(datetime, date_name = "start_date") {
  parsed <- tryCatch(
    parse_date_time(datetime, orders = c("ymd", "ym", "y")),
    warning = function(warning) {
      if (grepl("No formats found", warning$message)) {
        stop(glue("The given {date_name}, {datetime}, is not in a valid ",
                  "date format. Use a ymd format or shorter, ",
                  "e.g. 2012-11-21, 2012-11 or 2012."))
      } else {
        stop(glue("The given {date_name}, {datetime} can not be interpreted ",
                  "as a valid date."))
      } })
  as.character(parsed)
}

