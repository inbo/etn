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

read_child_catalog <- function(catalog = c(
                                 "metadata_files",
                                 "detection_files",
                                 "archival_files"
                               )) {
  catalog <- rlang::arg_match(catalog)

  catalog_root <- "https://www.lifewatch.be/etn/parquet/staging"

  jsonlite::fromJSON(file.path(catalog_root, catalog, "collection.json"))
}

get_public_detection_catalog <- function() {
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
read_public_metadata <- function(table = c(
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
