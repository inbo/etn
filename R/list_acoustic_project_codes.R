#' List all available acoustic project codes
#'
#'
#' @return A vector of all unique `project_code` of `type = "acoustic"` in
#'   `project.sql`.
#'
#' @inheritParams list_animal_ids
#' @export
list_acoustic_project_codes <- function(connection,
                                        api = TRUE) {
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
  connection <- create_connection(credentials = get_credentials())
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
