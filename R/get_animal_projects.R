#' Get animal project data
#'
#' Get data for animal projects, with options to filter results.
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param animal_project_code Character (vector). One or more animal project
#'   codes. Case-insensitive.
#'
#' @return A tibble with animal project data, sorted by `project_code`. See
#'   also
#'   [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr .data %>% arrange as_tibble
#' @importFrom readr read_file
#'
#' @examples
#' # Set default connection variable
#' con <- connect_to_etn()
#'
#' # Get all animal projects
#' get_animal_projects(con)
#'
#' # Get a specific animal project
#' get_animal_projects(con, animal_project_code = "2014_demer")
get_animal_projects <- function(connection = con,
                                animal_project_code = NULL) {
  # Check connection
  check_connection(connection)

  # Check animal_project_code
  if (is.null(animal_project_code)) {
    animal_project_code_query <- "True"
  } else {
    animal_project_code <- tolower(animal_project_code)
    valid_animal_project_codes <- tolower(list_animal_project_codes(connection))
    check_value(animal_project_code, valid_animal_project_codes, "animal_project_code")
    animal_project_code_query <- glue_sql(
      "LOWER(project.project_code) IN ({animal_project_code*})",
      .con = connection
    )
  }

  project_sql <- glue_sql(read_file(system.file("sql", "project.sql", package = "etn")), .con = connection)

  # Build query
  query <- glue_sql("
    SELECT
      project.*
    FROM
      ({project_sql}) AS project
    WHERE
      project_type = 'animal'
      AND {animal_project_code_query}
    ", .con = connection)
  projects <- dbGetQuery(connection, query)

  # Sort data
  projects <-
    projects %>%
    arrange(.data$project_code)

  as_tibble(projects)
}
