test_that("check_connection() returns error when connection is not valid", {
  not_a_connection <- "This is not a valid connection object"
  expect_error(check_connection(not_a_connection),
               regexp = "Not a connection object to database.",
               fixed = TRUE)
})
