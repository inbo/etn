read_catalog <- function(catalog = c(".",
                                     "metadata_files",
                                     "detection_files",
                                     "archival_files")){
  catalog <- rlang::arg_match(catalog)

  catalog_root <- "https://www.lifewatch.be/etn/parquet/staging"
  jsonlite::fromJSON(file.path(catalog_root,"catalog.json"))
}

read_child_catalog <- function(catalog = c("metadata_files",
                                           "detection_files",
                                           "archival_files")){
  catalog <- rlang::arg_match(catalog)

  catalog_root <- "https://www.lifewatch.be/etn/parquet/staging"

  jsonlite::fromJSON(file.path(catalog_root, catalog, "collection.json"))
}

get_public_detection_catalog <- function(){
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
