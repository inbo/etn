con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_list_receiver_ids", {
  expect_is(list_receiver_ids(con), "character")
  expect_false(any(duplicated(list_receiver_ids(con))))
  expect_true("VR2W-122360" %in% list_receiver_ids(con))
})
