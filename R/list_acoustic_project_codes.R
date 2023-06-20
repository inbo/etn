#' List all available acoustic project codes
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `project_code` of `type = "acoustic"` in
#'   `project.sql`.
#'
#' @export
list_acoustic_project_codes <- function(api = TRUE,
                                        connection) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api, json = TRUE)
  return(out)
}

#' list_acoustic_project_codes() sql helper
#'
#' @inheritParams list_acoustic_project_codes()
#' @noRd
#'
list_acoustic_project_codes_sql <- function(){
  # Create connection
  connection <- do.call(connect_to_etn, get_credentials())
  # Check connection
  check_connection(connection)
  project_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "project.sql", package = "etn")),
    .con = connection
  )
  query <- glue::glue_sql(
    "SELECT DISTINCT project_code FROM ({project_sql}) AS project WHERE project_type = 'acoustic'",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return acoustic_project_codes
  sort(data$project_code)
}
