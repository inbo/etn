#' Get cpod project data
#'
#' Get data for cpod projects, with options to filter results.
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param cpod_project_code Character (vector). One or more cpod project
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
#' \dontrun{
#' # Set default connection variable
#' con <- connect_to_etn()
#'
#' # Get all animal projects
#' get_cpod_projects()
#'
#' # Get a specific animal project
#' get_animal_projects(cpod_project_code = "cpod-lifewatch")
#' }
get_cpod_projects <- function(connection = con,
                              cpod_project_code = NULL) {
  # Check connection
  check_connection(connection)

  # Check cpod_project_code
  if (is.null(cpod_project_code)) {
    cpod_project_code_query <- "True"
  } else {
    cpod_project_code <- tolower(cpod_project_code)
    valid_cpod_project_codes <- tolower(list_cpod_project_codes(connection))
    check_value(cpod_project_code, valid_cpod_project_codes, "cpod_project_code")
    cpod_project_code_query <- glue_sql(
      "LOWER(project.project_code) IN ({cpod_project_code*})",
      .con = connection
    )
  }

  project_query <- glue_sql(read_file(system.file("sql", "project.sql", package = "etn")), .con = connection)

  # Build query
  query <- glue_sql("
    SELECT
      project.*
    FROM
      ({project_query}) AS project
    WHERE
      project_type = 'cpod'
      AND {cpod_project_code_query}
    ", .con = connection)
  projects <- dbGetQuery(connection, query)

  # Sort data
  projects <-
    projects %>%
    arrange(.data$project_code)

  as_tibble(projects)
}
