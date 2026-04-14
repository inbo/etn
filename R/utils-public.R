read_catalog <- function(catalog = c(
                           ".",
                           "metadata_files",
                           "detection_files",
                           "archival_files"
                         )) {
  catalog <- rlang::arg_match(catalog)

  catalog_root <- "https://www.lifewatch.be/etn/parquet/staging"
  jsonlite::fromJSON(file.path(catalog_root, "catalog.json"))
}

#' Read a child catalog
#'
#' This function reads a child catalog from the ETN public data parquet dumps.
#' The child catalogs are "metadata_files", "detection_files", and
#' "archival_files". The function takes the name of the child catalog as an
#' argument and returns the contents of the child catalog as a list. The child
#' catalog contains links to the individual files in the catalog, which can be
#' used to read the data from the parquet dumps.
#'
#' @param catalog The name of the child catalog to read. One of
#'   "metadata_files", "detection_files", or "archival_files".
#'
#' @returns A list containing the contents of the child catalog.
#'
#' @family parquet helpers
#' @noRd
#'
#' @examplesIf interactive()
#' read_child_catalog(catalog = "detection_files")
#' read_child_catalog(catalog = "metadata_files")
read_child_catalog <- function(catalog = c(
                                 "metadata_files",
                                 "detection_files",
                                 "archival_files"
                               )) {
  catalog <- rlang::arg_match(catalog)

  catalog_root <- "https://www.lifewatch.be/etn/parquet/staging"

  jsonlite::fromJSON(file.path(catalog_root, catalog, "collection.json"))
}

#' List public detection files
#'
#' This function lists the public detection files available in the ETN public
#' data parquet dumps. It reads the child catalog for detection files and
#' extracts the project codes and paths to the detection files.
#'
#' @returns A tibble with two columns: `project_code` and `path`. The
#'   `project_code` column.
#'
#' @family parquet helpers
#' @noRd
#'
#' @examplesIf interactive()
#' list_public_detections()
list_public_detections <- function() {
  read_child_catalog(catalog = "detection_files") |>
    purrr::chuck("links") |>
    # Drop the root, only keep catalog items
    dplyr::filter(.data$rel == "item") |>
    dplyr::mutate(
      .keep = "none",
      project_code = path_sans_ext(basename(.data$href)),
      path = .data$href
    )
}

get_public_detections <- function(project_code, ...) {
  public_detections <- list_public_detections()
  selected_project_code <- rlang::arg_match0(
    project_code,
    values = public_detections$project_code
  )

  detections_path <-
    list_public_detections() |>
    dplyr::filter(project_code == selected_project_code) |>
    dplyr::pull("path")

  catalog_root <- "https://www.lifewatch.be/etn/parquet/staging"

  jsonlite::fromJSON(file.path(catalog_root, "detection_files",
                                 detections_path)) |>
      purrr::chuck("assets", "data", "href") |>
      purrr::map(arrow::read_parquet) |>
      purrr::list_rbind() |>
      dplyr::filter(...)
}

#' Read values from the parquet dump metadata files
#'
#' @param table What table to read the metadata file of. One of "animals",
#'   "deployments", "projects", "receivers", or "tags".
#'
#' @returns A tibble with the contents of the parquet dump metadata file for the
#'   selected table.
#'
#' @family parquet helpers
#' @noRd
#'
#' @examplesIf interactive()
#' get_public_metadata("animals", tag_type == "acoustic")
#' get_public_metadata("projects", telemetry_type == "Acoustic")
#' # Equivalent to get_animal_projects() |> dplyr::filter(start_date > lubridate::ymd(20150101))
#' get_public_metadata("projects", start_date > lubridate::ymd(20150101))
#' # Equivalent to list_animal_project_codes()
#' get_public_metadata("projects", project_type == "animal")$project_code
get_public_metadata <- function(table = c(
                                           "animals",
                                           "deployments",
                                           "projects",
                                           "receivers",
                                           "tags"
                                         ),
                                         ...) {
  selected_table <- rlang::arg_match(table)

  catalog_paths <-
    read_child_catalog(catalog = "metadata_files") |>
    purrr::chuck("links") |>
    # Drop the root, only keep catalog items
    dplyr::filter(.data$rel == "item") |>
    dplyr::mutate(
      .keep = "none",
      table = path_sans_ext(basename(.data$href)),
      path = .data$href
    )

  table_path <-
    dplyr::filter(catalog_paths, table == {{ selected_table }}) |>
    dplyr::pull("path")

  catalog_root <- "https://www.lifewatch.be/etn/parquet/staging"
  jsonlite::fromJSON(file.path(catalog_root, "metadata_files", table_path)) |>
    purrr::chuck("assets", "data", "href") |>
    purrr::map(arrow::read_parquet) |>
    purrr::list_rbind() |>
    dplyr::filter(...)
}
