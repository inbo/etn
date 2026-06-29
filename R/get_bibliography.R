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
    dplyr::pull(x, "animal_project_code") |>
    unique()
  # Check that all provided project codes are valid
  provided_acoustic_project_codes <-
    dplyr::pull(x, "acoustic_project_code") |>
    unique()

  animal_project_codes <- rlang::arg_match0(
    provided_animal_project_codes,
    values = list_animal_project_codes(),
    arg_nm = "animal_project_code",
    error_call = rlang::caller_env()
  )

  acoustic_project_codes <- rlang::arg_match0(
    provided_acoustic_project_codes,
    values = list_acoustic_project_codes(),
    arg_nm = "acoustic_project_code",
    error_call = rlang::caller_env()
  )

  # Fetch project citations -------------------------------------------------
  animal_citations <- get_animal_projects(
    animal_project_code = animal_project_codes,
    citation = TRUE
  ) |>
    dplyr::select(dplyr::all_of(c("project_code", "citation")))

  acoustic_citations <- get_acoustic_projects(
    acoustic_project_code = acoustic_project_codes,
    citation = TRUE
  ) |>
    dplyr::select(dplyr::all_of(c("project_code", "citation")))

  # Format output -----------------------------------------------------------

  etn_ref <- paste(
    "European Tracking Network - Data Platform.",
    "Flanders Marine Institute (VLIZ)"
  )

  list(
    animal_project = animal_citations,
    acoustic_project = acoustic_citations) |>
    # Rename columns
    purrr::map(\(df) {dplyr::rename(df, item = .data$project_code)}) |>
    dplyr::bind_rows(.id = "type") |>
    dplyr::add_row(
      .before = 1L,
      item = "ETN",
      type = "data platfrom",
      citation = etn_ref
    ) |>
    dplyr::add_row(
      .after = 1L,
      item = "etn",
      type = "R package",
      citation = etn_citation()
    )
}
