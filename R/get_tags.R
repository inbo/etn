#' Get tags metadata
#'
#' At the moment, only tags that can be linked to a projectcode are returned to
#' the user.
#'
#' @param connection A valid connection with the ETN database.
#' @param animal_project (string) One or more animal projects.
#'
#' @return A data.frame.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr pull
#'
#' @examples
#' \dontrun{
#'   get_tags(con)
#'   get_tags(con, animal_project = c("phd_reubens"))
#' }

get_tags <- function(connection,
                     animal_project = NULL) {

  check_connection(connection)

  # valid inputs on animal projects
  valid_animals_projects <-
    get_projects(connection, project_type = "animal") %>%
    pull(projectcode)
  check_null_or_value(animal_project,  valid_animals_projects, "animal_project")
  if (is.null(animal_project)) {
    animal_project = valid_animals_projects
  }

  tags_query <- glue_sql("
      SELECT tags.*, animals.projectcode
      FROM vliz.tags
        LEFT JOIN vliz.animal_tag_release ON (animal_tag_release.tag_fk = tags.id_pk)
        LEFT JOIN vliz.animals_view animals ON (animals.id_pk = animal_tag_release.animal_fk)
      WHERE projectcode IN ({project*})",
    project = animal_project,
    .con = connection
  )
  tags <- dbGetQuery(connection, tags_query)
  tags

}
