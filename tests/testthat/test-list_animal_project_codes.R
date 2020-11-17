con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("Test output", {
  expect_is(list_animal_project_codes(con), "character")
  expect_false(any(duplicated(list_animal_project_codes(con))))
  expect_true("2010_phd_reubens" %in% list_animal_project_codes(con))
  expect_false("thornton" %in% list_animal_project_codes(con))
})
