#' Connect to the database using username and password.
#'
#' @param username (character) Username to use for the connection.
#' @param password (character) Password to use for the connection.
#'
#' @return con ODBC connection to ETN database.
#'
#' @export
#'
#' @importFrom DBI dbConnect
#' @importFrom odbc odbc
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(Sys.getenv("userid"), Sys.getenv("pwd"))
#' }
connect_to_etn <- function(username,
                           password) {
  ETN_ODBC_DSN <- "ETN"
  # ETN_SERVER <- "dppg.vliz.be"
  # ETN_DBNAME <- "ETN"

  con <- DBI::dbConnect(odbc::odbc(), ETN_ODBC_DSN,
    UID = paste("", tolower(username), "", sep = ""),
    PWD = paste("", password, "", sep = "")
  )
  return(con)
}
