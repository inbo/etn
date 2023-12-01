# HELPER FUNCTIONS

#' Check the validity of the database connection
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @family helper functions
#' @noRd
check_connection <- function(connection) {
  assertthat::assert_that(
    methods::is(connection, "PostgreSQL"),
    msg = "Not a connection object to database."
  )
  assertthat::assert_that(connection@info$dbname == "ETN")
}

#' Check input value against valid values
#'
#' @param x Value(s) to test.
#'   `NULL` values will automatically pass.
#' @param y Value(s) to test against.
#' @param name Name of the parameter.
#' @param lowercase If `TRUE`, the case of `x` and `y` values will ignored and
#'   `x` values will be returned lowercase.
#' @return Error or (lowercase) `x` values.
#' @family helper functions
#' @noRd
check_value <- function(x, y, name = "value", lowercase = FALSE) {
  # Remove NA from valid values
  y <- y[!is.na(x)]

  # Ignore case
  if (lowercase) {
    x <- tolower(x)
    y <- tolower(y)
  }

  # Check value(s) against valid values
  assertthat::assert_that(
    all(x %in% y), # Returns TRUE for x = NULL
    msg = glue::glue(
      "Can't find {name} `{x}` in: {y}",
      x = glue::glue_collapse(x, sep = "`, `", last = "` and/or `"),
      y = glue::glue_collapse(y, sep = ", ", width = 300)
    )
  )

  return(x)
}

#' Check if the string input can be converted to a date
#'
#' Returns `FALSE`` or the cleaned character version of the date
#' (acknowledgments to micstr/isdate.R).
#'
#' @param date_time Character. A character representation of a date.
#' @param date_name Character. Informative description to user about type of
#'   date.
#' @return `FALSE` | character
#' @family helper functions
#' @noRd
#' @examples
#' \dontrun{
#' check_date_time("1985-11-21")
#' check_date_time("1985-11")
#' check_date_time("1985")
#' check_date_time("1985-04-31") # invalid date
#' check_date_time("01-03-1973") # invalid format
#' }
check_date_time <- function(date_time, date_name = "start_date") {
  parsed <- tryCatch(
    lubridate::parse_date_time(date_time, orders = c("ymd", "ym", "y")),
    warning = function(warning) {
      if (grepl("No formats found", warning$message)) {
        stop(glue::glue(
          "The given {date_name}, {date_time}, is not in a valid ",
          "date format. Use a yyyy-mm-dd format or shorter, ",
          "e.g. 2012-11-21, 2012-11 or 2012."
        ))
      } else {
        stop(glue::glue(
          "The given {date_name}, {date_time} can not be interpreted ",
          "as a valid date."
        ))
      }
    }
  )
  as.character(parsed)
}

#' Helper to fetch query results via tempfile and built in paging
#'
#' @param connection connection A connection to the ETN database. Defaults to `con`.
#' @param query The query to send to the db, as per `glue::glue_sql()`
#' @param page_size Number of rows per returned page.
#' @param progress Logical. Should a progress bar for the fetchign stage be shown?
#'
#' @return A data.frame of the result of the sent query.

fetch_result_paged <-
  function(connection,
           query,
           page_size = 1000,
           progress = FALSE
  ){

  assertthat::assert_that(assertthat::is.count(page_size))

  # Stop a progress bar from appearing if not required
    if(!progress) {
      withr::local_options(cli.progress_show_after = Inf)
    }
  # Create result object to page into = Execute query on DB
  result <- DBI::dbSendQuery(connection, query, immediate = FALSE)
  # When this function exits, clear the result (Mandatory)
  withr::defer(DBI::dbClearResult(result))

  # Fetch some information about our result object
  result_colnames <- DBI::dbColumnInfo(result)$name
  result_nrow <- DBI::dbGetInfo(result)$rows.affected

  # Create tempfile to write to, automatically delete when function completes
  partial_result_file <- withr::local_tempfile()

  # Initialize a progress bar
  # pb <- progress::progress_bar$new(
  #   total = result_nrow,
  #   format = "  fetching [:bar] :percent in :elapsed",
  #   width = 60
  # )
  # withr::defer(pb$terminate())
  cli::cli_progress_bar("Fetching result from ETN", total = result_nrow)
  ## set object to keep track of howmany rows have been fetched
  rows_done <- 0
  # Fetch pages of the result until we have everything
  while(!DBI::dbHasCompleted(result)){

    readr::write_csv(DBI::dbFetch(result, n = page_size),
                     partial_result_file,
                     append = TRUE,
                     progress = FALSE)
    rows_done <- rows_done + page_size
    # rows_done <- DBI::dbGetInfo(result)$row.count
    # pb$update(rows_done/result_nrow)
    cli::cli_progress_update(set =
      # length(readr::read_lines(partial_result_file, progress = FALSE))
      rows_done
      )
    }
  # Read the temp file we wrote the result data.frame to
  result_df <-
    readr::read_csv(
    partial_result_file,
    col_names = result_colnames,
    show_col_types = FALSE,
    progress = FALSE
  )

  return(result_df)
}
