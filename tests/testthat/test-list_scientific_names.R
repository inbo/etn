con <- connect_to_etn()

testthat::test_that("Test output", {
  expect_is(list_scientific_names(con), "character")
  expect_false(any(duplicated(list_scientific_names(con))))
  expect_true("Silurus glanis" %in% list_scientific_names(con))
})
