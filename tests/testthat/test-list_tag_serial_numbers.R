
test_that("list_tag_serial_numbers() returns unique list of values", {
  vcr::use_cassette("list_tag_serial_numbers", {
    vector <- list_tag_serial_numbers()
  })

  expect_type(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("1187450" %in% vector)


})

test_that("list_tag_serial_numbers() returns unique list of values using api", {
  skip_if_not_localdb()
  
  vector_sql <- list_tag_serial_numbers(api = FALSE)
  expect_type(vector_sql, "character")
  expect_false(any(duplicated(vector_sql)))
  expect_true(all(!is.na(vector_sql)))

  expect_true("1187450" %in% vector_sql)
})
