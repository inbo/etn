#' Get animal metadata
#'
#' Get metadata for animals, with options to filter results. Associated tag
#' information is available in columns starting with `tag`. If multiple tags
#' are associated with a single animal, the information is comma-separated.
#'
#' @param connection A valid connection to the ETN database.
#' @param animal_id (integer) One or more animal ids.
#' @param animal_project_code (string) One or more animal projects.
#' @param scientific_name (string) One or more scientific names.
#'
#' @return A tibble (tidyverse data.frame) with metadata for animals, sorted by
#'   `animal_project_code`, `release_date_time` and `tag_id`.
#'
#' @export
#'
#' @importFrom glue glue_sql
#' @importFrom DBI dbGetQuery
#' @importFrom dplyr %>% arrange as_tibble group_by_at mutate_at select summarize_at ungroup
#'
#' @examples
#' \dontrun{
#' con <- connect_to_etn(your_username, your_password)
#'
#' # Get all animals
#' get_animals(con)
#'
#' # Get specific animals
#' get_animals(con, animal_id = 2824)
#' get_animals(con, animal_id = "2824") # String values work as well
#' get_animals(con, animal_id = c(2824, 2825, 2827))
#'
#' # Get animals from specific animal project(s)
#' get_animals(con, animal_project_code = "2012_leopoldkanaal")
#' get_animals(con, animal_project_code = c("2012_leopoldkanaal", "phd_reubens"))
#'
#' # Get animals of specific species (across all projects)
#' get_animals(con, scientific_name = c("Gadus morhua", "Sentinel"))
#'
#' # Get animals of a specific species from a specific project
#' get_animals(con, animal_project_code = "phd_reubens", scientific_name = "Gadus morhua")
#' }
get_animals <- function(connection = con,
                        animal_id = NULL,
                        animal_project_code = NULL,
                        scientific_name = NULL) {
  # Check connection
  check_connection(connection)

  # Check animal_id
  if (is.null(animal_id)) {
    animal_id_query <- "True"
  } else {
    valid_animal_ids <- list_animal_ids(connection)
    check_value(animal_id, valid_animal_ids, "animal_id")
    animal_id_query <- glue_sql("animal_id IN ({animal_id*})", .con = connection)
    # animal_id_query seems to work correctly with integers or strings: 'animal_id IN (\'304\')'
  }

  # Check animal_project_code
  if (is.null(animal_project_code)) {
    animal_project_code_query <- "True"
  } else {
    valid_animal_project_codes <- list_animal_project_codes(connection)
    check_value(animal_project_code, valid_animal_project_codes, "animal_project_code")
    animal_project_code_query <- glue_sql("animal_project_code IN ({animal_project_code*})", .con = connection)
  }

  # Check scientific_name
  if (is.null(scientific_name)) {
    scientific_name_query <- "True"
  } else {
    scientific_name_ids <- list_scientific_names(connection)
    check_value(scientific_name, scientific_name_ids, "scientific_name")
    scientific_name_query <- glue_sql("scientific_name IN ({scientific_name*})", .con = connection)
  }

  # Build query
  query <- glue_sql("
    SELECT
      *
    FROM
      vliz.animals_view2
    WHERE
      {animal_id_query}
      AND {animal_project_code_query}
      AND {scientific_name_query}
    ", .con = connection)
  animals <- dbGetQuery(connection, query)

  # Collapse tag information, to obtain one row = one animal
  tag_cols <- animals %>%
    select(starts_with("tag")) %>%
    names()
  other_cols <- animals %>%
    select(-starts_with("tag")) %>%
    names()
  animals <-
    animals %>%
    group_by_at(other_cols) %>%
    summarize_at(tag_cols, paste, collapse = ",") %>% # Collapse multiple tags by comma
    ungroup() %>%
    mutate_at(tag_cols, gsub, pattern = "NA", replacement = "") %>% # Use "" instead of "NA"
    select(names(animals)) # Use the original column order

  # Sort data
  animals <-
    animals %>%
    arrange(
      animal_project_code,
      release_date_time,
      factor(tag_id, levels = list_tag_ids(connection))
    )

  as_tibble(animals) # Is already a tibble, but added if code above changes
}
