#' List all available acoustic tag ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `acoustic_tag_id` in `acoustic_tag_id.sql`.
#'
#' @export
list_acoustic_tag_ids <- function(api = TRUE,
                                  connection) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection(function_identity)
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api)
  return(out)
}

#' list_acoustic_tag_ids() sql helper
#'
#' @inheritParams list_acoustic_tag_ids()
#' @noRd
#'
list_acoustic_tag_ids_sql <- function(){
  # Create connection
  connection <- do.call(connect_to_etn, get_credentials())
  # Check connection
  check_connection(connection)

  acoustic_tag_id_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "acoustic_tag_id.sql", package = "etn")),
    .con = connection
  )
  query <- glue::glue_sql("
    SELECT DISTINCT acoustic_tag_id
    FROM ({acoustic_tag_id_sql}) AS acoustic_tag_id
    WHERE acoustic_tag_id IS NOT NULL
  ", .con = connection)
  data <- DBI::dbGetQuery(connection, query)

  stringr::str_sort(data$acoustic_tag_id, numeric = TRUE)
}
