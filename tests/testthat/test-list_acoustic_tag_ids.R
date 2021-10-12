con <- connect_to_etn()

test_that("list_acoustic_tag_ids() returns unique list of values", {
  expect_is(list_acoustic_tag_ids(con), "character")
  expect_false(any(duplicated(list_acoustic_tag_ids(con))))

  # Should include acoustic tags
  expect_true("A69-1601-16130" %in% list_acoustic_tag_ids(con))
  # Should include acoustic archival tags
  expect_true("A69-9006-11100" %in% list_acoustic_tag_ids(con))
  # Should include acoustic_tag_id_alternative that are not an acoustic_tag_id
  expect_true("A69-1105-155" %in% list_acoustic_tag_ids(con))
})
