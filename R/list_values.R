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
#' @return A vector of the same type as the given column.
#' @family list functions
#' @export
#' @examplesIf etn:::credentials_are_set()
#' # List unique scientific_name from a dataframe containing animal information
#' df <- get_animals(animal_project_code = "2014_demer")
#' list_values(df, "scientific_name")
#'
#' # Or using pipe and unquoted column name
#' df |> list_values(scientific_name)
#'
#' # Or using column position
#' df |> list_values(8)
#'
#' # tag_serial_number can contain comma-separated values
#' df <- get_animals(animal_id = 5841)
#' df$tag_serial_number
#'
#' # list_values() will split those and return unique values
#' list_values(df, tag_serial_number)
#'
#' # Another expression can be defined to split values (here ".")
#' list_values(df, tag_serial_number, split = "\\.")
list_values <- function(.data, ... , split = ",") {
  # check .data
  if (!is.data.frame(.data)) {
    cli::cli_abort(
      "Argument {.arg .data} must be a data.frame.",
      class = "etn_error_not_df"
    )
  }
  # check split
  if (!is.character(split)) {
    cli::cli_abort(
      "Argument {.arg split} must be a character.",
      class = "etn_error_invalid_split"
    )
  }

  # Check column selection type
  col_select_chr_or_numeric <-
    purrr::map_lgl(rlang::enquos(...), \(cols) {is.character(cols) ||
      is.numeric(cols)}) |>
    all()

  if(!col_select_chr_or_numeric){
    cli::cli_abort(
      paste("Could not resolve supplied {.arg column}.",
        "Must be a valid column name or index: ","
        {purrr::map_chr(rlang::enquos(...), rlang::as_label)}"),
      class = "etn_error_invalid_column"
    )
  }

    # extract values
  values <- dplyr::pull(.data, ...)

  if (is.character(values)) {
    # extract all values by splitting strings using split value
    values <- unlist(strsplit(x = values, split = split))
  }

  # remove duplicates, unique values only
  values <- unique(values)

  # return a message on console
  rlang::inform(message = paste(
    length(values),
    "unique",
    purrr::map_chr(rlang::enquos(...), rlang::as_label),
    "values"
  ))

  return(values)
}
