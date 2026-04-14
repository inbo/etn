#' Forward function arguments to API and retrieve response
#'
#' @param function_identity Character vector of what function should be passed
#' @param payload Arguments to be passed to OpenCPU function
#' @param add_credentials Logical, if TRUE, then the credentials are added to
#'   the #'   payload. Defaults to TRUE. You want to turn is off for requests to
#'   libraries other than etnservice.
#' @param format Character, either "rds", "feather", or "json". This determines
#' how the result is fetched from the API. "feather" is faster, but does not
#' preserve all R object types. "rds" is slower, but preserves all R object
#' types. "json" fetches the result directly as JSON in a single request, but
#' only works for simple R object types that can be represented in JSON.
#'
#' @param domain Character vector of the OpenCPU domain to use, defaults to
#'   "https://opencpu.lifewatch.be/library/etnservice/R". A test domain can be
#'   set via the environmental variable `ETN_TEST_API`. VLIZ has requested the
#'   authors to not disclose this test url.
#' @param ... Additional arguments passed to the `get_val` function, such as
#'  `return_url`.
#' @return The same return object of the `function_identity` function.
#'
#' @family helper functions
#' @noRd
forward_to_api <- function(
    function_identity,
    payload = list(),
    add_credentials = TRUE,
    format = c("rds", "feather", "json"),
    json = FALSE,
    domain = Sys.getenv("ETN_TEST_API",
      unset = "https://opencpu.lifewatch.be/library/etnservice/R"
    ),
    ...) {
  format <- rlang::arg_match(format)
  # If the requested format is JSON, switch to a one step process.

  if (format == "json") {
    json <- TRUE
  }
  # Get credentials and attach to payload
  if (add_credentials) {
    # Get credentials out of .Renviron or prompt user.
    provided_credentials <- get_credentials()
    # Check if username/password are correct.
    # Skip check when testing, makes caching HTTP requests difficult due to
    # memoisation
    if (!is_testing()) {
      validate_login(credentials = provided_credentials)
    }
    # Add credentials to payload if correct and required.
    payload <-
      append(payload, list(credentials = provided_credentials), after = 0)
  }

  request <- httr2::request(domain) |>
    # Set endpoint based on the passed function_identity
    # NOTE trailing backslash is important for OpenCPU
    httr2::req_url_path_append(function_identity, "") |>
    httr2::req_body_json(payload) |>
    # Setup retry strategy
    httr2::req_retry(
      max_tries = 5,
      is_transient = function(resp) {
        # OpenCPU server side errors, sometimes transient
        httr2::resp_status(resp) %in% c(502, 503)
      }
    )

  # We can actually send a request and immediately fetch the result by requesting
  # JSON, but using a two step protocol allows us to get the exact R object that
  # was returned back via RDS (`get_val()`).
  if (json) {
    request <- request |>
      httr2::req_url_path_append("json/")
  }

  # Forward the function and arguments to the API: call 1, forward any R errors

  response <- req_perform_opencpu(request,
    function_identity = function_identity
  )


  if (json) {
    # return as a vector
    return(httr2::resp_body_json(response, simplifyVector = TRUE))
  } else {
    # Fetch the output from the API: call 2
    return(
      get_val(extract_temp_key(response),
        api_domain = get_hostname(domain),
        format = format,
        ...
      )
    )
  }
}
