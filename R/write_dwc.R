#' Transform ETN data to Darwin Core
#'
#' Transforms and downloads data from a European Tracking Network
#' **animal project** to [Darwin Core](https://dwc.tdwg.org/).
#' The resulting CSV file(s) can be uploaded to a
#' [GBIF IPT](https://www.gbif.org/ipt) for publication to OBIS or GBIF.
#' A `meta.xml` or `eml.xml` file are not created.
#'
#' @param connection Connection to the ETN database.
#' @param animal_project_code Animal project code.
#' @param directory Path to local directory to write file(s) to.
#'   Existing files of the same name will be overwritten.
#' @return CSV file(s) written to disk.
#' @export
write_dwc <- function(connection = con,
                      animal_project_code,
                      directory = animal_project_code) {
  message("functionality here")
}
