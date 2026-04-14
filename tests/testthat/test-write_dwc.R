test_that("write_dwc() returns error on missing or wrong license", {
  temp_dir <- tempdir()
  on.exit(unlink(temp_dir, recursive = TRUE))

  expect_error(
    suppressMessages(write_dwc(example_dataset(), temp_dir, license = NULL))
  )
  expect_error(
    suppressMessages(write_dwc(example_dataset(), temp_dir, license = "bla"))
  )
})

test_that("write_dwc() returns error on missing resources", {
  temp_dir <- tempdir()
  on.exit(unlink(temp_dir, recursive = TRUE))

  # Create datasets with missing resource
  x_no_animals_data <-
    frictionless::remove_resource(example_dataset(), "animals")
  x_no_tags <- frictionless::remove_resource(example_dataset(), "tags")
  x_no_detections <-
    frictionless::remove_resource(example_dataset(), "detections")
  x_no_deployments <-
    frictionless::remove_resource(example_dataset(), "deployments")

  expect_error(
    suppressMessages(write_dwc(x_no_animals_data, temp_dir)),
    class = "etn_error_animals_data_missing"
  )
  expect_error(
    suppressMessages(write_dwc(x_no_tags, temp_dir)),
    class = "etn_error_tags_data_missing"
  )
  expect_error(
    suppressMessages(write_dwc(x_no_detections, temp_dir)),
    class = "etn_error_detections_data_missing"
  )
  expect_error(
    suppressMessages(write_dwc(x_no_deployments, temp_dir)),
    class = "etn_error_deployments_data_missing"
  )
})

test_that("write_dwc() writes CSV and meta.xml files to a directory and
           a list of data frames invisibly", {
  temp_dir <- tempdir()
  on.exit(unlink(temp_dir, recursive = TRUE))
  result <- suppressMessages(write_dwc(example_dataset(), temp_dir))

  expect_contains(
    list.files(temp_dir),
    c("meta.xml", "occurrence.csv")
  )
  expect_identical(names(result), c("occurrence"))
  expect_s3_class(result$occurrence, "tbl")
  expect_invisible(suppressMessages(write_dwc(example_dataset(), temp_dir)))
})

test_that("write_dwc() returns the expected Darwin Core terms as columns", {
  temp_dir <- tempdir()
  on.exit(unlink(temp_dir, recursive = TRUE))
  result <- suppressMessages(write_dwc(example_dataset(), temp_dir))

  expect_identical(
    colnames(result$occurrence),
    c(
      "type",
      "license",
      "rightsHolder",
      "datasetID",
      "institutionCode",
      "collectionCode",
      "datasetName",
      "basisOfRecord",
      "dataGeneralizations",
      "occurrenceID",
      "sex",
      "lifeStage",
      "occurrenceStatus",
      "organismID",
      "organismName",
      "eventID",
      "parentEventID",
      "eventDate",
      "samplingProtocol",
      "eventRemarks",
      "locationID",
      "locality",
      "decimalLatitude",
      "decimalLongitude",
      "geodeticDatum",
      "coordinateUncertaintyInMeters",
      "identificationVerificationStatus",
      "scientificNameID",
      "scientificName",
      "kingdom"
    )
  )
})

test_that("write_dwc() returns the expected Darwin Core mapping for the example
           dataset", {
  temp_dir <- tempdir()
  on.exit(unlink(temp_dir, recursive = TRUE))
  suppressMessages(
    write_dwc(
      example_dataset(),
      temp_dir,
      dataset_id = "https://doi.org/10.14284/432",
      dataset_name = paste(
        "2014_DEMER - Acoustic telemetry data for four fish species in the",
        "Demer river (Belgium)"
      ),
      rights_holder = "INBO",
      license = "CC0-1.0"
    )
  )

  expect_snapshot_file(file.path(temp_dir, "occurrence.csv"))
  expect_snapshot_file(file.path(temp_dir, "meta.xml"))
})

test_that("write_dwc() returns files that comply with the info in meta.xml", {
  temp_dir <- tempdir()
  on.exit(unlink(temp_dir, recursive = TRUE))
  suppressMessages(write_dwc(package = example_dataset(), directory = temp_dir))

  # Use helper function to compare
  expect_meta_match(file.path(temp_dir, "occurrence.csv"))
})

test_that("write_dwc() supports datasets that only have the required fields", {
  temp_dir <- tempdir()
  on.exit(unlink(temp_dir, recursive = TRUE))

  # Create minimal dataset with required fields only
  detections_minimal <-
    frictionless::read_resource(example_dataset(), "detections") |>
    dplyr::select(
      "detection_id", "tag_serial_number", "animal_id", "date_time",
      "deployment_id", "scientific_name", "receiver_id", "deploy_latitude",
      "deploy_longitude"
    )
  animals_minimal <-
    frictionless::read_resource(example_dataset(), "animals") |>
    dplyr::select(
      "animal_id", "scientific_name", "aphia_id", "tag_serial_number"
    )
  tags_minimal <-
    frictionless::read_resource(example_dataset(), "tags") |>
    dplyr::select("tag_serial_number")
  deployments_minimal <-
    frictionless::read_resource(example_dataset(), "deployments") |>
    dplyr::select("deployment_id")
  x_minimal <-
    example_dataset()|>
    frictionless::add_resource(
      "detections", detections_minimal,
      replace = TRUE
    ) |>
    frictionless::add_resource("animals", animals_minimal, replace = TRUE) |>
    frictionless::add_resource("tags", tags_minimal, replace = TRUE) |>
    frictionless::add_resource(
      "deployments", deployments_minimal,
      replace = TRUE
    )

  expect_no_error(suppressMessages(write_dwc(x_minimal, temp_dir)))
})
