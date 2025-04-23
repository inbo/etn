vcr::use_cassette("list_animal_ids", result_api <- list_animal_ids())


test_that("list_animal_ids() returns unique list of values using api", {
  expect_type(result_api, "integer")
  expect_false(any(duplicated(result_api)))
  expect_true(all(!is.na(result_api)))
})

test_that("list_animal_ids() returns same list over api and sql", {
  skip_if_not_localdb()
  result_sql <- list_animal_ids(api = FALSE)

  expect_identical(result_api, result_sql)
})

test_that("list_animal_ids returns at least 5 known values", {
  skip_if_not_localdb()
  result_sql <- list_animal_ids(api = FALSE)

  # a set of 5 known id_pk present in common.animal_release
  known_ids <- c("56314", "8504", "7601", "4293", "58407")

  testthat::expect_true(all(known_ids %in% result_api))
  testthat::expect_true(all(known_ids %in% result_sql))
})
