#' Forward function arguments to API and retrieve response
#'
#' @param function_identity Character vector of what function should be passed
#' @param payload Arguments to be passed to OpenCPU function
#' @param add_credentials Logical, if TRUE, then the credentials are added to
#'   the #'   payload. Defaults to TRUE. You want to turn is off for requests to
#'   libraries other than etnservice.
#' @param json Logical, if TRUE, then a one step process is used the output is
#'   parsed from a json response
#' @param domain Character vector of the OpenCPU domain to use, defaults to
#'   "https://opencpu.lifewatch.be/library/etnservice/R"
#' @return The same return object of the `function_identity` function
#'
#' @family helper functions
#' @noRd
forward_to_api <- function(
    function_identity,
    payload,
    add_credentials = TRUE,
    json = FALSE,
    domain = "https://opencpu.lifewatch.be/library/etnservice/R") {
  # Get credentials and attach to payload
  if (add_credentials) {
    payload <- append(payload, list(credentials = get_credentials()), after = 0)
  }

  request <- httr2::request(domain) %>%
    # Set endpoint based on the passed function_identity
    # NOTE trailing backslash is important for OpenCPU
    httr2::req_url_path_append(function_identity, "") %>%
    httr2::req_body_json(payload) %>%
    httr2::req_retry(max_tries = 5)

  if (json) {
    response <-
      request %>%
      httr2::req_url_path_append("json/") %>%
      httr2::req_perform()

    # Check if the response contains any errors, and forward them if so.
    check_opencpu_response(response)

    # return as a vector
    return(httr2::resp_body_json(response, simplifyVector = TRUE))
  } else {
    # Forward the function and arguments to the API: call 1
    ## Retry if server responds with HTTP error, use default rate settings of httr

    response <- tryCatch(
      httr2::req_perform(request),
      httr2_http_400 = function(cnd) {
        rlang::abort(
          httr2::resp_body_string(httr2::last_response()),
          call = rlang::env_parent(n = 2))
      }
    )

    # Check if the response contains any errors, and forward them if so.
    check_opencpu_response(response)

    # Fetch the output from the API: call 2
    return(
      get_val(extract_temp_key(response),
        api_domain = get_hostname(domain)
      )
    )
  }
}
