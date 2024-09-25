#' Create a local connection to the ETN database
#'
#' Connect to the ETN database using username and password.
#'
#' @param username Character. Username to use for the connection.
#' @param password Character. Password to use for the connection.
#'
#' @return ODBC connection to ETN database.
#' @noRd
create_connection <- function(username, password) {
  # Check the input arguments
  assertthat::assert_that(
    assertthat::is.string(username)
  )
  assertthat::assert_that(
    assertthat::is.string(password)
  )

  # Connect to the ETN database
  con <- DBI::dbConnect(
    odbc::odbc(),
    "ETN",
    uid = tolower(username),
    pwd = password
  )
  return(con)
}
