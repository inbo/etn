#' Connect to the ETN database
#'
#' `r lifecycle::badge("deprecated")`
#'     Connect to the ETN database using username and password.
#'
#' @param username Character. Username to use for the connection.
#' @param password Character. Password to use for the connection.
#'
#' @return ODBC connection to ETN database.
#'
#' @export
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
connect_to_etn <- function() {
  lifecycle::deprecate_warn(
    when = "2.3.0",
    what = "connect_to_etn()",
    details = "You will be prompted for credentials instead.",
    always = TRUE
  )
  invisible(NULL)
}
