con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("Test output", {
  expect_is(list_acoustic_tag_ids(con), "character")
  expect_false(any(duplicated(list_acoustic_tag_ids(con))))
  expect_true("A69-1303-65302" %in% list_acoustic_tag_ids(con))
})
