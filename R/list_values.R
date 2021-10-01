#' Get all distinct values from a specific column of a data.frame
#'
#' This function extracts all distinct values from a given column of a
#' data.frame. If the select column contains characters, multiple values in the
#' same row are split.
#'
#' @param .data A data frame, data frame extension (e.g. a tibble)
#' @param column unquoted or quoted column name or column position
#' @param split character vector containing regular expression(s) to use for
#'   splitting. `split` is internally passed to argument `split` of base R
#'   function `strsplit()`. Default: `","` (comma-separated values)
#'
#' @export
#'
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#'
#' @return a vector of the same type as the given column
#'
#' @examples
#' \dontrun{
#' df <- data.frame(
#'   chr_col = c("A", "B,C", "C,A","D"),
#'   num_col = c(1,2,2,3),
#'   dot_sep_col = c("A", "B.C", "C.A","D"))
#' # split by comma  (default)
#' list_values(df, chr_col) # same as
#' list_values(df, chr_col, split = ",")
#' # access column by column position
#' list_values(df, 1)
#' # split by dot (regex expression: "\\.")
#' list_values(df, dot_sep_col, split = "\\.")
#' # non character column
#' list_values(df, num_col)
#' # list_values can be added to a pipe
#' df %>% list_values(chr_col)
#' }
list_values <- function(.data, column, split = ",") {
  # check .data
  assert_that(is.data.frame(.data))
  # check split
  assert_that(is.character(split))

  arguments <- as.list(match.call())

  if (is.numeric(arguments$column)){
    col_number <- arguments$column
    n_col_df <- ncol(.data)
    assert_that(as.integer(col_number) == col_number,
                msg = "column number must be an integer")
    assert_that(col_number <= ncol(.data),
                msg = glue("column number exceeds the number of columns ",
                           "of .data ({n_col_df})"))
    # extract values
    values <- .data[,col_number]
  } else {
    #check column name
    col_name <- as.character(arguments$column)
    assert_that(length(col_name) == 1,
                msg = "invalid column value")
    assert_that(col_name %in% names(.data),
                msg = glue("column {col_name} not found in .data"))

    # extract values
    if (class(arguments$column) == "name") {
      values <- eval(arguments$column, .data)
    } else {
      if (is.character(arguments$column)) {
        values <- .data[[arguments$column]]
      }
    }
  }

  if (is.character(values))
    # extract all values by splitting strings using split value
    values <- unlist(strsplit(x = values, split = split))
  return(unique(values))
}
