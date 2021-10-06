con <- connect_to_etn()

test_that("list_tag_serial_numbers() returns unique list of values", {
  expect_is(list_tag_serial_numbers(con), "character") # Even though the DB values are integer
  expect_false(any(duplicated(list_tag_serial_numbers(con))))
  expect_true("1187450" %in% list_tag_serial_numbers(con))
})
