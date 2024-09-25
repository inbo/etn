#' List all available acoustic tag ids
#'
#'
#' @inheritParams list_animal_ids
#' @return A vector of all unique `acoustic_tag_id` in `acoustic_tag_id.sql`.
#'
#' @export
list_acoustic_tag_ids <- function(connection,
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

#' list_acoustic_tag_ids() sql helper
#'
#' @inheritParams list_acoustic_tag_ids()
#' @noRd
#'
list_acoustic_tag_ids_sql <- function(){
  # Create connection
  connection <- do.call(create_connection, get_credentials())
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

  # Close connection
  DBI::dbDisconnect(connection)

  # Return acoustic_tag_ids()
  stringr::str_sort(data$acoustic_tag_id, numeric = TRUE)
}
