
ETN_SERVER<-"dppg.vliz.be"
ETN_ODBC_DSN<-"ETN"
ETN_DBNAME<-"ETN"

#' Provide connection to the database with the user credentials
#'
#' @param server char VLIZ server name of the ETN data
#' @param username char username to use the connection
#' @param password char password to use the connection
#'
#' @return conn ODBC connection to the database
#' @export
#'
#' @importFrom RODBC odbcDriverConnect
#' @importFrom DBI dbConnect
#' @importFrom odbc odbc
connect_to_etn <-function(username, password) {

  current_system <- Sys.info()[['sysname']]

  if (current_system == "Windows") {
    conn_string <- paste('driver={PostgreSQL Unicode(x64)};server=', ETN_SERVER,
                         ';username=', tolower(username),
                         ';password=', password,
                         ';database=', ETN_DBNAME, sep = "");
    conn <- odbcDriverConnect(cnnstr,
                              readOnlyOptimize = TRUE)
    return(conn)
  } else if (current_system == "Linux") {
    conn <- dbConnect(odbc::odbc(), ETN_ODBC_DSN,
                      UID = paste("", tolower(username), "", sep = ""),
                      PWD = paste("", password, "", sep = ""))
    return(conn)
  }
}
