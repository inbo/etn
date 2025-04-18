skip_if_not_localdb()

con <- connect_to_etn()

test_that("list_scientific_names() returns unique list of values", {
  vector <- list_scientific_names(con)

  expect_type(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("Rutilus rutilus" %in% vector)
})
