con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("Test connection", {
  expect_error(check_connection("not_a_connection"))
  expect_true(check_connection(con))
  expect_true(isClass(con, "PostgreSQL"))
})
