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

#' list_acoustic_project_codes() sql helper
#'
#' @inheritParams list_acoustic_project_codes()
#' @noRd
#'
list_acoustic_project_codes_sql <- function(){
  project_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "project.sql", package = "etn")),
    .con = connection
  )
  query <- glue::glue_sql(
    "SELECT DISTINCT project_code FROM ({project_sql}) AS project WHERE project_type = 'acoustic'",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  sort(data$project_code)
}
