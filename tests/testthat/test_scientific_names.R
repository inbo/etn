context("check_scientific_names")

testthat::test_that("check_scientific_names", {
  expect_is(scientific_names(con), "character")
})
