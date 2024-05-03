test_that("list_station_names() returns unique list of values", {
  vcr::use_cassette("list_station_names", {
    vector <- list_station_names()
  })

  expect_type(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("de-9" %in% vector)
})
