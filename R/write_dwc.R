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
#' @param rights_holder Acronym of the organization owning or managing the
#'   rights over the data.
#' @param license Identifier of the license under which the data will be
#'   published.
#'   - [`CC-BY`](https://creativecommons.org/licenses/by/4.0/legalcode)
#'   (default).
#'   - [`CC0`](https://creativecommons.org/publicdomain/zero/1.0/legalcode).
#' @return CSV file(s) written to disk.
#' @export
write_dwc <- function(connection = con,
                      animal_project_code,
                      directory = ".",
                      rights_holder = NULL,
                      license = "CC-BY") {
  # Check connection
  check_connection(connection)

  # Check animal_project_code
  assertthat::assert_that(
    length(animal_project_code) == 1,
    msg = "`animal_project_code` must be a single value."
  )

  # Check license
  licenses <- c("CC-BY", "CC0")
  assertthat::assert_that(
    license %in% licenses,
    msg = glue::glue(
      "`license` must be {licenses}.",
      licenses = glue::glue_collapse(licenses, sep = ", ", last = " or ")
    )
  )
  license <- switch(
    license,
    "CC-BY" = "https://creativecommons.org/licenses/by/4.0/legalcode",
    "CC0" = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
  )

  # Get imis_dataset_id and project_id from animal_project
  project <- get_animal_projects(connection, animal_project_code)
  project_id <- project$project_id
  dataset_id <- paste0("https://www.vliz.be/en/imis?module=dataset&dasid=", project$imis_dataset_id)

  # Get human observations (capture, release, ...)
  dwc_occurrence_human_sql <- glue::glue_sql(
    readr::read_file(system.file("sql/dwc_occurrence_human.sql", package = "etn")),
    .con = connection
  )
  dwc_occurrence_human <- DBI::dbGetQuery(connection, dwc_occurrence_human_sql)

  # Get machine observations (sampled down detections)
  # dwc_occurrence_machine_sql <- glue::glue_sql(
  #   readr::read_file(system.file("sql/dwc_occurrence_machine.sql", package = "etn")),
  #   .con = connection
  # )
  # dwc_occurrence_machine <- DBI::dbGetQuery(connection, dwc_occurrence_machine_sql)

  # Create directory
  dir.create(directory, recursive = TRUE, showWarnings = FALSE)

  # Write files
  readr::write_csv(
    dwc_occurrence_human,
    file.path(directory, "dwc_occurrence_human.csv"),
    na = ""
  )
}
