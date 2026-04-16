
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


# get_public_detections() -------------------------------------------------


# get_public_metadata() ---------------------------------------------------


