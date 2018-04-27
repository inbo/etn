#' Get animals data
#'
#' ...
#'
#' @param connection
#' @param network_project
#' @param animal_project
#' @param scientific_name
#'
#' @return
#' @export
#'
#' @examples
#' # all animals
#' animals <- get_animals(con)
#'
#' # all animals of the Demer project with given scientific name
#' animals <- get_animals(con, network_project = "demer",
#'                        scientific_name = c("Rutilus rutilus",
#'                        "Squalius cephalus"))
get_animals <- function(connection,
                        network_project = NULL,
                        animal_project = NULL,
                        scientific_name = NULL) {

  check_connection(connection)

  # valid inputs on network projects
  valid_network_projects <- get_projects(connection,
                                         project_type = "network") %>%
    pull(projectcode)
  check_null_or_value(network_project, valid_network_projects,
                      "network_project")

  # valid inputs on animal projects
  valid_animals_projects <- get_projects(connection,
                                         project_type = "animal") %>%
    pull(projectcode)
  check_null_or_value(animal_project, valid_animals_projects,
                      "animal_project")

  # valid scientific names
  valid_animals <- scientific_names(connection)
  check_null_or_value(scientific_name, valid_animals, "scientific_name")

  if (is.null(network_project)) {
    network_project = valid_network_projects
  }
  if (is.null(animal_project)) {
    animal_project = valid_animals_projects
  }
  project_names <- unique(c(network_project, animal_project))

  if (is.null(scientific_name)) {
    scientific_name = valid_animals
  }

  animals_query <- glue_sql(
    "SELECT * FROM vliz.animals_view
    WHERE projectcode IN ({projects*})
    AND scientific_name IN ({animals*})",
    projects = project_names,
    animals = scientific_name,
    .con = connection
  )

  animals <- dbGetQuery(connection, animals_query)
  animals

}

#' support function to get unique set of scientific names
scientific_names <- function(connection) {

  query <- glue_sql(
    "SELECT DISTINCT scientific_name FROM vliz.animals_view ",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data %>%
    pull(scientific_name)
}

