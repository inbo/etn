#' List all available scientific names
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `scientific_name` present in
#'   `common.animal_release`.
#'
#' @export
list_scientific_names <- function(api = TRUE,
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
#' list_scientific_names() sql helper
#'
#' @inheritParams list_scientific_names()
#' @noRd
#'
list_scientific_names_sql <- function(){
  query <- glue::glue_sql(
    "SELECT DISTINCT scientific_name FROM common.animal_release",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  sort(data$scientific_name)
}
