#' List all available acoustic tag ids
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `acoustic_tag_id` in `acoustic_tag_id.sql`.
#'
#' @export
list_acoustic_tag_ids <- function(api = TRUE,
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
