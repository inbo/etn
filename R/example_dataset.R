#' Read an example dataset
#'
#' An example ETN dataset, formatted as a [Frictionless Data Package](
#' https://specs.frictionlessdata.io/data-package/) and read by
#' [frictionless::read_package()].
#'
#' ["2014_DEMER"](https://www.vliz.be/en/imis?dasid=5871&doiid=432) is a dataset
#' of acoustic river telemetry data collected for four fish species in the Demer
#' River, Belgium, in 2014. The example dataset is included in the ETN R
#' package, but can also be downloaded from the ETN database using the following
#' code:
#'
#' `download_acoustic_dataset(
#' animal_project_code = "2014_DEMER",
#' directory = here::here("inst", "extdata", "2014_DEMER"))
#' )`
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
        "Available example datasets are: {.val {available_datasets}}.",
        "i" = "{.val {dataset}} is not an available example dataset."
      ),
      class = "etn_error_example_dataset_not_available"
      )
  } else {
    path <- system.file(
      "extdata", dataset, "datapackage.json",
      package = "etn"
    )
    frictionless::read_package(path)
  }
}
