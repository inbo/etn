#' Get animal project data as a Data Package
#'
#' Gets data related to an **animal project** as a [Data Package](
#' https://specs.frictionlessdata.io/data-package/).
#'
#' @param animal_project_code Animal project you want to get data from.
#' @return A Data Package object.
#' @family access functions
#' @export
#' @section Included resources:
#' The Data Package will contain and describe the following resources:
#' - `animals`: Animals related to an `animal_project_code`, as returned by
#'   [get_animals()].
#' - `tags`: Tags associated with the selected animals, as returned by
#'   [get_tags()].
#' - `detections`: Acoustic detections for the selected animals, as returned by
#'   [get_acoustic_detections()].
#' - `deployments`: Acoustic deployments for the `acoustic_project_code`(s)
#'   found in detections, as returned by [get_acoustic_deployments()].
#'   This allows you to see when receivers were deployed, even if these did
#'   not detect the selected animals.
#' - `receivers`: Acoustic receivers for the selected deployments, as returned
#'   by [get_acoustic_receivers()].
#'
#' You can write the Data Package to disk with [write_package()].
#'
#' @section Data quality:
#' The data are downloaded from the ETN database _as is_, i.e. no quality or
#' consistency checks are performed.
#' We therefore recommend to verify the data before publication.
#' A consistency check can be performed on the files using:
#'
#' ```
#' pip install frictionless
#' frictionless validate datapackage.json
#' ```
#' @examplesIf etn:::credentials_are_set() & interactive()
#' # Get a Data Package for a project
#' get_package(animal_project_code = "2014_demer")
get_package <- function(animal_project_code) {
  # Check animal_project_code
  if (length(animal_project_code) != 1) {
    cli::cli_abort(
      "{.arg animal_project_code} must be a single value.",
      class = "etn_error_code_value"
    )
  }
  animal_project_code <- check_value(
    animal_project_code,
    list_animal_project_codes(),
    "animal_project_code",
    lowercase = TRUE
  )

  # Get data
  cli::cli_h2("Getting data")
  cli::cli_ol()

  # Animals
  cli::cli_li("Getting {.val animals}.")
  # Select on animal_project_code
  animals <- get_animals(animal_project_code = animal_project_code)


  # Tags
  cli::cli_li("Getting {.val tags}.")
  # Select on tags associated with animals
  tag_serial_numbers <-
    animals |>
    dplyr::distinct(.data$tag_serial_number) |>
    dplyr::pull() |>
    # To parse out multiple tags (e.g. "A69-9006-904,A69-9006-903"), combine
    # all tags and split them again on comma
    paste(collapse = ",") |>
    strsplit("\\,") |>
    unlist() |>
    unique()
  tags <- get_tags(tag_serial_number = tag_serial_numbers)

  # Detections
  cli::cli_li("Getting {.val detections}.")
  # Select on animal_project_code
  detections <- get_acoustic_detections(
    animal_project_code = animal_project_code,
    limit = FALSE
  )
  # Keep unique records
  detections <-
    detections |>
    dplyr::distinct(.data$detection_id, .keep_all = TRUE) |>
    dplyr::arrange(.data$tag_serial_number, .data$detection_id)

  # Deployments
  cli::cli_li("Getting {.val deployments}.")
  # Select on acoustic_project_codes found in detections to get all deployments,
  # including those without detections for animal_project_code
  acoustic_project_codes <-
    detections |>
    dplyr::distinct(.data$acoustic_project_code) |>
    dplyr::pull() |>
    stringr::str_sort()
  deployments <- get_acoustic_deployments(
    acoustic_project_code = acoustic_project_codes,
    open_only = FALSE
  )
  # Remove linebreaks in deployment comments to get single lines in csv:
  deployments <-
    deployments |>
    dplyr::mutate(
      comments = stringr::str_replace_all(.data$comments, "[\r\n]+", " ")
    )

  # Receivers
  cli::cli_li("Getting {.val receivers}.")
  # Select on receivers associated with deployments
  receiver_ids <-
    deployments |>
    dplyr::distinct(.data$receiver_id) |>
    dplyr::pull()
  receivers <- get_acoustic_receivers(
    receiver_id = receiver_ids
  )
  cli::cli_end()

  # Obtain imis_dataset_id and doi
  project_info <- get_animal_projects(
    animal_project_code = animal_project_code, citation = TRUE
  )
  doi <- if (!is.na(project_info$doi)) {
    project_info$doi
  } else {
    paste0("https://marineinfo.org/id/dataset/", project_info$imis_dataset_id)
  }

  # Create package
  cli::cli_h2("Creating Data Package")
  package <-
    frictionless::create_package() |>
    add_resource("animals", animals) |>
    add_resource("tags", tags) |>
    add_resource("detections", detections) |>
    add_resource("deployments", deployments) |>
    add_resource("receivers", receivers) |>
    append(c(
      id = doi,
      name = tolower(animal_project_code)
    ), after = 0) |>
    frictionless::create_package()

  return(package)
}
