con <- connect_to_etn()

test_that("list_receiver_ids() returns unique list of values", {
  vector <- list_receiver_ids(con)

  expect_is(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("VR2W-124070" %in% vector)
})
