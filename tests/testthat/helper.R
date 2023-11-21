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
