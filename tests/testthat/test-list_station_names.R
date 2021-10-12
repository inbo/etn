con <- connect_to_etn()

test_that("list_station_names() returns unique list of values", {
  vector <- list_station_names(con)

  expect_is(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("de-9" %in% vector)
})
