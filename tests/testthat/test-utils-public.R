
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

})

# get_public_metadata() ---------------------------------------------------


