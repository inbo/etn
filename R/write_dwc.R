#' Transform ETN data to Darwin Core
#'
#' Transforms data from the European Tracking Network (ETN) to
#' [Darwin Core](https://dwc.tdwg.org/). The resulting CSV and meta.xml file
#' can be uploaded to an [IPT](https://www.gbif.org/ipt) for publication to
#' OBIS and/or GBIF.
#' An `eml.xml` file is not created.
#'
#' @param package A Frictionless Data Package of ETN data, as returned by
#'   [frictionless::read_package()].
#'   It is expected to contain an `animals`, `detections` and `tags` resource.
#' @param directory Path to local directory to write files to.
#'   If `NULL`, then a list of data frames is returned instead, which can be
#'   useful for extending/adapting the Darwin Core mapping before writing with
#'   [readr::write_csv()].
#' @param dataset_id Identifier for the dataset.
#' @param dataset_name Title of the dataset.
#' @param institution_code Acronym of the institution publishing the data.
#' @param license Identifier of the license under which the data will be
#'   published.
#'   - [`CC-BY`](https://creativecommons.org/licenses/by/4.0/legalcode)
#'   (default).
#'   - [`CC0`](https://creativecommons.org/publicdomain/zero/1.0/legalcode).
#' @param rights_holder Acronym of the organization owning or managing the
#'   rights over the data.
#' @return CSV and `meta.xml` files written to disk.
#'   And invisibly, a list of data frames with the transformed data.
#' @export
#' @section Transformation details:
#' Data are transformed into an
#' [Occurrence core](https://rs.gbif.org/core/dwc_occurrence_2022-02-02.xml).
#' This **follows recommendations** discussed and created by Peter Desmet,
#' Jonas Mortelmans, Jonathan Pye, John Wieczorek and others.
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
#'   tag malfunctioned right after deployment.#'
#' @examples
#` #package <- river_telemetry
#` #write_dwc(
#` #  package,
#` #  directory = "my_directory",
#` #  dataset_id = "https://www.vliz.be/en/imis?module=dataset&dasid=5871",
#` #  dataset_name = paste("2014_DEMER - Acoustic telemetry data for four fish",
#` #  "species in the Demer river (Belgium)"),
#` #  institution_code = "VLIZ",
#` #  license = "CC0",
#` #  rights_holder = "INBO"
#` #)
#'
#' # Clean up (don't do this if you want to keep your files)
#' unlink("my_directory", recursive = TRUE)
write_dwc <- function(package, directory, dataset_id = NULL,
                      dataset_name = NULL, institution_code = NULL,
                      license = "CC-BY", rights_holder = NULL) {

  # Check license
  licenses <- c("CC-BY", "CC0")
  if (is.null(license)) {
    cli::cli_abort(
      "{.arg licence} must be one of {.val licenses}.",
      class = "etn_error_license_missing"
    )
  }
  if (!license %in% licenses) {
    cli::cli_abort(
      "{.arg licence} must be one of {.val licenses}.",
      class = "etn_error_license_missing"
    )
  }

  license <- switch(
    license,
    "CC-BY" = "https://creativecommons.org/licenses/by/4.0/legalcode",
    "CC0" = "https://creativecommons.org/publicdomain/zero/1.0/legalcode"
  )

  # Check input parameters
  if (is.null(dataset_id)) {
    dataset_id <- NA_character_
  }
  if (is.null(dataset_name)) {
    dataset_name <- NA_character_
  }
  if (is.null(rights_holder)) {
    rights_holder <- NA_character_
  }
  if (is.null(institution_code)) {
    institution_code <- NA_character_
  }

  # Read data from package
  cli::cli_h2("Reading data")
  if (!"animals" %in% frictionless::resources(package)) {
    cli::cli_abort(
      "{.arg package} must contain resource {.val animals}.",
      class = "etn_error_animals_data_missing"
    )
  }
  animals <-
    frictionless::read_resource(package, "animals")

  if (!"tags" %in% frictionless::resources(package)) {
    cli::cli_abort(
      "{.arg package} must contain resource {.val tags}.",
      class = "etn_error_tags_data_missing"
    )
  }
  tags <-
    frictionless::read_resource(package, "tags")

  if (!"detections" %in% frictionless::resources(package)) {
    cli::cli_abort(
      "{.arg package} must contain resource {.val detections}.",
      class = "etn_error_detections_data_missing"
    )
  }
  detections <-
    frictionless::read_resource(package, "detections")

  if (!"deployments" %in% frictionless::resources(package)) {
    cli::cli_abort(
      "{.arg package} must contain resource {.val deployemts}.",
      class = "etn_error_deployments_data_missing"
    )
  }
  deployments <-
    frictionless::read_resource(package, "deployments")

  # Start transformation
  cli::cli_h2("Transforming data to Darwin Core")
  animals_occurrence <- create_animals_occurrence(animals, tags)
  detections_occurrence <-
    create_detections_occurrence(detections, animals, deployments)

  # Bind the occurrence df from the helper functions
  occurrence <-
    animals_occurrence |>
    dplyr::bind_rows(detections_occurrence) |>
    dplyr::mutate(
      # DATASET-LEVEL
      type = "Event",
      license = license,
      rightsHolder = rights_holder,
      datasetID = dataset_id,
      institutionCode = institution_code,
      collectionCode = "ETN",
      datasetName = dataset_name,
      # RECORD-LEVEL
      .before = "basisOfRecord"
    ) |>
    dplyr::arrange(.data$parentEventID, .data$eventDate)

  # Write files
  occurrence_path <- file.path(directory, "occurrence.csv")
  meta_xml_path <- file.path(directory, "meta.xml")
  cli::cli_h2("Writing files")
  cli::cli_ul(c(
    "{.file {occurrence_path}}",
    "{.file {meta_xml_path}}"
  ))
  if (!dir.exists(directory)) {
    dir.create(directory, recursive = TRUE)
  }
  readr::write_csv(occurrence, occurrence_path, na = "")
  file.copy(
    system.file("extdata", "meta.xml", package = "etn"), # Static meta.xml
    meta_xml_path
  )

  # Return list with Darwin Core data invisibly
  return <- list(
    occurrence = dplyr::as_tibble(occurrence)
  )
  invisible(return)
}
