con <- connect_to_etn()

test_that("list_acoustic_tag_ids() returns unique list of values", {
  vector <- list_acoustic_tag_ids(con)

  expect_is(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  # Should include acoustic tags
  expect_true("A69-1601-16130" %in% vector)
  # Should include acoustic archival tags
  expect_true("A69-9006-11100" %in% vector)
  # Should include acoustic_tag_id_alternative that are not an acoustic_tag_id
  expect_true("A69-1105-155" %in% vector)
})
