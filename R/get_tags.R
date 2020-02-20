#' Get tag metadata
#'
#' Get metadata for tags. Only returns tags that can be linked to an animal (and
#' thus an animal project). By default, reference tags are excluded.
#'
#' @param connection A valid connection with the ETN database.
#' @param animal_project (string) One or more animal projects.
#' @param include_reference_tags (logical) Include reference tags. Default:
#'   `FALSE`.
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
#' # Get all (animal) tags
#' get_tags(con)
#'
#' # Get all tags, including reference tags
#' get_tags(con, include_reference_tags = TRUE)
#'
#' # Get tags linked to specific animal project(s)
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
  check_null_or_value(animal_project, valid_animals_projects, "animal_project")
  if (is.null(animal_project)) {
    animal_project <- valid_animals_projects
  }

  tags_query <- glue_sql("
    SELECT tags.*
    FROM vliz.tags_view2 AS tags
      LEFT JOIN vliz.animals_view2 AS animals
      ON animals.tag_fk = tags.pk
    WHERE animals.animal_project_code IN ({animal_project*})
    ", .con = connection)
  tags <- dbGetQuery(connection, tags_query)

  if (include_reference_tags) {
    tags
  } else {
    tags %>% filter(.data$type == "animal")
  }

  as_tibble(tags)
}
