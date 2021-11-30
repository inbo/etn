#' List all unique values from a data.frame column
#'
#' Get a vector with all unique values found in a given column of a data.frame.
#' Concatenated values (`A,B`) in the column can be returned as single values
#' (`A` and `B`).
#'
#' @param .data Data frame. Data.frame to select column from.
#' @param column Character or integer. Quoted or unqoted column name or column
#'   position.
#' @param split Character (vector). Character or regular expression(s) passed
#'   to [strsplit()] to split column values before returning unique values.
#'   Defaults to `,`.
#'
#' @return A vector of the same type as the given column.
#'
#' @export
#'
#' @examples
#' # Set default connection variable
#' con <- connect_to_etn()
#' library(dplyr) # For %>%
#'
#' # List unique scientific_name from a dataframe containing animal information
#' df <- get_animals(con, animal_project_code = "2014_demer")
#' list_values(df, "scientific_name")
#'
#' # Or using pipe and unquoted column name
#' df %>% list_values(scientific_name)
#'
#' # Or using column position
#' df %>% list_values(8)
#'
#' # tag_serial_number can contain comma-separated values
#' df <- get_animals(con, animal_id = 5841)
#' df$tag_serial_number
#'
#' # list_values() will split those and return unique values
#' list_values(df, tag_serial_number)
#'
#' # Another expression can be defined to split values (here ".")
#' list_values(df, tag_serial_number, split = "\\.")
list_values <- function(.data, column, split = ",") {
  # check .data
  assertthat::assert_that(is.data.frame(.data))
  # check split
  assertthat::assert_that(is.character(split))

  arguments <- as.list(match.call())

  if (is.numeric(arguments$column)){
    col_number <- arguments$column
    n_col_df <- ncol(.data)
    assertthat::assert_that(as.integer(col_number) == col_number,
                msg = "column number must be an integer")
    assertthat::assert_that(col_number <= ncol(.data),
                msg = glue::glue("column number exceeds the number of columns ",
                                 "of .data ({n_col_df})"))
    # extract values
    values <- .data[,col_number]
    # extract column name
    col_name <- names(.data)[col_number]
  } else {
    #check column name
    col_name <- as.character(arguments$column)
    assertthat::assert_that(length(col_name) == 1,
                msg = "invalid column value")
    assertthat::assert_that(col_name %in% names(.data),
                msg = glue::glue("column {col_name} not found in .data"))

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

  # remove duplicates, unique values only
  values <- unique(values)

  # return a message on console
  message(glue::glue("{length(values)} unique {col_name} values"))

  return(values)
}
