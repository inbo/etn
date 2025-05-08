#' Forward function arguments to API and retrieve response
#'
#' @param function_identity Character vector of what function should be passed
#' @param payload Arguments to be passed to OpenCPU function
#' @param json Logical, if TRUE, then a one step process is used the output is
#'   parsed from a json response
#' @return The same return object of the `function_identity` function
#'
#' @family helper functions
#' @noRd
forward_to_api <- function(
    function_identity,
    payload,
    json = FALSE,
    domain = "https://opencpu.lifewatch.be/library/etnservice/R") {
  # Get credentials and attatch to payload
  payload <- append(payload, list(credentials = get_credentials()), after = 0)
  # Set endpoint based on the passed function_identity
  # NOTE trailing backslash is important for OpenCPU
  endpoint <- glue::glue("{domain}/{function_identity}/")

  if (json) {
    response <-
      httr::RETRY(
        verb = "POST",
        url = glue::glue(endpoint, "json/"),
        body = payload,
        encode = "json",
        terminate_on = c(400),
        times = 5
      )
    # Check if the response contains any errors, and forward them if so.
    check_opencpu_response(response)

    # return as a vector
    return(unlist(httr::content(response, as = "parsed")))
  } else {
    # Forward the function and arguments to the API: call 1
    ## Retry if server responds with HTTP error, use default rate settings of httr
    response <-
      httr::RETRY(
        verb = "POST",
        url = endpoint,
        body = payload,
        encode = "json",
        terminate_on = c(400),
        times = 5
      )

    # Check if the response contains any errors, and forward them if so.
    check_opencpu_response(response)

    # Fetch the output from the API: call 2
    return(get_val(extract_temp_key(response)))
  }
}
