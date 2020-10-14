#' Connect to the ETN database
#'
#' Connect to the ETN database using username and password.
#'
#' @param username Character. Username to use for the connection. Required.
#' @param password Character. Password to use for the connection. Required.
#'
#' @return ODBC connection to ETN database.
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
