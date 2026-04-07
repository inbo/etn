#' Read an ETN example dataset
#'
#' Reads the [ETN dataset 2014_DEMER](https://www.vliz.be/en/imis?dasid=5871&doiid=432).
#'
#' @return Frictionless data package of ETN dataset.
#' @family sample data
#' @export
#' @examples
#' example_dataset()
example_dataset <- function() {
  path <- system.file("extdata", "datapackage.json", package = "etn")
  frictionless::read_package(path)
}
