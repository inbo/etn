con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_list_scientific_names", {
  expect_is(list_scientific_names(con), "character")
  expect_false(any(duplicated(list_scientific_names(con))))
  expect_true("Anguilla anguilla" %in% list_scientific_names(con))
})
