#' Download data package
#'
#' Download all data related to an **animal project** as a data package that can
#' be deposited in a research data repository. Includes option to filter on
#' scientific names.
#'
#' The data are downloaded as a
#' **[Frictionless Data Package](https://frictionlessdata.io/data-package/)**
#' containing:
#'
#' file | description
#' --- | ---
#' `animals.csv` | Animals related to an `animal_project_code`, optionally filtered on `scientific_name`(s), as returned by `get_animals()`.
#' `tags.csv` | Tags associated with the selected animals, as returned by `get_tags()`.
#' `detections.csv` | Detections for the selected animals, as returned by `get_detections()`.
#' `deployments.csv` | Deployments for the `network_project_code`(s) found in detections, as returned by `get_deployments()`. This allows users to see when receivers were deployed, even if these did not detect the selected animals.
#' `receivers.csv` | Receivers for the selected deployments, as returned by `get_receivers()`.
#' `datapackage.json` | A [Frictionless Table Schema](https://specs.frictionlessdata.io/table-schema/) metadata file describing the fields and relations of the above csv files. This file is copied from [here](https://github.com/inbo/etn/blob/master/inst/assets/datapackage.json) and can be used to validate the data package.
#'
#' The function will report the number of records per csv file, as well as the
#' included scientific names and network projects. Warnings will be raised for:
#'
#' - Animals with multiple tags
#' - Tags associated with multiple animals
#' - Deployments without network project: these deployments will not be listed
#'   in `deployments.csv` and will therefore raise a foreign key validation
#'   error.
#' - Duplicate detections: detections with the duplicate `pk`. These are
#'   removed by the function in `detections.csv`.
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
#'   Defaults to no filter (i.e. include all scientific names, including
#'   reference tags).
#' @param directory Character. Relative path to local download directory.
#'   Defaults to creating a directory named after animal project code. Existing
#'   files of the same name will be overwritten.
#'
#' @export
#'
#' @importFrom glue glue
#' @importFrom dplyr %>% arrange distinct filter group_by mutate n pull select
#' @importFrom readr write_csv
#' @importFrom stringr str_detect str_replace_all
#'
#' @examples
#' \dontrun{
#' # Download data for the 2014_demer animal project (all scientific names)
#' download_dataset(con, animal_project_code = "2014_demer")
#' #> Downloading data to directory "2014_demer":
#' #> (existing files with the same name will be overwritten)
#' #> * (1/6): downloading animals.csv
#' #> * (2/6): downloading tags.csv
#' #> * (3/6): downloading detections.csv
#' #> * (4/6): downloading deployments.csv
#' #> * (5/6): downloading receivers.csv
#' #> * (6/6): adding datapackage.json as file metadata
#' #>
#' #> Summary statistics for dataset "2014_demer":
#' #> * number of animals:           16
#' #> * number of tags:              16
#' #> * number of detections:        237064
#' #> * number of deployments:       939
#' #> * number of receivers:         179
#' #> * first date of detection:     2014-04-18
#' #> * last date of detection:      2018-09-15
#' #> * included scientific names:   Petromyzon marinus, Rutilus rutilus, Silurus glanis, Squalius cephalus
#' #> * included network projects:   albert, demer, dijle, no_info, zeeschelde
#' #>
#' #> Warning message:
#' #> In download_dataset(animal_project_code = "2014_demer") :
#' #>   Found deployments without network project: 1383, 1382, 1384
#' }
download_dataset <- function(connection = con,
                             animal_project_code,
                             scientific_name = NULL,
                             directory = animal_project_code) {
  # Check connection
  check_connection(connection)

  # Check animal_project_code
  if (missing(animal_project_code) || is.null(animal_project_code)) {
    stop("Please provide an animal_project_code")
  } else {
    valid_animal_project_codes <- list_animal_project_codes(connection)
    check_value(animal_project_code, valid_animal_project_codes, "animal_project_code")
  }

  # Check scientific_name
  if (!is.null(scientific_name)) {
    scientific_name_ids <- list_scientific_names(connection)
    check_value(scientific_name, scientific_name_ids, "scientific_name")
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
    connection = con,
    animal_project_code = animal_project_code,
    scientific_name = scientific_name
  )
  write_csv(animals, paste(directory, "animals.csv", sep = "/"), na = "")

  # TAGS
  message("* (2/6): downloading tags.csv")
  # Select on tags associated with animals
  tag_ids <-
    animals %>%
    distinct(tag_id) %>%
    pull()
  tags <- get_tags(
    connection = con,
    tag_id = tag_ids,
    include_ref_tags = TRUE # TODO: should this be the default?
  )
  write_csv(tags, paste(directory, "tags.csv", sep = "/"), na = "")

  # DETECTIONS
  message("* (3/6): downloading detections.csv")
  # Select on animal_project_code and scientific_name
  detections <- get_detections(
    connection = con,
    animal_project_code = animal_project_code,
    scientific_name = scientific_name,
    limit = FALSE
  )
  # Keep unique records
  detections_orig_count <- nrow(detections)
  detections <-
    detections %>%
    distinct(pk, .keep_all = TRUE)
  write_csv(detections, paste(directory, "detections.csv", sep = "/"), na = "")

  # DEPLOYMENTS
  message("* (4/6): downloading deployments.csv")
  # Select on network_project_codes found in detections to get all deployments,
  # including those without detections for animal_project_code
  network_project_codes <-
    detections %>%
    distinct(network_project_code) %>%
    arrange(network_project_code) %>%
    pull()
  deployments <- get_deployments(
    connection = con,
    network_project_code = network_project_codes,
    open_only = FALSE
  )
  # Remove linebreaks in deployment comments to get single lines in csv:
  deployments <-
    deployments %>%
    mutate(comments = str_replace_all(comments, "[\r\n]+", " "))
  write_csv(deployments, paste(directory, "deployments.csv", sep = "/"), na = "")

  # RECEIVERS
  message("* (5/6): downloading receivers.csv")
  # Select on receivers associated with deployments
  receiver_ids <-
    deployments %>%
    distinct(receiver_id) %>%
    pull()
  receivers <- get_receivers(
    con,
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
    distinct(scientific_name) %>%
    arrange(scientific_name) %>%
    pull()

  message("")
  message(glue("\nSummary statistics for dataset \"{animal_project_code}\":"))
  message("* number of animals:           ", nrow(animals))
  message("* number of tags:              ", nrow(tags))
  message("* number of detections:        ", nrow(detections))
  message("* number of deployments:       ", nrow(deployments))
  message("* number of receivers:         ", nrow(receivers))
  message("* first date of detection:     ", detections %>% summarize(min(as.Date(date_time))) %>% pull())
  message("* last date of detection:      ", detections %>% summarize(max(as.Date(date_time))) %>% pull())
  message("* included scientific names:   ", paste(scientific_names, collapse = ", "))
  message("* included network projects:   ", paste(network_project_codes, collapse = ", "))
  message("")

  # Create warnings
  animals_multiple_tags <-
    animals %>%
    filter(str_detect(tag_id, ",")) %>%
    distinct(animal_id) %>% # Should be unique already
    pull()

  tags_multiple_animals <-
    animals %>%
    group_by(tag_id) %>%
    filter(n() > 1) %>%
    distinct(tag_id) %>%
    pull()

  orphaned_deployments <-
    detections %>%
    filter(network_project_code %in% c("no_info", "none")) %>%
    distinct(deployment_fk) %>%
    pull()

  duplicate_detections_count <- detections_orig_count - nrow(detections)

  if (length(animals_multiple_tags) > 0) {
    warning("Found animals with multiple tags: ", paste(animals_multiple_tags, collapse = ", "))
  }
  if (length(tags_multiple_animals) > 0) {
    warning("Found tags associated with multiple animals: ", paste(tags_multiple_animals, collapse = ", "))
  }
  if (length(orphaned_deployments) > 0) {
    warning("Found deployments without network project: ", paste(orphaned_deployments, collapse = ", "))
  }
  if (duplicate_detections_count > 0) {
    warning("Found and removed duplicate detections found: ", duplicate_detections_count, " detections")
  }
}
