test_that("list_receiver_ids() returns unique list of values", {
  vcr::use_cassette("list_receiver_ids", {vector <- list_receiver_ids()})

  expect_type(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("VR2W-124070" %in% vector)
})
