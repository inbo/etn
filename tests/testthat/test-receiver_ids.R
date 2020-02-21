con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_receiver_ids", {
  expect_is(receiver_ids(con), "character")
  expect_false(any(duplicated(receiver_ids(con))))
  expect_true("VR2W-122360" %in% receiver_ids(con))
})
