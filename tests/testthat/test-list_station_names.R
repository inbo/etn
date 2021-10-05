con <- connect_to_etn()

testthat::test_that("Test output", {
  expect_is(list_station_names(con), "character")
  expect_false(any(duplicated(list_station_names(con))))
  expect_true("R03" %in% list_station_names(con))
})
