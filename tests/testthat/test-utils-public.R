
# read_catalog() ----------------------------------------------------------
test_that("read_catalog() returns a list", {
  expect_type(read_catalog(), "list")
})

test_that("read_catalog() returns expected list elements", {
  expect_named(
    read_catalog(),
    c("type", "id", "stac_version", "description", "links", "title")
  )
})

# read_child_catalog() ----------------------------------------------------
test_that("read_child_catalog() returns a list", {
  expect_type(read_child_catalog(catalog = "metadata_files"), "list")
  expect_type(read_child_catalog(catalog = "detection_files"), "list")
  expect_type(read_child_catalog(catalog = "archival_files"), "list")
})

test_that("read_child_catalog() returns expected list elements", {
  expect_named(
    read_child_catalog(catalog = "metadata_files"),
    c("type", "id", "stac_version", "description", "links", "extent",
      "license")
  )
  expect_named(
    read_child_catalog(catalog = "detection_files"),
    c("type", "id", "stac_version", "description", "links", "extent",
      "license")
  )
  expect_named(
    read_child_catalog(catalog = "archival_files"),
    c("type", "id", "stac_version", "description", "links", "extent",
      "license")
  )
})

# list_public_detections() ------------------------------------------------
test_that("list_public_detections() returns public animal_project_codes", {
  expect_in(
    list_public_detections()$project_code,
    list_animal_project_codes()
  )
})

test_that("list_public_detections() returns all available projects", {
  skip("Not all public animal projects have been dumped to parquet")

  # Fetch non-moratorium animal_projects_codes from the database
  public_animal_projects <-
    dplyr::filter(get_animal_projects(), !.data$moratorium) |>
    dplyr::pull("project_code")

  expect_length(
    list_public_detections()$project_code,
    length(public_animal_projects)
  )
})

test_that("list_public_detections() returns paths to resource json metadata", {
  expect_named(
    list_public_detections(),
    c(
      "project_code",
      "path"
    )
  )
})

# get_public_detections() -------------------------------------------------
test_that("get_public_detections() can combine multiple animal_projects", {
  expect_type(
    get_public_detections(c("OTN-Hemnfjorden", "DAK")),
    "list"
    )
})

test_that("get_public_detections() can pass filter arguments", {
  # project with mutliple species
  expect_type(
    get_public_detections(
      "2011_Warnow",
      animal_scientific_name == "Anguilla rostrata"
    ),
    "list"
  )
})

test_that("get_public_detections() works with animal_project = NULL", {
  # Even without providing an animal_project_code, the function should still be
  # able to fetch detections
  expect_type(
    get_public_detections(
      project_code = NULL,
      animal_scientific_name == "Lampetra fluviatilis"
    ),
    "list"
  )
})

test_that("get_public_detections() supports same arg names as get_acoustic_detections()", {
    # Rerun `get_acoustic_detections()` tests but with protocol forced to
    # public?
})

test_that("get_public_detections() supports limiting to 100 rows", {
  expect_shape(
    # This project has much more than 100 rows.
    get_public_detections(project_code = "2013_albertkanaal",
                          limit = TRUE),
    nrow = 100L
  )
})
# get_public_metadata() ---------------------------------------------------


# read_stac() -------------------------------------------------------------

test_that("read_stac() results should not include NA on list_x identities", {
  list_identities <-
    formals(read_stac)$function_identity |>
    as.character() |>
    purrr::keep(.p = ~ stringr::str_starts(.x, stringr::fixed("list_")))
  for (list_function in list_identities) {
    expect_false(anyNA(
      read_stac(function_identity = list_function)
    ))
  }
})

test_that("read_stac() returns natural sorting for list_x identities", {
  list_identities <-
    formals(read_stac)$function_identity |>
    as.character() |>
    purrr::keep(.p = ~ stringr::str_starts(.x, stringr::fixed("list_")))
  for (list_function in list_identities) {
    expect_equal(
      read_stac(function_identity = list_function),
      stringr::str_sort(read_stac(function_identity = list_function),
                        numeric = TRUE)
    )
  }
})

test_that("read_stac() supports all exported functions", {
  exported_functions <- getNamespaceExports("etn") |>
    purrr::keep(~ dplyr::when_any(
      stringr::str_starts(.x, stringr::fixed("get_")),
      stringr::str_starts(.x, stringr::fixed("list_"))
    )) |>
    # Except list_values(), which isn't a data fetching function.
    purrr::discard(.p = ~.x == "list_values")

  supported_functions <- as.character(formals(read_stac)$function_identity) |>
    # Except c(), which isn't an etn function
    purrr::discard(.p = ~.x == "c")

  expect_setequal(
    supported_functions,
    exported_functions
  )
})

test_that("read_stac() supports vectors as payload to filter on", {
  expect_type(
    read_stac("get_acoustic_receivers",
      payload = list(status = c("lost", "broken"))
    ),
    "list"
  )
})

test_that("read_stac() correctly forwards multiple payload members", {
  # Multiple members should be forwarded as AND queries, vectors within a single
  # member are OR queries

  # This query should return more rows than the same query with an additional
  # filter
  expect_gt(
    nrow(read_stac("get_acoustic_deployments",
      payload = list(receiver_id = "VR2W-111604")
    )),
    nrow(read_stac("get_acoustic_deployments",
      payload = list(
        receiver_id = "VR2W-111604",
        deployment_id = "93099"
      )
    ))
  )

  # This query should return less rows than the same query with an additional
  # allowed value
  expect_lt(
    nrow(read_stac("get_acoustic_receivers",
      payload = list(status = "lost")
    )),
    nrow(read_stac("get_acoustic_receivers",
      payload = list(status = c("lost", "broken"))
    ))
  )
})

test_that("read_stac() supports public detection queries", {
  # These type of queries are more complex because they read the detections
  # parquet instead of public metadata.

  skip("detections currently unsupported")

  expect_type(
    read_stac("get_acoustic_detections",
      payload = list(
        project_code = "2013_albertkanaal",
        animal_scientific_name = "Anguilla anguilla"
      )
    ),
    "list"
  )
})
