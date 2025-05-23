skip_if_not_localdb()

con <- connect_to_etn()

test_that("write_dwc() can write csv files to a path", {
  out_dir <- file.path(tempdir(), "dwc")
  unlink(out_dir, recursive = TRUE)
  dir.create(out_dir)
  suppressMessages(
    write_dwc(con, animal_project_code = "2014_demer", directory = out_dir)
  )

  expect_identical(
    list.files(out_dir, pattern = "*.csv"),
    "dwc_occurrence.csv"
  )
})

test_that("write_dwc() can return data as list of tibbles rather than files", {
  result <- suppressMessages(
    write_dwc(con, animal_project_code = "2014_demer", directory = NULL)
  )

  expect_identical(names(result), "dwc_occurrence")
  expect_s3_class(result$dwc_occurrence, "tbl")
})

test_that("write_dwc() returns the expected Darwin Core terms as columns", {
  result <- suppressMessages(
    write_dwc(con, animal_project_code = "2014_demer", directory = NULL)
  )

  expect_identical(
    colnames(result$dwc_occurrence),
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
      "scientificNameID",
      "scientificName",
      "kingdom"
    )
  )
})

test_that("write_dwc() supports uppercase animal_project_codes", {
  result <- suppressMessages(
    write_dwc(con, animal_project_code = "2011_RIVIERPRIK", directory = NULL)
  )

  expect_identical(names(result), "dwc_occurrence")
  expect_s3_class(result$dwc_occurrence, "tbl")
  expect_gte(length(result$dwc_occurrence$occurrenceID), 1)
})


test_that("write_dwc() allows setting of rights_holder", {
  result <- suppressMessages(
    write_dwc(con,
              animal_project_code = "2014_demer",
              rights_holder = "my_rightholder",
              directory = NULL)
  )

  expect_identical(
    unique(result$dwc_occurrence$rightsHolder),
    "my_rightholder"
  )
})

test_that("write_dwc() returns an empty column for rights holder by default", {
  result <- suppressMessages(
    write_dwc(con,
              animal_project_code = "2014_demer",
              directory = NULL)
  )

  expect_identical(
    unique(result$dwc_occurrence$rightsHolder),
    NA_character_
  )
})
