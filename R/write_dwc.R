#' Transform ETN data to Darwin Core
#'
#' Transforms and downloads data from a European Tracking Network
#' **animal project** to [Darwin Core](https://dwc.tdwg.org/).
#' The resulting CSV file(s) can be uploaded to an [IPT](
#' https://www.gbif.org/ipt) for publication to OBIS and/or GBIF.
#' A `meta.xml` or `eml.xml` file are not created.
#'
#' @param connection Connection to the ETN database.
#' @param animal_project_code Animal project code.
#' @param directory Path to local directory to write file(s) to.
#'   If `NULL`, then a list of data frames is returned instead, which can be
#'   useful for extending/adapting the Darwin Core mapping before writing with
#'   [readr::write_csv()].
#' @param rights_holder Acronym of the organization owning or managing the
#'   rights over the data.
#' @param license Identifier of the license under which the data will be
#'   published.
#'   - [`CC-BY`](https://creativecommons.org/licenses/by/4.0/legalcode) (default).
#'   - [`CC0`](https://creativecommons.org/publicdomain/zero/1.0/legalcode).
#' @return CSV file(s) written to disk.
#' @export
#' @section Transformation details:
#' Data are transformed into an
#' [Occurrence core](https://rs.gbif.org/core/dwc_occurrence_2022-02-02.xml).
#' This **follows recommendations** discussed and created by Peter Desmet,
#' Jonas Mortelmans, Jonathan Pye, John Wieczorek and others.
#' See the [SQL file(s)](https://github.com/inbo/etn/tree/main/inst/sql)
#' used by this function for details.
#'
#' Key features of the Darwin Core transformation:
#' - Deployments (animal+tag associations) are parent events, with capture,
#'   surgery, release, recapture (human observations) and acoustic detections
#'   (machine observations) as child events.
#'   No information about the parent event is provided other than its ID,
#'   meaning that data can be expressed in an Occurrence Core with one row per
#'   observation and `parentEventID` shared by all occurrences in a deployment.
#' - The release event often contains metadata about the animal (sex,
#'   lifestage, comments) and deployment as a whole.
#' - Acoustic detections are downsampled to the **first detection per hour**,
#'   to reduce the size of high-frequency data.
#'   Duplicate detections (same animal, tag and timestamp) are excluded.
#'   It is possible for a deployment to contain no detections, e.g. if the
#'   tag malfunctioned right after deployment.
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
      "`license` must be `{licenses}`.",
      licenses = glue::glue_collapse(licenses, sep = "`, `", last = "` or `")
    )
  )
  license <- switch(
    license,
    "CC-BY" = "https://creativecommons.org/licenses/by/4.0/legalcode",
    "CC0" = "https://creativecommons.org/publicdomain/zero/1.0/legalcode"
  )

  # Get imis dataset id and title
  project <- get_animal_projects(connection, animal_project_code)
  imis_dataset_id <- project$imis_dataset_id
  imis_url <- "https://www.vliz.be/en/imis?module=dataset&dasid="
  imis_json <- jsonlite::read_json(paste0(imis_url, imis_dataset_id, "&show=json"))
  dataset_id <- paste0(imis_url, imis_dataset_id)
  dataset_name <- imis_json$datasetrec$StandardTitle

  # Query database
  message("Reading data and transforming to Darwin Core.")
  dwc_occurrence_sql <- glue::glue_sql(
    readr::read_file(system.file("sql/dwc_occurrence.sql", package = "etn")),
    .con = connection
  )
  dwc_occurrence <- DBI::dbGetQuery(connection, dwc_occurrence_sql)

  # Return object or write files
  if (is.null(directory)) {
    list(
      dwc_occurrence = dplyr::as_tibble(dwc_occurrence)
    )
  } else {
    dwc_occurrence_path <- file.path(directory, "dwc_occurrence.csv")
    message(glue::glue(
      "Writing data to:",
      dwc_occurrence_path,
      .sep = "\n"
    ))
    if (!dir.exists(directory)) {
      dir.create(directory, recursive = TRUE)
    }
    readr::write_csv(dwc_occurrence, dwc_occurrence_path, na = "")
  }
}
