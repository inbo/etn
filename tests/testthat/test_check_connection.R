context("check_connection")

user = rstudioapi::askForPassword("GBIF username")
pwd = rstudioapi::askForPassword("GBIF password")
con <- connect_to_etn(username, password)

testthat::test_that("check_connection", {
  expect_true(isClass(con, "PostgreSQL"))
})
