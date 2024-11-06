#' Do functions in ETN return the same value over the API as with a query to a local database connection?
#'
#' This function tests if the provided expression returns identical results with the API flag set to TRUE or FALSE.
#' To this it makes use of testthat's `expect_identical()`, no other parameters are passed to `expect_identical()`.
#' 
#' This expectation will be skipped when offline, or when the ETN database is not available via odbc. 
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
expect_call_agnostic <- function(expression) {
  # Skip if not both the API and the local database are available to compare
  testthat::skip_if_offline()
  testthat::skip_if(!"ETN" %in% odbc::odbcListDataSources()$name, "ETN is not a local database on this machine")

  # Test if the provided expression returns identical results with the API flag set to TRUE or FALSE
  testthat::expect_identical(
    rlang::eval_tidy(rlang::call_modify(rlang::enquo(expression), api = TRUE)),
    rlang::eval_tidy(rlang::call_modify(rlang::enquo(expression), api = FALSE)),
    label = "api",
    expected.label = "local database"
  )
}
