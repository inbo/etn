
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
  expect_in(
    list_public_detections(),
    "path"
  )
})

# get_public_detections() -------------------------------------------------


# get_public_metadata() ---------------------------------------------------


