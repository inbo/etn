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
  response |>
    httr2::resp_body_string() |>
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
#' @param api_domain Character vector of the OpenCPU domain to use, defaults to
#'   "https://opencpu.lifewatch.be"
#' @param format Character vector of the format to use for the GET request,
#'   either "feather" or "rds", defaults to "feather". Note that feather is
#'   faster, but rds preserves more R specific object types.
#' @param return_url Logical. If `TRUE` fetching the result of the API call. The
#'   url of the result object is returned instead.
#' @param ... Query arguments to pass to OpenCPU. These are arguments to the
#'   writing functions from the [supported
#'   encoders](https://www.opencpu.org/api.html#api-formats). For example:
#'   `compression = "lz4"` in the case of `format = "feather"` is passed to
#'   `arrow::write_feather()`. Other encoders include `base::saveRDS`.
#'
#' @return the uncompressed object resulting form a GET request to the API. If
#'   `return_url` is `TRUE`, the url of the result object is returned instead.
#' @family helper functions
#' @noRd
#' @examples
#' \dontrun{
#' etn:::extract_temp_key(response) |> get_val()
#' }
#'
#' # using the opencpu test instance
#' api_url <- "https://cloud.opencpu.org/ocpu/library/stats/R/rnorm"
#' httr2::request(api_url) |>
#'  httr2::req_body_json(list(n = 10, mean = 5)) |>
#'  httr2::req_perform() |>
#'  extract_temp_key() |>
#'  get_val(api_domain = "https://cloud.opencpu.org/ocpu")
get_val <- function(temp_key,
                    api_domain = "https://opencpu.lifewatch.be",
                    format = c("feather", "rds"),
                    return_url = FALSE,
                    ...) {

  format <- rlang::arg_match(format)
  reading_function <-
    switch(
      format,
      "rds" = \(raw_response){
        raw_connection <- rawConnection(raw_response)
        rds_response <-
          raw_connection |>
          gzcon() |>
          readRDS()
        # close connection
        close(raw_connection)
        # return R object
        return(rds_response)
      },
      "feather" = arrow::read_feather
    )

  # early return in case of return_url
  if(return_url){
    return(
      file.path(api_domain,
                 "tmp",temp_key,"R",".val",format)
    )
  }

  # request data and open connection
  raw_response <-
    httr2::request(api_domain) |>
    httr2::req_url_path_append("tmp", temp_key, "R", ".val", format) |>
    httr2::req_url_query(...) |>
    httr2::req_retry(max_tries = 5) |>
    req_perform_opencpu() |>
    httr2::resp_body_raw()

  # read response via connection
  api_response <-
    raw_response |>
    (\(x) reading_function(x))()

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

#' Check if the provided credentials can be used to login via the API
#'
#' @param domain Character vector of the OpenCPU domain to use, defaults to
#'  "https://opencpu.lifewatch.be"
#' @param credentials A list containing the username and password to use for
#' login, defaults to `get_credentials()`
#'
#' @family helper functions
#' @noRd
validate_login <- function(domain = Sys.getenv("ETN_TEST_API",
                                               unset = "https://opencpu.lifewatch.be/library/etnservice/R"
),
                           credentials = get_credentials()) {
  # Placing a custom request because validate_login accepts username and
  # password directly in the body rather than as a credentials object like the
  # other functions.
  login_valid <- httr2::request(domain) |>
    httr2::req_url_path_append("validate_login", "json/") |>
    httr2::req_body_json(data = credentials) |>
    httr2::req_perform() |>
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

#' Perform a request to OpenCPU to get a response
#'
#' This is a slight modification on httr2::req_perform() to allow for OpenCPU
#' error forwarding. OpenCPU doesn't stick to HTTP error codes, but assigns
#' different meanings and places R error messages in the body of HTTP 400
#' responses.
#'
#' @inheritParams httr2::req_perform
#' @param function_identity Character of length one with the name
#'  of the function the warning is being generated from, defaults to
#'  `get_parent_fn_name(depth = 3)`: the function calling this helper
#'  function.
#' @param ... Additional arguments passed on to `httr2::req_perform()`
#'
#' @return The response object from the request
#' @family helper functions
#' @noRd
req_perform_opencpu <- function(req,
                                function_identity = get_parent_fn_name(),
                                path = NULL,
                                ...) {
  resp <- tryCatch(
    httr2::req_perform(req, ...),
    httr2_http_400 = function(cnd) {
      rlang::abort(
        httr2::resp_body_string(cnd$resp),
        call = call(function_identity),
        footer = c(i = "This is an error forwarded via the API.")
      )
    },
    # OpenCPU reports server side errors as 502 and 503
    httr2_http_502 = function(cnd) {
      rlang::abort(
        c("Server side error",
          "*" = "Please try again.",
          "*" = "If the error persists, please report it to the package authors"
        )
      )
    },
    httr2_http_503 = function(cnd) {
      rlang::abort(
        c("Server side error",
          "*" = "Please try again.",
          "*" = "If the error persists, please report it to the package authors"
        )
      )
    }
  )
  if(!is.null(path)){
    httr2::resp_body_raw(resp) |>
      writeBin(path)
  }
  resp
}
