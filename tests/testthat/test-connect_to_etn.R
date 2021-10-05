test_that("connect_to_etn() allows to create a connection with default parameters", {
  con <- connect_to_etn()
  expect_true(check_connection(con))
  expect_true(isClass(con, "PostgreSQL"))
})

test_that("connect_to_etn() allows to create a connection with specific parameters", {
  con <- connect_to_etn(Sys.getenv("userid"), Sys.getenv("pwd"))
  expect_true(check_connection(con))
  expect_true(isClass(con, "PostgreSQL"))
})
