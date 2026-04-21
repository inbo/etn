#' Get animal project data as a Data Package
#'
#' Get all acoustic data related to an **animal project**  as a data package.
#'
#' Get all acoustic data related to an **animal project**  as a
#' **[Frictionless Data Package](https://specs.frictionlessdata.io/data-package/)**
#' containing:
#'
#' **file** | **description**
#' --- | ---
#' `animals.csv` | Animals related to an `animal_project_code`, as returned by `get_animals()`.
#' `tags.csv` | Tags associated with the selected animals, as returned by `get_tags()`.
#' `detections.csv` | Acoustic detections for the selected animals, as returned by `get_acoustic_detections()`.
#' `deployments.csv` | Acoustic deployments for the `acoustic_project_code`(s) found in detections, as returned by `get_acoustic_deployments()`. This allows users to see when receivers were deployed, even if these did not detect the selected animals.
#' `receivers.csv` | Acoustic receivers for the selected deployments, as returned by `get_acoustic_receivers()`.
#' `datapackage.json` | A [Frictionless Table Schema](https://specs.frictionlessdata.io/table-schema/) metadata file describing the fields and relations of the above csv files.
#'
#' **Important**: The data are downloaded _as is_ from the database, i.e. no
#' quality or consistency checks are performed by this function. We therefore
#' recommend to verify the data before publication. A consistency check can be
#' performed by validation tools of the Frictionless Framework, e.g.
#' `frictionless validate datapackage.json` on the command line using
#' [frictionless-py](https://github.com/frictionlessdata/frictionless-py).
#'
#' @param animal_project_code Character. Animal project you want to get an
#' acoustic data package for. Required.
#' @return A Data Package object.
#' @family access functions
#' @export
#' @examplesIf etn:::credentials_are_set() & interactive()
#' # Get data package for the 2014_demer animal project
#' get_package(animal_project_code = "2014_demer")
#' #> A Data Package with 5 resources:
#' #> • animals
#' #> • tags
#' #> • detections
#' #> • deployments
#' #> • receivers
#' #> Use `unclass()` to print the Data Package as a list.
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

  # ANIMALS
  message("* (1/6): downloading animals.csv")
  # Select on animal_project_code
  animals <- get_animals(animal_project_code = animal_project_code)

  # TAGS
  message("* (2/6): downloading tags.csv")
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

  # DETECTIONS
  message("* (3/6): downloading detections.csv")
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

  # DEPLOYMENTS
  message("* (4/6): downloading deployments.csv")
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

  # RECEIVERS
  message("* (5/6): downloading receivers.csv")
  # Select on receivers associated with deployments
  receiver_ids <-
    deployments |>
    dplyr::distinct(.data$receiver_id) |>
    dplyr::pull()
  receivers <- get_acoustic_receivers(
    receiver_id = receiver_ids
  )

  # Obtain imis_dataset_id and doi
  project_info <- get_animal_projects(
    animal_project_code = animal_project_code, citation = TRUE
    )
  doi <- if (!is.na(project_info$doi)) {
    project_info$doi
  } else {
   paste0("https://marineinfo.org/id/dataset/", project_info$imis_dataset_id)
  }

  # CREATE PACKAGE
  message("* (6/6): create package")
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
