#' List all available animal ids
#'
#'
#' @return A vector of all unique `id_pk` present in `common.animal_release`.
#'
#' @export
list_animal_ids <- function(api = TRUE,
                            connection) {
  ## Lock in the name of the parent function, used to determine what function to
  ## forward to the API

  ### TODO: write helper that can handle complex nesting, eg. in tests.
  function_identity <-
    stringr::str_extract(
      paste(
        deparse(sys.status()$sys.calls[[sys.parent(n = 0)]]),
        collapse = ""
      ),
      "[a-z_]+(?=\\()"
    )

  # the connection argument has been depriciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection(function_identity)
  }

  arguments_to_pass <-
    return_parent_arguments()[
      !names(return_parent_arguments()) %in% c("api", "connection", "function_identity")]

  if(api){
    out <- do.call(glue::glue("{function_identity}_api"), arguments_to_pass)
  } else {
    out <- do.call(glue::glue("{function_identity}_sql"), arguments_to_pass)
  }
  return(out)
}

#' list_animal_ids() api helper
#'
#' @inheritParams list_animal_ids()
#' @noRd
#'
list_animal_ids_api <- function(){
  # Get credentials
  credentials <- get_credentials()
  ## Retrieve the arguments from the function environment
  payload <- return_parent_arguments()

  ## Lock in the name of the parent function, used to determine what function to
  ## forward to the API

  ### TODO: write helper that can handle complex nesting, eg. in tests.
  function_identity <-
    stringr::str_extract(
      paste(
        deparse(sys.status()$sys.calls[[sys.parent()]]),
        collapse = ""),
      "[a-z_]+(?=\\()")

  endpoint <-
    sprintf(
      "https://opencpu.lifewatch.be/library/etnservice/R/%s/",
      function_identity
    )

  # Forward the function and arguments to the API: call 1
  ## Retry if server responds with HTTP error, use default rate settings of httr
  response <-
    httr::RETRY(
      verb = "POST",
      url = endpoint,
      body = payload,
      encode = "json",
      terminate_on = c(400)
    )

  # Check if the response contains any errors, and forward them if so.
  check_opencpu_response(response)

  # Fetch the output from the API: call 2
  get_val(extract_temp_key(response))
}


#' list_animal_ids() sql helper
#'
#' @inheritParams list_animal_ids()
#' @noRd
#'
list_animal_ids_sql <- function() {
  # Create connection
  connection <- do.call(connect_to_etn, get_credentials())
  # Check connection
  check_connection(connection)

  query <- glue::glue_sql(
    "SELECT DISTINCT id_pk FROM common.animal_release",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  sort(data$id_pk)
}
