
ETN_SERVER<-"dppg.vliz.be"
ETN_ODBC_DSN<-"ETN"
ETN_DBNAME<-"ETN"

#' Provide connection to the database with the user credentials
#'
#' @param username char username to use the connection
#' @param password char password to use the connection
#'
#' @return conn ODBC connection to the database
#' @export
#'
#' @importFrom DBI dbConnect
#' @importFrom odbc odbc
connect_to_etn <-function(username, password) {
  conn <- dbConnect(odbc::odbc(), ETN_ODBC_DSN,
                    UID = paste("", tolower(username), "", sep = ""),
                    PWD = paste("", password, "", sep = ""))
  return(conn)
}
