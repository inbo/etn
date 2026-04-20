#' Read an example dataset
#'
#' Reads an example dataset, formatted as a [Frictionless Data Package](
#' https://specs.frictionlessdata.io/data-package/).
#'
#' @section 2014_DEMER:
#'
#' `2014_DEMER` is a **river acoustic telemetry** dataset. It contains 66 tagged
#' animals across four species. Over 235,000 detections were observed between
#' 2014 and 2019 by acoustic receivers deployed in Belgian rivers.
#'
#' Data are deposited at <https://doi.org/10.14284/432> and can be downloaded
#' from the ETN database with
#' `download_acoustic_dataset(animal_project_code = "2014_DEMER")`.
#'
#' @param dataset Name of the example dataset to load. Defaults to the only
#' available dataset: `"2014_DEMER"`.
#' @return Frictionless data package.
#' @family sample data
#' @export
#' @examples
#' example_dataset()
example_dataset <- function(dataset = "2014_DEMER") {
  available_datasets <- c("2014_DEMER")
  if (!dataset %in% available_datasets) {
    cli::cli_abort(
      c(
        "{.val {dataset}} is not an available example dataset.",
        "i" = "Available dataset{?s}: {.val {available_datasets}}."
      ),
      class = "etn_error_example_dataset_not_available"
      )
  } else {
    path <- system.file(
      "extdata", dataset, "datapackage.json",
      package = "etn"
    )
    package <- frictionless::read_package(path)
    package$profile <- NULL
    return(package)
  }
}
