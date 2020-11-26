con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("Test output", {
  expect_is(list_station_names(con), "character")
  expect_false(any(duplicated(list_station_names(con))))
  expect_true("R03" %in% list_station_names(con))
})
