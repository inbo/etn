con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_connection", {
  expect_error(check_connection("I am not a connection"))
  expect_true(check_connection(con))
  expect_true(isClass(con, "PostgreSQL"))
})
