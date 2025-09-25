# HELPER FUNCTIONS FOR TESTTHAT TESTS

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
#' This function checks if the "ETN" database is present in the list of ODBC
#' data sources on the local machine. If it is not found, the test is skipped
#' with a corresponding message.
#'
#' @family helper functions
#' @noRd
skip_if_not_localdb <- function(){
  skip_if_not(localdb_is_available(),
              "ETN is not a local database on this machine")
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
#' get_http_response(404) %>% httr2::resp_status_desc()
get_http_response <- function(http_code = 200) {
  httr2::request("http://httpbingo.org") %>%
    httr2::req_url_path_append("status", http_code) %>%
    httr2::req_error(is_error = function(resp){FALSE}) %>%
    httr2::req_perform()
}
