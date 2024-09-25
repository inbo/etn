# check_connection() ------------------------------------------------------
test_that("check_connection() returns error when connection is not valid", {
  not_a_connection <- "This is not a valid connection object"
  expect_error(check_connection(not_a_connection),
               regexp = "Not a connection object to database.",
               fixed = TRUE)
})

# deprecate_warn_connection() ---------------------------------------------
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

# create_connection() -----------------------------------------------------
test_that("create_connection() can create a connection with the database", {
  con <- create_connection(get_credentials())
  expect_true(check_connection(con))
  expect_true(isClass(con, "PostgreSQL"))
})

test_that("create_connection() returns error on non character arguments", {
  expect_error(create_connection(1, "password"),
               regexp = "username is not a string")
  expect_error(create_connection("username", 1),
               regexp = "password is not a string")
})
