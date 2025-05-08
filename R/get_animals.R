#' Get animal data
#'
#' Get data for animals, with options to filter results. Associated tag
#' information is available in columns starting with `tag` and
#' `acoustic_tag_id`. If multiple tags are associated with a single animal,
#' the information is comma-separated.
#'
#' @param animal_id Integer (vector). One or more animal identifiers.
#' @param animal_project_code Character (vector). One or more animal project
#'   codes. Case-insensitive.
#' @param tag_serial_number Character (vector). One or more tag serial numbers.
#' @param scientific_name Character (vector). One or more scientific names.
#'
#' @return A tibble with animals data, sorted by `animal_project_code`,
#' `release_date_time` and `tag_serial_number`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @inheritParams list_animal_ids
#' @export
#'
#' @examples
#' # Get all animals
#' get_animals()
#'
#' # Get specific animals
#' get_animals(animal_id = 305) # Or string value "305"
#' get_animals(animal_id = c(304, 305, 2827))
#'
#' # Get animals from specific animal project(s)
#' get_animals(animal_project_code = "2014_demer")
#' get_animals(animal_project_code = c("2014_demer", "2015_dijle"))
#'
#' # Get animals associated with a specific tag_serial_number
#' get_animals(tag_serial_number = "1187450")
#'
#' # Get animals of specific species (across all projects)
#' get_animals(scientific_name = c("Rutilus rutilus", "Silurus glanis"))
#'
#' # Get animals of a specific species from a specific project
#' get_animals(animal_project_code = "2014_demer", scientific_name = "Rutilus rutilus")
get_animals <- function(connection,
                        animal_id = NULL,
                        tag_serial_number = NULL,
                        animal_project_code = NULL,
                        scientific_name = NULL,
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
