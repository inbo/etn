#' Get animal metadata
#'
#' Get metadata for animals, with options to filter on animal project and/or
#' scientific name.
#'
#' @param connection A valid connection to ETN database.
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
#' # Get metadata for all animals
#' animals <- get_animals(con)
#'
#' # Get metadata for animals linked to specific project(s)
#' animals <- get_animals(con, animal_project = "2012_leopoldkanaal")
#' animals <- get_animals(con, animal_project = c("2012_leopoldkanaal", "phd_reubens"))
#'
#' # Get metadata for animals with specific scientific names (across all projects)
#' animals <- get_animals(con, scientific_name = c("Gadus morhua", "Sentinel"))
#'
#' # Get metadata for animals with specific scientific name for specific project
#' animals <- get_animals(con, animal_project = "phd_reubens", scientific_name = "Gadus morhua")
#' }
get_animals <- function(connection,
                        animal_project = NULL,
                        scientific_name = NULL) {

  check_connection(connection)

  # valid inputs on animal projects
  valid_animals_projects <- get_projects(connection,
                                         project_type = "animal") %>%
    pull("projectcode")
  check_null_or_value(animal_project, valid_animals_projects,
                      "animal_project")

  # valid scientific names
  valid_animals <- scientific_names(connection)
  check_null_or_value(scientific_name, valid_animals, "scientific_name")

  if (is.null(animal_project)) {
    animal_project = valid_animals_projects
  }

  if (is.null(scientific_name)) {
    scientific_name = valid_animals
  }

  animals_query <- glue_sql("
    SELECT *
    FROM vliz.animals_view2
    WHERE animal_project_code IN ({animal_project*})
      AND scientific_name IN ({scientific_name*})
    ", .con = connection
  )

  animals <- dbGetQuery(connection, animals_query)
  as_tibble(animals)
}

#' Support function to get unique set of scientific names
#'
#' This function retrieves all unique scientific names
#' @param connection A valid connection to ETN database.
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#'
#' @return A vector of all scientific names present in vliz.animals_view.
scientific_names <- function(connection) {

  query <- glue_sql("
    SELECT DISTINCT scientific_name
    FROM vliz.animals_view2
    ", .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$scientific_name
}
