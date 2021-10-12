#' Download acoustic data package
#'
#' Download all acoustic data related to an **animal project** as a data
#' package that can be deposited in a research data repository. Includes option
#' to filter on scientific names.
#'
#' The data are downloaded as a
#' **[Frictionless Data Package](https://frictionlessdata.io/data-package/)**
#' containing:
#'
#' file | description
#' --- | ---
#' `animals.csv` | Animals related to an `animal_project_code`, optionally filtered on `scientific_name`(s), as returned by `get_animals()`.
#' `tags.csv` | Tags associated with the selected animals, as returned by `get_tags()`.
#' `detections.csv` | Acoustic detections for the selected animals, as returned by `get_acoustic_detections()`.
#' `deployments.csv` | Acoustic deployments for the `acoustic_project_code`(s) found in detections, as returned by `get_acoustic_deployments()`. This allows users to see when receivers were deployed, even if these did not detect the selected animals.
#' `receivers.csv` | Acoustic receivers for the selected deployments, as returned by `get_acoustic_receivers()`.
#' `datapackage.json` | A [Frictionless Table Schema](https://specs.frictionlessdata.io/table-schema/) metadata file describing the fields and relations of the above csv files. This file is copied from [here](https://github.com/inbo/etn/blob/master/inst/assets/datapackage.json) and can be used to validate the data package.
#'
#' The function will report the number of records per csv file, as well as the
#' included scientific names and acoustic projects. Warnings will be raised for:
#'
#' - Animals with multiple tags
#' - Tags associated with multiple animals
#' - Deployments without acoustic project: these deployments will not be listed
#'   in `deployments.csv` and will therefore raise a foreign key validation
#'   error.
#' - Duplicate detections: detections with the duplicate `detection_id`. These
#'   are removed by the function in `detections.csv`.
#'
#' **Important**: The data are downloaded _as is_ from the database, i.e. no
#' quality or consistency checks are performed by this function. We therefore
#' recommend to verify the data before publication. A consistency check can be
#' performed by validation tools of the Frictionless Framework, e.g.
#' `frictionless validate datapackage.json` on the command line using
#' [frictionless-py](https://github.com/frictionlessdata/frictionless-py).
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param animal_project_code Character. Animal project you want to download
#'   data for. Required.
#' @param scientific_name Character (vector). One or more scientific names.
#'   Defaults to no all (all scientific names, include "Sync tag", etc.).
#' @param directory Character. Relative path to local download directory.
#'   Defaults to creating a directory named after animal project code. Existing
#'   files of the same name will be overwritten.
#'
#' @export
#'
#' @importFrom glue glue
#' @importFrom dplyr .data %>% distinct filter group_by mutate n pull select summarize
#' @importFrom readr write_csv
#' @importFrom stringr str_detect str_replace_all
#'
#' @examples
#' \dontrun{
#' # Set default connection variable
#' con <- connect_to_etn()
#'
#' # Download data for the 2012_leopoldkanaal animal project (all scientific names)
#' download_acoustic_dataset(animal_project_code = "2012_leopoldkanaal")
#' #> Downloading data to directory "2012_leopoldkanaal":
#' #> (existing files with the same name will be overwritten)
#' #> * (1/6): downloading animals.csv
#' #> * (2/6): downloading tags.csv
#' #> * (3/6): downloading detections.csv
#' #> * (4/6): downloading deployments.csv
#' #> * (5/6): downloading receivers.csv
#' #> * (6/6): adding datapackage.json as file metadata

#' #> Summary statistics for dataset "2012_leopoldkanaal":
#' #> * number of animals:           104
#' #> * number of tags:              103
#' #> * number of detections:        2215243
#' #> * number of deployments:       1968
#' #> * number of receivers:         454
#' #> * first date of detection:     2012-07-04
#' #> * last date of detection:      2021-09-02
#' #> * included scientific names:   Anguilla anguilla
#' #> * included acoustic projects:  albert, Apelafico, bpns, JJ_Belwind, leopold, MOBEIA, pc4c, SPAWNSEIS, ws2, zeeschelde

