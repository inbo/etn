# HELPER FUNCTIONS

#' Check input value against valid values
#'
#' @param x Value(s) to test.
#'   `NULL` values will automatically pass.
#' @param y Value(s) to test against.
#' @param name Name of the parameter.
#' @param lowercase If `TRUE`, the case of `x` and `y` values will ignored and
#'   `x` values will be returned lowercase.
#' @return Error or (lowercase) `x` values.
#' @family helper functions
#' @noRd
check_value <- function(x, y, name = "value", lowercase = FALSE) {
  # Remove NA from valid values
  y <- y[!is.na(y)]

  # Ignore case
  if (lowercase) {
    x <- tolower(x)
    y <- tolower(y)
  }

  # Check value(s) against valid values
  assertthat::assert_that(
    all(x %in% y), # Returns TRUE for x = NULL
    msg = glue::glue(
      "Can't find {name} `{x}` in: {y}",
      x = glue::glue_collapse(x, sep = "`, `", last = "` and/or `"),
      y = glue::glue_collapse(y, sep = ", ", width = 300)
    )
  )

  return(x)
}

#' Check if the string input can be converted to a date
#'
#' Returns `FALSE`` or the cleaned character version of the date
#' (acknowledgments to micstr/isdate.R).
#'
#' @param date_time Character. A character representation of a date.
#' @param date_name Character. Informative description to user about type of
#'   date.
#' @return `FALSE` | character
#' @family helper functions
#' @noRd
#' @examples
#' \dontrun{
#' check_date_time("1985-11-21")
#' check_date_time("1985-11")
#' check_date_time("1985")
#' check_date_time("1985-04-31") # invalid date
#' check_date_time("01-03-1973") # invalid format
#' }
check_date_time <- function(date_time, date_name = "start_date") {
  parsed <- tryCatch(
    lubridate::parse_date_time(date_time, orders = c("ymd", "ym", "y")),
    warning = function(warning) {
      if (grepl("No formats found", warning$message)) {
        stop(glue::glue(
          "The given {date_name}, {date_time}, is not in a valid ",
          "date format. Use a yyyy-mm-dd format or shorter, ",
          "e.g. 2012-11-21, 2012-11 or 2012."
        ))
      } else {
        stop(glue::glue(
          "The given {date_name}, {date_time} can not be interpreted ",
          "as a valid date."
        ))
      }
    }
  )
  as.character(parsed)
}

#' Get the credentials from environment variables, or set them manually
#'
#' By default, it's not necessary to set any values in this function as it's
#' used in the background by other functions. However, if you wish to provide
#' your username and password on a per function basis, this function allows you
#' to do so.
#'
#' @param username ETN Data username, by default read from the environment, but
#'   you can set it manually too.
#' @param password ETN Data password, by default read from the environment, but
#'   you can set it manually too.
#' @return A string as it is ingested by other functions that need
#'   authentication
#' @family helper functions
#' @noRd
get_credentials <- function(username = Sys.getenv("userid"),
                            password = Sys.getenv("pwd")) {
  if (Sys.getenv("userid") == "") {
    message("No credentials stored, prompting..")
    Sys.setenv(userid = readline(prompt = "Please enter a userid: "))
    Sys.setenv(pwd = askpass::askpass())
  }
  # glue::glue('list(username = "{username}", password = "{password}")')
  invisible(list(username = username, password = password))
}

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
      # I'm passing an argument to arrow::write_feather() via OpenCPU, this
      # feature is currenlty only documented in the NEWS file. Not in the
      # official documentation of OPENCPU
      'tmp/{temp_key}/R/.val/feather?compression="lz4"',
      .sep = "/"
    ),
    times = 5
  ) %>%
    httr::content(as = "raw")
  # read connection
  api_response <- arrow::read_feather(response_connection)
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


#' Lifecycle warning for the deprecated connection argument
#'
#' @param function_identity Character of length one with the name
#'   of the function the warning is being generated from
#'
#' @family helper functions
#' @noRd
deprecate_warn_connection <- function() {
  lifecycle::deprecate_warn(
    when = "v2.3.0",
    what = glue::glue("{function_identity}(connection)",
      function_identity = get_parent_fn_name(depth = 2)
    ),
    details = glue::glue(
      "The connection argument is no longer used. ",
      "You will be prompted for credentials instead."
    ),
    env = rlang::caller_env(),
    user_env = rlang::caller_env(2),
    always = TRUE
  )
}

#' Get the name (symbol) of the parent function
#'
#' @return A length one Character with the name of the parent function.
#'
#' @family helper functions
#' @noRd
#'
#' @examples
#' child_fn <- function() {
#'   get_parent_fn_name()
#' }
#'
#' parent_fn <- function() {
#'   print(get_parent_fn_name())
#'   print(paste("nested:", child_fn()))
#' }
#'
#' parent_fn()
get_parent_fn_name <- function(depth = 1) {
  rlang::call_name(rlang::frame_call(frame = rlang::caller_env(n = depth)))
}

#' Forward function arguments to API and retreive response
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


#' Conductor Helper: point the way to API or SQL helper
#'
#' Helper that conducts it's parent function to either use a helper to query the
#' api, or a helper to query a local database connection using SQL.
#'
#' @param api Logical, Should the API be used?
#' @param ignored_arguments Character vector of arguments not to pass to the API
#'   or SQL helper
#' @param ... options on how to fetch the response. Forwarded to
#'   `forward_to_api()`
#'
#' @return parsed R object as resulting from the API
#'
#' @family helper functions
#' @noRd
conduct_parent_to_helpers <- function(api,
                                      ignored_arguments = NULL,
                                      ...) {
  # Check arguments
  assertthat::assert_that(assertthat::is.flag(api))
  assertthat::assert_that(is.character(ignored_arguments) |
                            is.null(ignored_arguments))

  # Lock in the name of the parent function
  function_identity <-
    get_parent_fn_name(depth = 2)

  # Get the argument values from the parent function
  arguments_to_pass <-
    return_parent_arguments(depth = 2)[
      !names(return_parent_arguments(depth = 2)) %in% c(
        "api",
        "connection",
        ignored_arguments,
        "function_identity"
      )
    ]

  if (api) {
    out <- do.call(
      forward_to_api,
      list(function_identity = function_identity,
           payload = arguments_to_pass,
           ...)
    )
  } else {
    out <- do.call(glue::glue("{function_identity}_sql"), arguments_to_pass)
  }

  return(out)
}
