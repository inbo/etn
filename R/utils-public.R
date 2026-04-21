read_catalog <- function(catalog = c(".",
                                     "metadata_files",
                                     "detection_files",
                                     "archival_files")) {
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
  catalog <- rlang::arg_match(catalog,
    multiple = TRUE
  )

  catalog_root <- "https://www.lifewatch.be/etn/parquet/staging"

  file.path(catalog_root, catalog, "collection.json") |>
    httr2::request() |>
      httr2::req_retry(max_tries = 3) |>
    # Never place more then 2 requests a second
    httr2::req_perform() |>
    # simplifyVector to get data.frames out.
    httr2::resp_body_json(simplifyVector = TRUE)
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

#' Get public detections
#'
#' Read the public detection files for a given project code and filter the
#' detections based on the provided filter conditions.
#'
#' @param project_code The project code for which to read the public detection
#'   files. The project code must be one of the project codes listed in the
#'   output of `list_public_detections()`.
#' @param ... Filter conditions to apply to the detections. These conditions
#'   will be passed to `dplyr::filter()` to filter the detections after reading
#'   them from the parquet files.
#'
#' @returns A tibble with the public detections for the specified project code,
#'   filtered based on the provided filter conditions.
#'
#' @family parquet helpers
#' @noRd
#'
#' @examplesIf interactive()
#' get_public_detections("2011_Loire", timestamp >= lubridate::ymd(20220101))
#'
get_public_detections <- function(project_code = NULL, ...,
                                  limit = FALSE,
                                  progress = TRUE) {
  public_detections <- list_public_detections()
  if (is.null(project_code)) {
    selected_project_code <-
      public_detections$project_code
  } else {
    selected_project_code <-
      rlang::arg_match(project_code,
        values = public_detections$project_code,
        multiple = TRUE
      )
  }

  detections_path <-
    public_detections |>
    dplyr::filter(project_code %in% selected_project_code) |>
    dplyr::pull("path")

  catalog_root <- "https://www.lifewatch.be/etn/parquet/staging"

  # Read the parquet paths from the catalog
  parquet_paths <-
    file.path(catalog_root, "detection_files", detections_path) |>
    purrr::map(httr2::request) |>
    purrr::map(\(req) httr2::req_retry(req, max_tries = 3)) |>
    # Never place more then 2 requests a second
    purrr::map(\(req) httr2::req_throttle(req,
                                          capacity = 12,
                                          fill_time_s = 6)) |>
    httr2::req_perform_parallel(progress =
                                  ifelse(progress & !is_testing(),
                                         yes = "Reading table metadata",
                                         no = FALSE)) |>
    purrr::map(httr2::resp_body_json) |>
    purrr::map( ~ purrr::chuck(.x, "assets", "data", "href")) |>
    # Set the project_codes as names, for ease of debugging.
    purrr::set_names(
      purrr::map_chr(detections_path, ~basename(path_sans_ext(.x)))
      )

  # Read the contents of the parquet files as a single lazy view
  duckdb_view <-
    parquet_paths |>
    # Adapt the parquet paths to add `staging`, as per instructions from VLIZ
    purrr::map_chr(\(path) {
      stringr::str_replace(
        path,
        stringr::fixed("https://www.lifewatch.be/etn/parquet/detections/"),
        "https://www.lifewatch.be/etn/parquet/staging/detections/")
      }) |>
    duckdbfs::open_dataset(format = "parquet",
                           unify_schemas = TRUE,
                           conn = duckdbfs::cached_connection(
                             config = list(
                               # If a request fails, retry up to 8 times (eg too
                               # many requests), setting too low a value will
                               # result in failures.
                               http_retries = 8,
                               # Wait 2 seconds between retries
                               http_retry_wait_ms = 2000,
                               http_retry_backoff = 2,
                               # Reduce parallelism to avoid HTTP 429 too many
                               # requests
                               threads = 1
                             )
                           )) |>
    dplyr::filter(...) |>

  # Collect and return the table --------------------------------------------
  # Limit it if needed
  if(limit){
    utils::head(duckdb_view, n = 100L) |>
      dplyr::collect()
  } else {
    duckdb_view |>
      dplyr::collect()
  }
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
#' # Equivalent to get_animal_projects() |>
#' #   dplyr::filter(start_date > lubridate::ymd(20150101))
#' get_public_metadata("projects", start_date > lubridate::ymd(20150101))
#' # Equivalent to list_animal_project_codes()
#' get_public_metadata("projects", project_type == "animal")$project_code
get_public_metadata <- function(table = c("animals",
                                          "deployments",
                                          "projects",
                                          "receivers",
                                          "tags"),
                                ...) {

  # Check input arguments ---------------------------------------------------
  selected_table <- rlang::arg_match(table)

  # Look for available tables -----------------------------------------------
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

  # Fetch the correct table path --------------------------------------------
  table_path <-
    dplyr::filter(catalog_paths, table == {{ selected_table }}) |>
    dplyr::pull("path")

  # Read parquet files with arrow -------------------------------------------
  catalog_root <- "https://www.lifewatch.be/etn/parquet/staging"

  # In principle, multiple parquet files could be read if a resource is
  # split up into multiple files.
  arrow_tables <-
    jsonlite::fromJSON(file.path(catalog_root, "metadata_files", table_path)) |>
    purrr::chuck("assets", "data", "href") |>
    purrr::map(\(uri) {arrow::read_parquet(file = uri,
                                           as_data_frame = FALSE)})

  # arrow::concat_tables() expects different objects as arguments, so we can't
  # directly pass a list

  metadata <- rlang::exec(arrow::concat_tables, !!!arrow_tables) |>
    dplyr::filter(...) |>
    dplyr::collect()

  # Release arrow memory ----------------------------------------------------

  # Because arrow uses it's own memory allocation, not the one from R, R will
  # not automatically release the used RAM by arrow.

  rm(arrow_tables)
  # Return the metadata -----------------------------------------------------
  metadata
}

#' Read data from the STAC catalogue, either from metadata or from parquet dumps
#'
#' @param function_identity The identity of the function call to replicate.
#' @param payload The query arguments to pass to the function call.
#'
#' @returns The output of the function call identified by `function_identity`
#'   with the provided `payload` as query arguments.
#'
#' @family parquet helpers
#' @noRd
#'
#' @examples
#' read_stac("list_acoustic_project_codes")
#' read_stac("get_acoustic_deployments",
#'           payload = list(receiver_id = "VR2TX-483009"))
#' read_stac("get_acoustic_receivers",
#'           payload = list(status = "lost",
#'                          receiver_id = "VR2W-124070"))

read_stac <- function(function_identity = c(
                        "list_acoustic_project_codes",
                        "list_animal_project_codes",
                        "list_cpod_project_codes",
                        "list_acoustic_tag_ids",
                        "list_tag_serial_numbers",
                        "list_animal_ids",
                        "list_deployment_ids",
                        "list_receiver_ids",
                        "list_scientific_names",
                        "list_station_names",

                        "get_acoustic_deployments",
                        "get_acoustic_detections",
                        "get_acoustic_receivers",

                        "get_animals",
                        "get_tags",

                        "get_acoustic_projects",
                        "get_cpod_projects",
                        "get_animal_projects"
                      ),
                      payload = NULL) {
  function_identity <- rlang::arg_match(function_identity)

  stac_result <- switch(function_identity,
    list_acoustic_project_codes = {
      get_public_metadata("projects") |>
        # should this be project_type? See
        # etnservice::list_acoustic_project_codes()
        dplyr::filter(.data$telemetry_type == "Acoustic") |>
        dplyr::pull("project_code") |>
        unique()
    },
    list_animal_project_codes = {
      get_public_metadata("projects") |>
        dplyr::filter(.data$project_type == "animal") |>
        dplyr::pull("project_code") |>
        unique()
    },
    list_cpod_project_codes = {
      get_public_metadata("projects") |>
        dplyr::filter(.data$project_type == "cpod") |>
        dplyr::pull("project_code") |>
        unique()
    },
    list_acoustic_tag_ids = {
      get_public_metadata("tags") |>
        dplyr::filter(!is.na(.data$tag_id)) |>
        dplyr::pull("tag_id")
    },
    list_tag_serial_numbers = {
      get_public_metadata("tags") |>
        dplyr::filter(!is.na(.data$tag_serial_number)) |>
        dplyr::pull("tag_serial_number")
    },
    list_animal_ids = {
      get_public_metadata("animals") |>
        dplyr::pull("animal_id") |>
        unique()
    },
    list_deployment_ids = {
      get_public_metadata("deployments") |>
        dplyr::pull("deployment_id") |>
        unique()
    },
    list_receiver_ids = {
      get_public_metadata("receivers") |>
        dplyr::pull("receiver_id") |>
        unique()
    },
    list_scientific_names = {
      get_public_metadata("animals") |>
        dplyr::filter(!is.na(.data$scientific_name)) |>
        dplyr::pull("scientific_name") |>
        unique()
    },
    list_station_names = {
      get_public_metadata("deployments") |>
        dplyr::filter(!is.na(.data$station_name)) |>
        dplyr::pull("station_name") |>
        unique()
    },
    get_acoustic_deployments = {
      get_public_metadata("deployments") |>
        dplyr::filter(!!!arg_to_filter_expression(payload))
    },
    get_acoustic_detections = {
      # TODO: implement get_public_detections()
    },
    get_acoustic_receivers = {
      get_public_metadata("receivers") |>
        dplyr::filter(!!!arg_to_filter_expression(payload))
    },
    get_acoustic_projects = {
      get_public_metadata("projects") |>
        dplyr::filter(.data$project_type == "acoustic") |>
        dplyr::filter(!!!arg_to_filter_expression(payload))
    },
    get_cpod_projects = {
      get_public_metadata("projects") |>
        dplyr::filter(.data$project_type == "cpod") |>
        dplyr::filter(!!!arg_to_filter_expression(payload))
    },
    get_animal_projects = {
      get_public_metadata("projects") |>
        dplyr::filter(.data$project_type == "animal") |>
        dplyr::filter(!!!arg_to_filter_expression(payload))
    }
  )

  # Sort the returned values ------------------------------------------------

  if(is.vector(stac_result)){
    stringr::str_sort(stac_result, numeric = TRUE)
  } else {
    stac_result
  }

}
