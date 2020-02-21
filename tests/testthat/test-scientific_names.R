con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_scientific_names", {
  expect_is(scientific_names(con), "character")
  expect_false(any(duplicated(scientific_names(con))))
  expect_true("Anguilla anguilla" %in% scientific_names(con))
})
