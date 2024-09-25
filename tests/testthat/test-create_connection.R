test_that("create_connection() can create a connection with the database", {
  con <- connect_to_etn(get_credentials())
  expect_true(check_connection(con))
  expect_true(isClass(con, "PostgreSQL"))
})

test_that("create_connection() returns error on non character arguments", {
  expect_error(create_connection(1, "password"),
               regexp = "username is not a string")
  expect_error(create_connection("username", 1),
               regexp = "password is not a string")
})
