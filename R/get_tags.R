#' Get tag metadata
#'
#' Get the metadata about the tags. At the moment, only tags
#' that can be linked to a projectcode are returned to the user. By default,
#' only animal tags are returned.
#'
#' @param connection A valid connection with the ETN database.
#' @param animal_project (string) One or more animal projects.
#' @param include_reference_tags (logical) Include reference tags (not-animal
#'   tags). Default: FALSE.
#'
#' @return A tibble (tidyverse data.frame).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr pull %>%
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # Get the metadata of all animal tags
#' get_tags(con)
#'
#' # Get the metadata of all tags, including reference tags
#' get_tags(con, include_reference_tags = TRUE)
#'
#' # Get the metadata of the tags linked to specific project(s)
#' get_tags(con, animal_project = "phd_reubens")
#' get_tags(con, animal_project = c("phd_reubens", "2012_leopoldkanaal"))
#' }
get_tags <- function(connection,
                     animal_project = NULL,
                     include_reference_tags = FALSE) {

  check_connection(connection)

  # valid inputs on animal projects
  valid_animals_projects <-
    get_projects(connection, project_type = "animal") %>%
    pull(.data$projectcode)
  check_null_or_value(animal_project,  valid_animals_projects, "animal_project")
  if (is.null(animal_project)) {
    animal_project = valid_animals_projects
  }

  tags_query <- glue_sql("
    SELECT tags.*
    FROM vliz.tags_view2 AS tags
      LEFT JOIN vliz.animals_view2 AS animals
      ON animals.tag_fk = tags.pk
    WHERE animals.animal_project_code IN ({animal_project*})
    ", .con = connection
  )
  tags <- dbGetQuery(connection, tags_query)

  if (include_reference_tags) {
    tags
  } else {
    tags %>% filter(.data$type == "animal")
  }

  as_tibble(tags)
}
