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
  etb_odbc_dsn <- "ETN"

  con <- DBI::dbConnect(odbc::odbc(), etb_odbc_dsn,
    uid = paste("", tolower(username), "", sep = ""),
    pwd = paste("", password, "", sep = "")
  )
  return(con)
}
