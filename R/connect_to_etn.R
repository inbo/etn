#' Connect to the ETN database
#'
#' Connect to the ETN database using username and password.
#'
#' @param username Character. Username to use for the connection.
#' @param password Character. Password to use for the connection.
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
#' # Connect to the ETN database using your rstudio.lifewatch.be username and
#' # password, and save as the default connection variable "con"
#' con <- connect_to_etn()
#'
#' # Connect to the ETN database using non-default username and password
#' con <- connect_to_etn(username = "my_username", password = "my_password")
#' }
connect_to_etn <- function(username = Sys.getenv("userid"),
                           password = Sys.getenv("pwd")) {
  con <- DBI::dbConnect(
    odbc::odbc(),
    "ETN",
    uid = paste("", tolower(username), "", sep = ""),
    pwd = paste("", password, "", sep = "")
  )
  return(con)
}
