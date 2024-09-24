#' Get acoustic project data
#'
#' Get data for acoustic projects, with options to filter results.
#'
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
#'
#' @return A tibble with acoustic project data, sorted by `project_code`. See
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
#' # Get all acoustic projects
#' get_acoustic_projects(con)
#'
#' # Get a specific acoustic project
#' get_acoustic_projects(con, acoustic_project_code = "demer")
get_acoustic_projects <- function(connection,
                                  acoustic_project_code = NULL,
                                  api = TRUE){
  # Check arguments
  # The connection argument has been depreciated
  if (lifecycle::is_present(connection)) {
    deprecate_warn_connection()
  }
  # Either use the API, or the SQL helper.
  out <- conduct_parent_to_helpers(api)
  return(out)
}
#' get_acoustic_projects() sql helper
#'
#' @inheritParams get_acoustic_projects()
#' @noRd
#'
get_acoustic_projects_sql <- function(acoustic_project_code = NULL) {
  # Create connection
  connection <- do.call(connect_to_etn, get_credentials())
  # Check connection
  check_connection(connection)

  # Check acoustic_project_code
  if (is.null(acoustic_project_code)) {
    acoustic_project_code_query <- "True"
  } else {
    acoustic_project_code <- check_value(
      acoustic_project_code,
      list_acoustic_project_codes(api = FALSE),
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

  # Close connection
  DBI::dbDisconnect(connection)

  # Return acoustic projects
  dplyr::as_tibble(projects)
}
