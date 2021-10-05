df <- data.frame(
  chr_col = c("A", "B,C", "C,A", "D"),
  num_col = c(1, 2, 2, 3),
  dot_sep_col = c("A", "B.C", "C.A", "D"),
  stringsAsFactors = FALSE
)

test_that("list_values() returns error for incorrect input", {
  # .data must be a data.frame
  expect_error(list_values(1, "num_col"), ".data is not a data.frame")

  # column must be a character, a column name or a column position
  expect_error(
    list_values(df, TRUE), "column TRUE not found in .data"
  )
  # column must be the name of a valid column of .data
  expect_error(
    list_values(df, strange_col), "column strange_col not found in .data"
  )
  # column must be the character version of the name of a valid column of .data
  expect_error(
    list_values(df, "strange_col"), "column strange_col not found in .data"
  )
  # Not more than one column allowed
  expect_error(
    list_values(df, c(chr_col, dot_col)), "invalid column value"
  )
  # column must be an integer (decimal part = 0)
  expect_error(
    list_values(df, .1), "column number must be an integer"
  )
  # column must be an integer higher than 0
  expect_error(
    list_values(df, -2), "invalid column value"
  )
  # column must be an integer equal or less than number of columns
  expect_error(
    list_values(df, 5),
    "column number exceeds the number of columns of .data (3)",
    fixed = TRUE
  )

  # split must be a character
  expect_error(
    list_values(df, chr_col, split = 1),
    "split is not a character vector"
  )
})

testthat::test_that("list_values() returns a vector with unique values", {
  # Output has right class
  expect_is(list_values(df, chr_col), class = "character")
  expect_is(list_values(df, num_col), class = "numeric")

  # Output value is correct with default split value (comma)
  expect_equal(list_values(df, chr_col), c("A", "B", "C", "D"))

  # Output value is correct with non default split value
  expect_equal(list_values(df, dot_sep_col, "\\."), c("A", "B", "C", "D"))

  # Output value doesn't depend on the way column is passed
  expect_equal(list_values(df, column = chr_col), list_values(df, "chr_col"))
  expect_equal(list_values(df, column = chr_col), list_values(df, 1))
  expect_equal(list_values(df, "num_col"), c(1, 2, 3))

  # If the split value is not present in column, return a copy of the column
  expect_equal(
    list_values(df, "dot_sep_col", split = ","),
    df$dot_sep_col
  )
})
