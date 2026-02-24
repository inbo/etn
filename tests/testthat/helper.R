# HELPER FUNCTIONS FOR TESTTHAT TESTS

#' Do functions in ETN return the same value over the API as with a query to a
#' local database connection?
#'
#' This function tests if the provided expression returns identical regardless
#' of the returned value of the internal helper `select_protocol()`. In other
#' words, regardless of the way the data is received, data from a single source
#' should be returned in exactly the same way.
#'
#' To test this this expectation makes use of testthat's `expect_identical()`
#' and `with_mocked_bindings()` to temporarily override the return value of
#' `select_protocol()` to simulate both API and local database calls. This
#' expectation is useful to ensure that functions in ETN behave consistently
#' regardless of the data source. It is particularly important for functions
#' that can retrieve data from both an online API and a local database, as it
#' helps to verify that the data handling and processing logic is robust and
#' reliable across different data retrieval methods. This expectation will be
#' skipped if the machine is offline or if the ETN database is not available.
#'
#'
#' @param expression The expression to be tested.
#' @inherits testthat::expect_identical return
#'
#' @examples
#' expect_protocol_agnostic(list_acoustic_projects())
#' expect_protocol_agnostic(list_animal_projects())
#'
#' @export
expect_protocol_agnostic <- function(expression) {
  # Skip if no credentials are stored
  skip_if_no_authentication()

  # Skip if not both the API and the local database are available to compare
  testthat::skip_if_offline(host = "opencpu.lifewatch.be")
  testthat::skip_if_not(
    localdb_is_available(),
    "ETN is not a local database on this machine"
  )

  # Test if the provided expression returns identical results regardless of
  # the return value of select_protocol()

  testthat::expect_identical(
    testthat::with_mocked_bindings(
      code = rlang::eval_tidy(rlang::enquo(expression)),
      # Object, is a call to opencpu
      select_protocol = function(...) {
        "opencpu"
      }
    ),
    testthat::with_mocked_bindings(
      code = rlang::eval_tidy(rlang::enquo(expression)),
      # Expectation is a call to the local database
      select_protocol = function(...) {
        "localdb"
      }
    ),
    label = "api",
    expected.label = "sql"
  )
}

#' Get schema fields for a resource in a Frictionless Data Package.
#'
#' This function returns the `fields` attribute from a Table Schema of a
#' specific resource in a Frictionless Data Package.
#' These can be compared with the headers in the provided data.
#'
#' @param datapackage List describing a Data Package as returned by
#'   [frictionless::read_package()].
#' @param table_name Name of the Data Resource to retrieve the fields from.
#'
#' @return List containing the schema fields of the requested resource.
#' @family helper functions
#' @noRd
fetch_schema_fields <- function(datapackage = datapackage, table_name) {
  datapackage[["resources"]][[
    match(
      table_name,
      sapply(
        datapackage[["resources"]],
        function(x) x[["name"]]
      )
    )
  ]][[
    "schema"
  ]][["fields"]]
}

#' Skip the test if ETN is not a local database on this machine.
#'
#' This function is useful to skip tests that require a local database
#' connection. The skip doesn't actually check for the database, but uses a
#' helper to check if the system nodename ends with a known suffix for VLIZ
#' machines. This should always cover the RStudio Server.
#'
#' @family helper functions
#' @noRd
skip_if_not_localdb <- function() {
  testthat::skip_if_not(
    localdb_is_available(),
    "ETN is not a local database on this machine"
  )
}

skip_if_http_error <- function(url) {
  url_resp <- httr2::request(url) |>
    # If the url returns an error, do not convert into R error.
    httr2::req_error(is_error = \(response) {
      FALSE
    }) |>
    httr2::req_perform()

  testthat::skip_if(
    httr2::resp_is_error(url_resp),
    glue::glue(
      "{url} returned http error: {http_error}",
      http_error = httr2::resp_status(url_resp)
    )
  )
}

#' Skip the test if authentication credentials are not set.
#'
#' @family helper functions
#' @noRd
skip_if_no_authentication <- function() {
  testthat::skip_if_not(
    credentials_are_set(),
    message =
      "No credentials are stored"
  )
}


#' Get an HTTP response for a specific HTTP status code.
#'
#' This function is useful to test other functions that respond to a specific
#' HTTP status code. For example to convert a certain HTTP error into a helpful
#' message.
#'
#' @param http_code An integer representing the HTTP status code to retrieve.
#'   Defaults to 200.
#'
#' @return An `httr2` response object containing the HTTP response for the
#'   specified status code.
#' @family helper functions
#' @noRd
#' @examples
#' get_http_response(404) |> httr2::resp_status_desc()
get_http_response <- function(http_code = 200) {
  httr2::request("http://httpbingo.org") |>
    httr2::req_url_path_append("status", http_code) |>
    httr2::req_error(is_error = function(resp) {
      FALSE
    }) |>
    httr2::req_perform()
}
