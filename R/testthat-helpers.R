# HELPER FUNCTIONS FOR TESTTHAT TESTS

#' Return the schema fields from frictionless data packages
#'
#' This helper returns the schema fields from a provided frictionless data package,
#' this can be useful to compare the order of fields within a schema or the
#' completeness of or against a datapackage.json file
#'
#' @param datapackage List describing a Data Package as returned by \code{frictionless::read_package()}
#' @param table_name Name of the Data Resource to retreive the fields from
#'
#' @return List containing just the schema fields of the requested resource
#' @family helper functions
#' @noRd
#'
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
