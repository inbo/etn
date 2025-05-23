skip_if_not_localdb()

con <- connect_to_etn()

test_that("list_tag_serial_numbers() returns unique list of values", {
  vector <- list_tag_serial_numbers(con)

  expect_type(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("1187450" %in% vector)
})