#' #> Warning message:
#' #> In download_acoustic_dataset(animal_project_code = "2012_leopoldkanaal") :
#' #> Found tags associated with multiple animals: 1145373
#' }
download_acoustic_dataset <- function(connection = con,
                                      animal_project_code,
                                      scientific_name = NULL,
                                      directory = animal_project_code) {
  # Check connection
  check_connection(connection)

  # Check animal_project_code
  if (missing(animal_project_code) || is.null(animal_project_code)) {
    stop("Please provide an animal_project_code")
  } else {
    valid_animal_project_codes <- tolower(list_animal_project_codes(connection))
    check_value(animal_project_code, valid_animal_project_codes, "animal_project_code")
  }

  # Check scientific_name
  if (!is.null(scientific_name)) {
    valid_scientific_names <- list_scientific_names(connection)
    check_value(scientific_name, valid_scientific_names, "scientific_name")
  }

  # Check directory
  dir.create(directory, recursive = TRUE, showWarnings = FALSE)

  # Start downloading
  message(glue(
    "Downloading data to directory \"{directory}\":
    (existing files with the same name will be overwritten)"
  ))

  # ANIMALS
  message("* (1/6): downloading animals.csv")
  # Select on animal_project_code and scientific_name
  animals <- get_animals(
    connection = connection,
    animal_project_code = animal_project_code,
    scientific_name = scientific_name
  )
  write_csv(animals, paste(directory, "animals.csv", sep = "/"), na = "")

  # TAGS
  message("* (2/6): downloading tags.csv")
  # Select on tags associated with animals
  tag_serial_numbers <-
    animals %>%
    distinct(.data$tag_serial_number) %>%
    pull() %>%
    # To parse out multiple tags (e.g. "A69-9006-904,A69-9006-903"), combine
    # all tags and split them again on comma
    paste(collapse = ",") %>%
    strsplit("\\,") %>%
    unlist() %>%
    unique()
  tags <- get_tags(
    connection = connection,
    tag_serial_number = tag_serial_numbers
  )
  write_csv(tags, paste(directory, "tags.csv", sep = "/"), na = "")

  # DETECTIONS
  message("* (3/6): downloading detections.csv")
  # Select on animal_project_code and scientific_name
  detections <- get_acoustic_detections(
    connection = connection,
    animal_project_code = animal_project_code,
    scientific_name = scientific_name,
    limit = FALSE
  )
  # Keep unique records
  detections_orig_count <- nrow(detections)
  detections <-
    detections %>%
    distinct(.data$detection_id, .keep_all = TRUE)
  write_csv(detections, paste(directory, "detections.csv", sep = "/"), na = "")

  # DEPLOYMENTS
  message("* (4/6): downloading deployments.csv")
  # Select on acoustic_project_codes found in detections to get all deployments,
  # including those without detections for animal_project_code
  acoustic_project_codes <-
    detections %>%
    distinct(.data$acoustic_project_code) %>%
    pull() %>%
    sort()
  deployments <- get_acoustic_deployments(
    connection = connection,
    acoustic_project_code = acoustic_project_codes,
    open_only = FALSE
  )
  # Remove linebreaks in deployment comments to get single lines in csv:
  deployments <-
    deployments %>%
    mutate(comments = str_replace_all(.data$comments, "[\r\n]+", " "))
  write_csv(deployments, paste(directory, "deployments.csv", sep = "/"), na = "")

  # RECEIVERS
  message("* (5/6): downloading receivers.csv")
  # Select on receivers associated with deployments
  receiver_ids <-
    deployments %>%
    distinct(.data$receiver_id) %>%
    pull()
  receivers <- get_acoustic_receivers(
    connection = connection,
    receiver_id = receiver_ids
  )
  write_csv(receivers, paste(directory, "receivers.csv", sep = "/"), na = "")

  # DATAPACKAGE.JSON
  message("* (6/6): adding datapackage.json as file metadata")
  datapackage <- system.file("assets", "datapackage.json", package = "etn")
  file.copy(datapackage, paste(directory, "datapackage.json", sep = "/"), overwrite = TRUE)

  # Create summary stats
  scientific_names <-
    animals %>%
    distinct(.data$scientific_name) %>%
    pull() %>%
    sort()

  message("")
  message(glue("\nSummary statistics for dataset \"{animal_project_code}\":"))
  message("* number of animals:           ", nrow(animals))
  message("* number of tags:              ", nrow(tags))
  message("* number of detections:        ", nrow(detections))
  message("* number of deployments:       ", nrow(deployments))
  message("* number of receivers:         ", nrow(receivers))
  if (nrow(detections) > 0) {
    message("* first date of detection:     ", detections %>% summarize(min(as.Date(.data$date_time))) %>% pull())
    message("* last date of detection:      ", detections %>% summarize(max(as.Date(.data$date_time))) %>% pull())
  } else {
    message("* first date of detection:     ", NA)
    message("* last date of detection:      ", NA)
  }
  message("* included scientific names:   ", paste(scientific_names, collapse = ", "))
  message("* included acoustic projects:  ", paste(acoustic_project_codes, collapse = ", "))
  message("")

  # Create warnings
  animals_multiple_tags <-
    animals %>%
    filter(str_detect(.data$tag_serial_number, ",")) %>%
    distinct(.data$animal_id) %>% # Should be unique already
    pull()

  tags_multiple_animals <-
    animals %>%
    group_by(.data$tag_serial_number) %>%
    filter(n() > 1) %>%
    distinct(.data$tag_serial_number) %>%
    pull()

  orphaned_deployments <-
    detections %>%
    filter(.data$acoustic_project_code %in% c("no_info", "none")) %>%
    distinct(.data$deployment_id) %>%
    pull()

  duplicate_detections_count <- detections_orig_count - nrow(detections)

  if (length(animals_multiple_tags) > 0) {
    warning("Found animals with multiple tags: ", paste(animals_multiple_tags, collapse = ", "))
  }
  if (length(tags_multiple_animals) > 0) {
    warning("Found tags associated with multiple animals: ", paste(tags_multiple_animals, collapse = ", "))
  }
  if (length(orphaned_deployments) > 0) {
    warning("Found deployments without acoustic project: ", paste(orphaned_deployments, collapse = ", "))
  }
  if (duplicate_detections_count > 0) {
    warning("Found and removed duplicate detections: ", duplicate_detections_count, " detections")
  }
}
