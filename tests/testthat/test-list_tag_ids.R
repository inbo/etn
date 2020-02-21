con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("check_list_tag_ids", {
  expect_is(list_tag_ids(con), "character")
  expect_false(any(duplicated(list_tag_ids(con))))
  expect_true("A69-1303-65302" %in% list_tag_ids(con))
})
