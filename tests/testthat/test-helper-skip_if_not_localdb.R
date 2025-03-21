#' Skip the test if ETN is not a local database on this machine.
#'
#' This function checks if the "ETN" database is present in the list of ODBC
#' data sources on the local machine. If it is not found, the test is skipped
#' with a corresponding message.
#'
skip_if_not_localdb <- function(){
  skip_if_not("ETN" %in% odbc::odbcListDataSources()$name,
              "ETN is not a local database on this machine")
}
