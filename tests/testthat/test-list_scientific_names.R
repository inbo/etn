con <- connect_to_etn()

test_that("list_scientific_names() returns unique list of values", {
  expect_is(list_scientific_names(con), "character")
  expect_false(any(duplicated(list_scientific_names(con))))
  expect_true("Rutilus rutilus" %in% list_scientific_names(con))
})
