#' Get acoustic project data
#'
#' Get data for acoustic projects, with options to filter results.
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
#'
#' @return A tibble with acoustic project data, sorted by `project_code`. See
#'   also
#'   [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @examples
#' # Set default connection variable
#' con <- connect_to_etn()
#'
#' # Get all acoustic projects
#' get_acoustic_projects(con)
#'
#' # Get a specific acoustic project
#' get_acoustic_projects(con, acoustic_project_code = "demer")
get_acoustic_projects <- function(connection = con,
                                  acoustic_project_code = NULL) {
  # Check connection
  check_connection(connection)

  # Check acoustic_project_code
  if (is.null(acoustic_project_code)) {
    acoustic_project_code_query <- "True"
  } else {
    acoustic_project_code <- check_value(
      acoustic_project_code,
      list_acoustic_project_codes(connection),
      "acoustic_project_code",
      lowercase = TRUE
    )
    acoustic_project_code_query <- glue::glue_sql(
      "LOWER(project.project_code) IN ({acoustic_project_code*})",
      .con = connection
    )
  }

  project_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "project.sql", package = "etn")),
    .con = connection
  )

  # Build query
  query <- glue::glue_sql("
    SELECT
      project.*
    FROM
      ({project_sql}) AS project
    WHERE
      project_type = 'acoustic'
      AND {acoustic_project_code_query}
    ", .con = connection)
  projects <- DBI::dbGetQuery(connection, query)

  # Sort data
  projects <-
    projects %>%
    dplyr::arrange(.data$project_code)

  dplyr::as_tibble(projects)
}
