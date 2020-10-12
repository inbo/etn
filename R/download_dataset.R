#' Download data for publication
#'
#' ...
#'
#' @param connection A valid connection to the ETN database.
#' @param animal_project_code (string) Animal project to download data from.
#' @param directory (string) Path to local download directory.
#' @param scientific_name (string) One or more scientific names to filter on.
#'
#' @return ...
#'
#' @export
#'
#' @importFrom glue glue
#' @importFrom dplyr %>% arrange distinct filter group_by mutate pull select tibble
#'
#' @examples
#' \dontrun{
#' ...
#' }
download_dataset <- function(connection = con,
                        animal_project_code = NULL,
                        directory = animal_project_code,
                        scientific_name = NULL) {
  # Check connection
  check_connection(connection)

  # Check animal_project_code
  if (is.null(animal_project_code)) {
    stop("Please provide an animal_project_code")
  } else {
    valid_animal_project_codes <- list_animal_project_codes(connection)
    check_value(animal_project_code, valid_animal_project_codes, "animal_project_code")
  }

  # Check directory
  if (!dir.exists(directory)) {
    dir.create(directory)
  }

  # Check scientific_name
  if (!is.null(scientific_name)) {
    scientific_name_ids <- list_scientific_names(connection)
    check_value(scientific_name, scientific_name_ids, "scientific_name")
  }

  # Start downloading
  message(glue("Downloading data to directory \"{directory}\":"))

  # ANIMALS
  message("* (1/6): downloading animals.csv")
  # Select on animal_project_code and scientific_name
  animals <- get_animals(
    connection = con,
    animal_project_code = animal_project_code,
    scientific_name = scientific_name
  )
  write_csv(animals, paste(directory, "animals.csv", sep="/"), na = "")

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
  write_csv(tags, paste(directory, "tags.csv", sep="/"), na = "")

  # DETECTIONS
  message("* (3/6): downloading detections.csv")
  # Select on animal_project_code and scientific_name
  detections <- get_detections(
    connection = con,
    animal_project_code = animal_project_code,
    scientific_name = scientific_name,
    limit = FALSE
  )
  write_csv(detections, paste(directory, "detections.csv", sep="/"), na = "")

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
  write_csv(deployments, paste(directory, "deployments.csv", sep="/"), na = "")

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
  write_csv(receivers, paste(directory, "receivers.csv", sep="/"), na = "")

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
    filter(network_project_code %in% c("no info", "none")) %>%
    distinct(deployment_fk) %>%
    pull()

  if(length(animals_multiple_tags) > 0) {
    warning("Animals with multiple tags: ", paste(animals_multiple_tags, collapse = ", "))
  }
  if(length(tags_multiple_animals) > 0) {
    warning("Tags associated with multiple animals: ", paste(tags_multiple_animals, collapse = ", "))
  }
  if(length(orphaned_deployments) > 0) {
    warning("Deployments without network project: ", paste(orphaned_deployments, collapse = ", "))
  }
}
