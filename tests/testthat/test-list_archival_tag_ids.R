con <- connect_to_etn()

testthat::test_that("Test output", {
  expect_is(list_archival_tag_ids(con), "character")
  expect_false(any(duplicated(list_archival_tag_ids(con))))
  expect_true("3638" %in% list_archival_tag_ids(con))
})
