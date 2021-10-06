con <- connect_to_etn()

test_that("list_station_names() returns unique list of values", {
  expect_is(list_station_names(con), "character")
  expect_false(any(duplicated(list_station_names(con))))
  expect_true("de-9" %in% list_station_names(con))
})
