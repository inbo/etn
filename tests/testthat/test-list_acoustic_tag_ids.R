con <- connect_to_etn()

test_that("list_acoustic_tag_ids() returns unique list of values", {
  expect_is(list_acoustic_tag_ids(con), "character")
  expect_false(any(duplicated(list_acoustic_tag_ids(con))))
  expect_true("A69-1601-16130" %in% list_acoustic_tag_ids(con))
})
