# vliz.animals_view

get_animals <- function(connection,
                        network_project = NULL,
                        animal_project = NULL,
                        species = NULL) {

  check_connection(connection)

  valid_networks <- get_projects(connection, project_type = "network") %>%
    pull(projectcode)
  check_null_or_value(network_project, valid_networks, "network_project")

  valid_animals <- get_projects(connection, project_type = "animal") %>%
    pull(projectcode)
  check_null_or_value(animal_project, valid_animals, "animal_project")

  if (is.null(network_project)) {
    network_project = valid_networks
  }
  if (is.null(animal_project)) {
    animal_project = valid_animals
  }

  # see https://github.com/inbo/etn/issues/18
  projects <- data.frame(projectcode = c(network_project, animal_project),
                         stringsAsFactors = FALSE)
  project_names <- get_projects(connection) %>%
    select(projectcode, name) %>%
    right_join(projects, by = "projectcode") %>%
    pull(name)

  animals_query <- glue_sql(
    "SELECT * FROM vliz.animals_view
    WHERE projectname IN ({projects*})",
    projects = project_names,
    .con = connection
  )

  animals <- dbGetQuery(connection, animals_query)
  animals

}
