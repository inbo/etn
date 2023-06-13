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
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api)
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
