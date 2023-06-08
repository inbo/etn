test_that("list_animal_ids() returns unique list of values", {
  result_api <- list_animal_ids()
  result_sql <- list_animal_ids(api = FALSE)
  expect_type(result_api, "integer")
  expect_false(any(duplicated(result_api)))
  expect_true(all(!is.na(result_api)))
  expect_identical(result_api, result_sql)
})

test_that("list_animal_ids returns at least 5 known values", {
  result <- list_animal_ids()

  # a set of 5 known id_pk present in common.animal_release
  known_ids <- c("56314", "8504", "7601", "4293", "58407")

  testthat::expect_true(all(known_ids %in% result))
})

test_that("list_animal_ids() warns for depreciation of connection", {
  # snapshot warning only, not values
  expect_snapshot(
    animal_ids <- list_animal_ids(connection = "any_object")
  )
})
