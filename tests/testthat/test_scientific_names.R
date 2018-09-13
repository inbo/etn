context("test_scientific_names")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_scientific_names", {
  expect_is(scientific_names(con), "character")
})
