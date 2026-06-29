#' Generate a bibliography for a data.frame of detections
#'
#'
#'
#' @param x
#'
#' @returns
#' @export
#'
#' @examplesIf interactive() && etn:::credentials_are_set()
#' # Create a bibliography for a data.frame created by get_detections()
#' my_detections <- get_acoustic_detections(scientific_name = "Mola mola")
#' get_bibliography(my_detections)
#'
#' # Or from a frictionless datapackage containing detections
#' read_resource(example_dataset(), "detections") |>
#'   get_bibliography()
#'
#' # Altough mainly meant for the above use cases, you can also provide any
#' # data.frame as long as the project code columns are present
#' data.frame(animal_project_code = "2014_demer",
#'            acoustic_project_code = "demer") |>
#'  get_bibliography()
get_bibliography <- function(x) {

  # Check inputs ------------------------------------------------------------

  # Check if at least the required columns are present
  required_columns <- c("animal_project_code", "acoustic_project_code")
  if(!all(required_columns %in% colnames(x))){
    cli::cli_abort(
      "x must contain the following columns: {.val {required_columns}}",
      class = "etn_error_missing_columns"
    )
  }

  # Check that all the provided project codes can be found in the database
  provided_animal_project_codes <-
    dplyr::pull(x, name = "animal_project_code")
  # Check that all provided project codes are valid
  provided_acoustic_project_codes <-
    dplyr::pull(x, name = "acoustic_project_code")

  animal_project_codes <- rlang::arg_match0(
    provided_animal_project_codes,
    choices = list_animal_project_codes(),
    error_arg = "animal_project_code",
    multiple = TRUE,
    error_call = rlang::caller_env()
  )

  acoustic_project_codes <- rlang::arg_match0(
    provided_acoustic_project_codes,
    choices = list_acoustic_project_codes(),
    error_arg = "acoustic_project_code",
    multiple = TRUE,
    error_call = rlang::caller_env()
  )


}
