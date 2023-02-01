con <- connect_to_etn()

test_that("list_deployment_ids() returns unique list of values", {
  vector <- list_deployment_ids(con)

  expect_type(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("1437" %in% vector)
})
