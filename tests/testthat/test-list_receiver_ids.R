con <- connect_to_etn()

testthat::test_that("Test output", {
  expect_is(list_receiver_ids(con), "character")
  expect_false(any(duplicated(list_receiver_ids(con))))
  expect_true("VR2W-122360" %in% list_receiver_ids(con))
})
