con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_station_names", {
  expect_is(station_names(con), "character")
  expect_false(any(duplicated(station_names(con))))
  expect_true("R03" %in% station_names(con))
})
