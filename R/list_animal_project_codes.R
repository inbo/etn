#' List all available animal project codes
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `project_code` of `type = "animal"` in
#'   `project.sql`.
#'
#' @export
list_animal_project_codes <- function(api = TRUE,
                                      connection) {
  # check arguments
  assertthat::assert_that(assertthat::is.flag(api))
  # Lock in the name of the parent function
  function_identity <-
    get_parent_fn_name()

  # the connection argument has been depriciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection(function_identity)
  }

  arguments_to_pass <-
    return_parent_arguments()[
      !names(return_parent_arguments()) %in% c("api", "connection", "function_identity")]

  if(api){
    out <- do.call(
      forward_to_api,
      list(function_identity = function_identity, payload = arguments_to_pass)
    )
  } else {
    out <- do.call(glue::glue("{function_identity}_sql"), arguments_to_pass)
  }
  return(out)
}

#' list_animal_project_codes() sql helper
#'
#' @inheritParams list_animal_project_codes()
#' @noRd
#'
list_animal_project_codes_sql <- function(){
  # Create connection
  connection <- do.call(connect_to_etn, get_credentials())
  # Check connection
  check_connection(connection)

  project_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "project.sql", package = "etn")),
    .con = connection
  )
  query <- glue::glue_sql(
    "SELECT DISTINCT project_code FROM ({project_sql}) AS project WHERE project_type = 'animal'",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  sort(data$project_code)
}
