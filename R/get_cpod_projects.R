#' Get cpod project data
#'
#' Get data for cpod projects, with options to filter results.
#'
#' @param cpod_project_code Character (vector). One or more cpod project
#'   codes. Case-insensitive.
#'
#' @return A tibble with animal project data, sorted by `project_code`. See
#'   also
#'   [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @inheritParams list_animal_ids
#' @export
#'
#' @examples
#' # Set default connection variable
#' con <- connect_to_etn()
#'
#' # Get all animal projects
#' get_cpod_projects(con)
#'
#' # Get a specific animal project
#' get_cpod_projects(con, cpod_project_code = "cpod-lifewatch")
get_cpod_projects <- function(connection,
                              cpod_project_code = NULL,
                              api = TRUE) {
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api)
  return(out)
}

#' get_cpod_projects() sql helper
#'
#' @inheritParams get_cpod_projects()
#' @noRd
#'
get_cpod_projects_sql <- function(cpod_project_code = NULL) {
  # Create connection
  connection <- create_connection(credentials = get_credentials())
  # Check connection
  check_connection(connection)

  # Check cpod_project_code
  if (is.null(cpod_project_code)) {
    cpod_project_code_query <- "True"
  } else {
    cpod_project_code <- check_value(
      cpod_project_code,
      list_cpod_project_codes(connection),
      "cpod_project_code",
      lowercase = TRUE
    )
    cpod_project_code_query <- glue::glue_sql(
      "LOWER(project.project_code) IN ({cpod_project_code*})",
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
      project_type = 'cpod'
      AND {cpod_project_code_query}
    ", .con = connection)
  projects <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Sort data
  projects <-
    projects %>%
    dplyr::arrange(.data$project_code)

  dplyr::as_tibble(projects)
}
