test_that("check_connection() returns error when connection is not valid", {
  not_a_connection <- "This is not a valid connection object"
  expect_error(check_connection(not_a_connection),
               regexp = "Not a connection object to database.",
               fixed = TRUE)
})

test_that("deprecate_warn_connection() returns warning when connection is provided", {
  # because this helper looks at the environment two levels up, it's not very
  # practical to test it directly. So here we test it by calling a function that
  # uses it.
  expect_warning(
    list_animal_project_codes(connection = "any object should cause a warning"),
    regexp = "The connection argument is no longer used. You will be prompted for credentials instead.",
    fixed = TRUE
  )
})
