# API HELPER FUNCTIONS

#' Extract the OCPU temp key from a response object
#'
#' When posting a request to the opencpu api service without the json flag, a
#' response object is returned containing all the generated objects, with a
#' unique temp key in the path. To retrieve these objects in a subsequent GET
#' request, it is convenient to retrieve this temp key from the original
#' response object
#'
#' @param response The response resulting from a POST request to a opencpu api
#'   service
#'
#' @return the OCPU temp key to be used as part of a GET request to an opencpu
#'   api service
#' @family helper functions
#' @noRd
extract_temp_key <- function(response) {
  response %>%
    httr::content(as = "text") %>%
    stringr::str_extract("(?<=tmp\\/).{15}(?=\\/)")
}

#' Retrieve the result of a function called to the opencpu api
#'
#' Fetch the result of an API call to OpenCPU
#'
#' This function is used internally to GET an evaluated object from an OpenCPU
#' api, to GET a result, you must of course POST a function call first
#'
#' @param temp_key the temp key returned from the POST request to the API
#'
#' @return the uncompressed object resulting form a GET request to the API
#' @family helper functions
#' @noRd
#' @examples
#' \dontrun{
#' etn:::extract_temp_key(response) %>% get_val()
#' }
#'
#' # using the opencpu test instance
#' api_url <- "https://cloud.opencpu.org/ocpu/library/stats/R/rnorm"
#' httr::POST(api_url, body = list(n = 10, mean = 5)) %>%
#'   extract_temp_key() %>%
#'   get_val(api_domain = "https://cloud.opencpu.org/ocpu")
get_val <- function(temp_key, api_domain = "https://opencpu.lifewatch.be") {
  # request data and open connection
  response_connection <- httr::RETRY(
    verb = "GET",
    url = glue::glue(
      "{api_domain}",
      "tmp/{temp_key}/R/.val/rds",
      .sep = "/"
    ),
    times = 5
  ) %>%
    httr::content(as = "raw") %>%
    rawConnection()
  # read connection
  api_response <- response_connection %>%
    gzcon() %>%
    readRDS()
  # close connection
  close(response_connection)
  # Return OpenCPU return object
  return(api_response)
}

#' Return the arguments as a named list of the parent environment
#'
#' Because the requests to the API are so similar, it's more DRY to pass the
#' function arguments of the parent function directly to the API, instead of
#' repeating them in the function body.
#'
#' @return a named list of name value pairs form the parent environement
#'
#' @family helper functions
#' @noRd
return_parent_arguments <- function(depth = 1) {
  # lock in the environment of the function we are being called in. Otherwise
  # lazy evaluation can cause trouble
  parent_env <- rlang::caller_env(n = depth)
  env_names <- rlang::env_names(parent_env)
  # set the environement names so lapply can output a names list
  names(env_names) <- env_names
  lapply(
    env_names,
    function(x) rlang::env_get(env = parent_env, nm = x)
  )
}

#' Check an OpenCPU reponse object and forward any errors
#'
#' @param response httr::response object from an OpenCPU API call
#'
#' @family helper functions
#' @noRd
check_opencpu_response <- function(response) {
  # Stop if etnservice forwarded an error
  assertthat::assert_that(response$status_code != 400,
                          msg = httr::content(response,
                                              as = "text",
                                              encoding = "UTF-8"
                          )
  )

  # Stop for other HTTP errors
  assertthat::assert_that(!httr::http_error(response),
                          msg = glue::glue(
                            "API request failed: {http_message}",
                            http_message = httr::http_status(response)$message
                          )
  )
}
