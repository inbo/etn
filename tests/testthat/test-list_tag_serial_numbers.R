con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("Test output", {
  expect_is(list_tag_serial_numbers(con), "character")
  expect_false(any(duplicated(list_tag_serial_numbers(con))))
  expect_true("1157779" %in% list_tag_serial_numbers(con))
})
