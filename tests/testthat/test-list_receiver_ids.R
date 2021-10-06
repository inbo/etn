con <- connect_to_etn()

test_that("list_receiver_ids() returns unique list of values", {
  expect_is(list_receiver_ids(con), "character")
  expect_false(any(duplicated(list_receiver_ids(con))))
  expect_true("VR2W-124070" %in% list_receiver_ids(con))
})
