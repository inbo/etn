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
    httr2::resp_body_string() %>%
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
#' httr2::request(api_url) %>%
#'  httr2::req_body_json(list(n = 10, mean = 5)) %>%
#'  httr2::req_perform() %>%
#'  extract_temp_key() %>%
#'  get_val(api_domain = "https://cloud.opencpu.org/ocpu")
get_val <- function(temp_key, api_domain = "https://opencpu.lifewatch.be") {
  # request data and open connection
  raw_response <-
    httr2::request(api_domain) %>%
    httr2::req_url_path_append("tmp", temp_key, "R", ".val", "rds") %>%
    httr2::req_retry(max_tries = 5) %>%
    httr2::req_perform() %>%
    httr2::resp_body_raw()
  raw_connection <- rawConnection(raw_response)
  # read response via connection
  api_response <-
    raw_connection %>%
    gzcon() %>%
    readRDS()
  # close connection
  close(raw_connection)
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
#' @param response Response object from an OpenCPU API call (httr2)
#'
#' @family helper functions
#' @noRd
check_opencpu_response <- function(response) {
  # Stop if etnservice forwarded an error
  assertthat::assert_that(response$status_code != 400,
    msg = httr2::resp_body_string(response)
  )

  # Stop for other HTTP errors
  assertthat::assert_that(!httr2::resp_is_error(response),
    msg = glue::glue(
      "API request failed: {http_message}",
      http_message = glue::glue("({httr2::resp_status(response)})",
                                " {httr2::resp_status_desc(response)}")
    )
  )
}

#' Check if the provided credentials can be used to login via the API
#'
#' @param domain Character vector of the OpenCPU domain to use, defaults to
#'  "https://opencpu.lifewatch.be"
#' @param credentials A list containing the username and password to use for
#' login, defaults to `get_credentials()`
#'
#' @family helper functions
#' @noRd
validate_login <- function(domain = "https://opencpu.lifewatch.be",
                           credentials = get_credentials()) {
  # Placing a custom request because validate_login accepts username and
  # password directly in the body rather than as a credentials object like the
  # other functions.
  login_valid <- httr2::request(domain) %>%
    httr2::req_url_path_append("library", "etnservice", "R") %>%
    httr2::req_url_path_append("validate_login", "json/") %>%
    httr2::req_body_json(data = credentials) %>%
    httr2::req_perform() %>%
    httr2::resp_body_json(simplifyVector = TRUE)

  if (!login_valid) {
    rlang::abort(
      glue::glue("Failed to login with username: {get_credentials()$username}.",
                 " Please check username/password."),
      caller = rlang::env_parent()
    )
  }

  return(login_valid)
}

#' Get the hostname from a URL string
#'
#' @param url_str A character string containing a URL
#'
#' @return The hostname extracted from the URL string including the scheme (eg.
#'   https)
#'
#' @family helper functions
#' @noRd
#' @examples
#' get_hostname("https://opencpu.lifewatch.be/library/etnservice/R")
get_hostname <- function(url_str){
  # the hostname + everything in the path before `library`, because opencpu
  # doesn't need to be hosted directly on the hostname. Useful for testing on
  # other domains than etn.
  stringr::str_extract(url_str, ".+(?=library)")
}

#' Check if the locally installed version of etnservice matches the version
#' deployed on the API exactly.
#'
#' This function is useful to ensure that the local package version is
#' compatible with the API version. This is checked by comparing the version
#' returned by `etnservice::get_version()` with the version returned by the API
#' endpoint `get_version`.
#'
#' This is important to make sure that a function calls return consistent ree
#' version of the package installed locally.ts regardsless of the argument
#' `api`.
#'
#' The exact version of the package installed locally can be returned by
#' `etnservice::get_version()`, the version deployed can be returned by calling
#' `forward_to_api("get_version", add_credentials = FALSE)`
#'
#' @param ... Additional arguments passed to `etnservice::get_version()`. These
#'   are used to specify the API endpoint, such as `api =
#'   "https://api.etnservice.com"`.
#' @return A logical value indicating whether the locally installed version of
#'   etnservice is the same as the one deployed online.
#' @noRd
#' @family helper functions
etnservice_version_matches <- function(...){
  setequal(
    etnservice::get_version(...),
    forward_to_api(
      "get_version",
      payload = ...,
      add_credentials = FALSE,
      json = TRUE
    )
  )
}
