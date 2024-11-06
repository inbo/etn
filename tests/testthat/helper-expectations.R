expect_call_agnostic <- function(expression){
  # Skip if not both the API and the local database are available to compare
  testthat::skip_if_offline()
  skip_if(!"ETN" %in% odbc::odbcListDataSources()$name, "ETN is not a local database on this machine")

  # Test if the provided expression returns identical results with the API flag set to TRUE or FALSE
  testthat::expect_identical(
    rlang::eval_tidy(rlang::call_modify(rlang::enquo(expression), api = TRUE)),
    rlang::eval_tidy(rlang::call_modify(rlang::enquo(expression), api = FALSE)),
    label = "api",
    expected.label = "local database"
  )
}
