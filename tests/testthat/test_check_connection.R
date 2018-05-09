context("check_connection")

user <- rstudioapi::askForPassword("Username")
pwd <- rstudioapi::askForPassword("Password")
con <- connect_to_etn(username, password)

testthat::test_that("check_connection", {
  expect_error(check_connection("I am not a connection"))
  expect_true(check_connection(con))
  expect_true(isClass(con, "PostgreSQL"))
})
