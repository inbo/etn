if (credentials_are_set()) {
  vcr::use_cassette("list_receiver_ids", {
    receiver_ids <- list_receiver_ids()
  })
}

test_that("list_receiver_ids() returns unique list of values", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  expect_false(any(duplicated(receiver_ids)))
})

test_that("list_receiver_ids() returns a character vector", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  expect_type(receiver_ids, "character")
})

test_that("list_receiver_ids() does not return NA values", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  expect_true(all(!is.na(receiver_ids)))
})

test_that("list_receiver_ids() returns known value", {
  skip_if_no_authentication()
  skip_if_offline("opencpu.lifewatch.be")

  expect_true("VR2W-124070" %in% receiver_ids)
})
