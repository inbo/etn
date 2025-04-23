skip_if_not_localdb()

con <- connect_to_etn()

test_that("list_receiver_ids() returns unique list of values", {
  if (!exists("receiver_ids")) {
    receiver_ids <- list_receiver_ids(con)
  }
  expect_false(any(duplicated(receiver_ids)))
})

test_that("list_receiver_ids() returns a character vector", {
  if (!exists("receiver_ids")) {
    receiver_ids <- list_receiver_ids(con)
  }
  expect_type(receiver_ids, "character")
})

test_that("list_receiver_ids() does not return NA values", {
  if (!exists("receiver_ids")) {
    receiver_ids <- list_receiver_ids(con)
  }
  expect_true(all(!is.na(receiver_ids)))
})

test_that("list_receiver_ids() returns known value", {
  if (!exists("receiver_ids")) {
    receiver_ids <- list_receiver_ids(con)
  }
  expect_true("VR2W-124070" %in% receiver_ids)
})
