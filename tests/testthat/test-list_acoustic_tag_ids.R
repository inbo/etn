con <- connect_to_etn()

testthat::test_that("Test output", {
  expect_is(list_acoustic_tag_ids(con), "character")
  expect_false(any(duplicated(list_acoustic_tag_ids(con))))
  expect_true("A69-1601-28294" %in% list_acoustic_tag_ids(con))
})
