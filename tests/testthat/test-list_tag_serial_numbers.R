
test_that("list_tag_serial_numbers() returns unique list of values", {
  vector <- list_tag_serial_numbers()

  expect_type(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("1187450" %in% vector)

  vector_sql <- list_tag_serial_numbers(api = FALSE)
  expect_type(vector_sql, "character")
  expect_false(any(duplicated(vector_sql)))
  expect_true(all(!is.na(vector_sql)))

  expect_true("1187450" %in% vector_sql)
})
