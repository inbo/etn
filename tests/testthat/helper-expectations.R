#' Do functions in ETN return the same value over the API as with a query to a
#' local database connection?
#'
#' This function tests if the provided expression returns identical regardless
#' of the returned value of the internal helper `select_protocol()`. In other
#' words, regardless of the way the data is received, data from a single source
#' should be returned in exactly the same way.
#'
#' To test this this expectation makes use of testthat's `expect_identical()`
#' and `with_mocked_bindings()` to temporarily override the return value of
#' `select_protocol()` to simulate both API and local database calls. This
#' expectation is useful to ensure that functions in ETN behave consistently
#' regardless of the data source. It is particularly important for functions
#' that can retrieve data from both an online API and a local database, as it
#' helps to verify that the data handling and processing logic is robust and
#' reliable across different data retrieval methods. This expectation will be
#' skipped if the machine is offline or if the ETN database is not available.
#'
#'
#' @param expression The expression to be tested.
#' @inherits testthat::expect_identical return
#'
#' @examples
#' expect_call_agnostic(list_acoustic_projects())
#' expect_call_agnostic(list_animal_projects())
#'
#'
#' @export
expect_protocol_agnostic <- function(expression) {
  # Skip if not both the API and the local database are available to compare
  testthat::skip_if_offline()
  testthat::skip_if(!"ETN" %in% odbc::odbcListDataSources()$name, "ETN is not a local database on this machine")

  # Test if the provided expression returns identical results with the API flag set to TRUE or FALSE
  testthat::expect_identical(
    testthat::with_mocked_bindings(
    code = rlang::eval_tidy(rlang::enquo(expression)),
    # Object, is a call to opencpu
    select_protocol = function(...) {"opencpu"}
    ),
    testthat::with_mocked_bindings(
      code = rlang::eval_tidy(rlang::enquo(expression)),
      # Expectation is a call to the local database
      select_protocol = function(...) {"localdb"}
    ),
    label = "api",
    expected.label = "local database"
  )
}
