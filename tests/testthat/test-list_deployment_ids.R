test_that("list_deployment_ids() returns unique list of values using api", {
  vcr::use_cassette("list_deployment_ids", {vector <- list_deployment_ids()})

  expect_type(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("1437" %in% vector)
})

test_that("list_deployment_ids() returns unique list of values using local db", {
  skip_if_not_localdb()
  vector_sql <- list_deployment_ids(api = FALSE)

  expect_type(vector_sql, "character")
  expect_false(any(duplicated(vector_sql)))
  expect_true(all(!is.na(vector_sql)))

  expect_true("1437" %in% vector_sql)
})
