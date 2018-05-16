#' Get animals data
#'
#' Get all or a subset of animals data. Filter options are the network
#' project(s), the animal project(s) and/or the scientific name of the animals.
#'
#' @param connection A valid connection to ETN database.
#' @param network_project (string) One or more network projects.
#' @param animal_project (string) One or more animal projects.
#' @param scientific_name (string) One or more scientific names.
#'
#' @return A data.frame.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr pull %>%
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # all animals
#' animals <- get_animals(con)
#'
#' # all animals of the 2012_leopoldkanaal project
#' animals <- get_animals(con, animal_project = "2012_leopoldkanaal")
#'
#' # all animals of the 2012_leopoldkanaal and phd_reubens
#' get_animals(con, animal_project = c("2012_leopoldkanaal", "phd_reubens"))
#'
#' #all animals of the thornton network project
#' get_animals(con, network_project = "thornton")
#'
#' #all animals of the thornton and leopold network project
#' get_animals(con, network_project = c("thornton", "leopold"))
#'
#' # all animals of all projects with given scientific name
#' animals <- get_animals(con,
#'                        scientific_name = c("Gadus morhua",
#'                                            "Sentinel"))
#'
#' # all animals of the phd_reubens project with given scientific name
#' animals <- get_animals(con, animal_project = "phd_reubens",
#'                        scientific_name = "Gadus morhua")
#' }
get_animals <- function(connection,
                        network_project = NULL,
                        animal_project = NULL,
                        scientific_name = NULL) {

  check_connection(connection)

  # valid inputs on network projects
  valid_network_projects <- get_projects(connection,
                                         project_type = "network") %>%
    pull("projectcode")
  check_null_or_value(network_project, valid_network_projects,
                      "network_project")

  # valid inputs on animal projects
  valid_animals_projects <- get_projects(connection,
                                         project_type = "animal") %>%
    pull("projectcode")
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

  query <- glue_sql(
    "SELECT DISTINCT scientific_name FROM vliz.animals_view ",
    .con = connection
  )
  data <- dbGetQuery(connection, query)
  data$scientific_name
}

