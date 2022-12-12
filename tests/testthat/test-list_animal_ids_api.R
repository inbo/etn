test_that("list_animal_ids_api() returns unique list of values", {
  result <- list_animal_ids_api()

  # tests based on test-list_animal_project_codes.R
  expect_is(result, "integer")
  expect_false(any(duplicated(result)))
  expect_true(all(!is.na(result)))
})

test_that("list_animal_ids_api() returns at least 5 known values", {
  result <- list_animal_ids_api()

  # a set of 5 known id_pk present in common.animal_release
  known_ids <- c("56314", "8504", "7601", "4293", "58407")

  testthat::expect_true(all(known_ids %in% result))
})
