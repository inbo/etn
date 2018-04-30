#' Provide connection to the database using user credentials username and
#' password.
#'
#' @param username (character) Username to use for the  connection.
#' @param password (character) Password to use for the connection.
#'
#' @return conn ODBC connection to ETN database.
#'
#' @export
#'
#' @importFrom DBI dbConnect
#' @importFrom odbc odbc
connect_to_etn <-function(username, password) {
  conn <- DBI::dbConnect(odbc::odbc(), ETN_ODBC_DSN,
                    UID = paste("", tolower(username), "", sep = ""),
                    PWD = paste("", password, "", sep = ""))
  return(conn)
}

#' ETN database informations
ETN_SERVER<-"dppg.vliz.be"
ETN_ODBC_DSN<-"ETN"
ETN_DBNAME<-"ETN"
