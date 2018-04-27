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
#' @export
#'
#' @examples
#' check_null_or_value("ddsf", c("animal", "network"), "project_type")
#' check_null_or_value("ddsf", c("animal", "network", "sea"), "project_type")
#' check_null_or_value("animal", c("animal", "network"), "project_type")
#' check_null_or_value(NULL, c("animal", "network"), "project_type")
#' check_null_or_value(c("animal", "network"), c("animal", "network"), "project_type")
check_null_or_value <- function(arg, options = NULL, arg_name) {
  if (!is.null(arg)) {
    assert_that(all(arg %in% options),
        msg = glue("Not valid input value(s) for {arg_name} input argument.
                    Valid inputs are: {options*}.",
                   .transformer = collapse_transformer(sep = ", ",
                                                       last = " and ")
                   )
        )
  } else {
    TRUE
  }
}

collapse_transformer <- function(regex = "[*]$", ...) {
  function(code, envir) {
    if (grepl(regex, code)) {
      code <- sub(regex, "", code)
    }
    res <- evaluate(code, envir)
    collapse(res, ...)
  }
}
