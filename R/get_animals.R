#' Get animal metadata
#'
#' Get metadata for animals, with options to filter on animal project and/or
#' scientific name.
#'
#' @param connection A valid connection to the ETN database.
#' @param animal_project (string) One or more animal projects.
#' @param scientific_name (string) One or more scientific names.
#'
#' @return A tibble (tidyverse data.frame).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr pull %>%
#' @importFrom tibble as_tibble
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # Get all animals
#' get_animals(con)
#'
#' # Get animals from specific animal project(s)
#' get_animals(con, animal_project = "2012_leopoldkanaal")
#' get_animals(con, animal_project = c("2012_leopoldkanaal", "phd_reubens"))
#'
#' # Get animals of specific species (across all projects)
#' get_animals(con, scientific_name = c("Gadus morhua", "Sentinel"))
#'
#' # Get animals of a specific species from a specific project
#' get_animals(con, animal_project = "phd_reubens", scientific_name = "Gadus morhua")
#' }
get_animals <- function(connection,
                        animal_project = NULL,
                        scientific_name = NULL) {
  # Check connection
  check_connection(connection)

  # Check animal project
  if (is.null(animal_project)) {
    animal_project_query <- "True"
  } else {
    valid_animal_projects <- animal_projects(connection)
    check_value(animal_project, valid_animal_projects, "animal_project")
    animal_project_query <- glue_sql("animal_project_code IN ({animal_project*})", .con = connection)
  }

  # Check scientific_name
  if (is.null(scientific_name)) {
    scientific_name_query <- "True"
  } else {
    scientific_name_ids <- scientific_names(connection)
    check_value(scientific_name, scientific_name_ids, "scientific_name")
    scientific_name_query <- glue_sql("scientific_name IN ({scientific_name*})", .con = connection)
  }

  # Build query
  query <- glue_sql("
    SELECT *
    FROM vliz.animals_view2
    WHERE
      {animal_project_query}
      AND {scientific_name_query}
    ", .con = connection
  )
  animals <- dbGetQuery(connection, query)
  as_tibble(animals)
}
