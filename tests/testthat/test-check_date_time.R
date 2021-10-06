test_that("Test input", {
  expect_true(check_date_time("1985-11-21") == "1985-11-21")
  expect_true(check_date_time("1985-11") == "1985-11-01")
  expect_true(check_date_time("1985") == "1985-01-01")
  expect_error(
    check_date_time("1985-04-31"),
    paste(
      "The given start_date, 1985-04-31 can not be interpreted",
      "as a valid date."
    )
  )
  expect_error(
    check_date_time("01-03-1973"),
    paste(
      "The given start_date, 01-03-1973, is not in a valid date",
      "format. Use a yyyy-mm-dd format or shorter,",
      "e.g. 2012-11-21, 2012-11 or 2012."
    )
  )
})
