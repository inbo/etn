test_that("[SQL] write_dwc() can write csv files to a path", {
  skip_if_not_localdb()

  out_dir <- file.path(tempdir(), "dwc")
  unlink(out_dir, recursive = TRUE)
  dir.create(out_dir)
  suppressMessages(
    write_dwc(animal_project_code = "2014_demer", directory = out_dir, api = FALSE)
  )

  expect_identical(
    list.files(out_dir, pattern = "*.csv"),
    "dwc_occurrence.csv"
  )
})

test_that("[SQL] write_dwc() can return data as list of tibbles rather than files", {
  skip_if_not_localdb()

  result <- suppressMessages(
    write_dwc(animal_project_code = "2014_demer", directory = NULL, api = FALSE)
  )

  expect_identical(names(result), "dwc_occurrence")
  expect_s3_class(result$dwc_occurrence, "tbl")
})

test_that("[SQL] write_dwc() returns the expected Darwin Core terms as columns", {
  skip_if_not_localdb()
  
  result <- suppressMessages(
    write_dwc(animal_project_code = "2014_demer", directory = NULL, api = FALSE)
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

# cached version of API response for 2014_demer
vcr::use_cassette("2014_demer_dwc", {
  # Request without writing to disk
  demer_dwc <- write_dwc(animal_project_code = "2014_demer",
                         directory = NULL,
                         api = TRUE)

  test_that("[API] write_dwc() can write csv files to a path", {
    out_dir <- file.path(tempdir(), "dwc")
    unlink(out_dir, recursive = TRUE)
    dir.create(out_dir)
    # Request that writes to disk
    suppressMessages(write_dwc(
      animal_project_code = "2014_demer",
      directory = out_dir,
      api = TRUE
    ))

    expect_identical(list.files(out_dir, pattern = "*.csv"), "dwc_occurrence.csv")
  })

  test_that("[API] write_dwc() can return data as list of tibbles rather than files", {
    expect_identical(names(demer_dwc), "dwc_occurrence")
    expect_s3_class(demer_dwc$dwc_occurrence, "tbl")
  })

  test_that("[API] write_dwc() returns the expected Darwin Core terms as columns", {
    expect_identical(
      colnames(demer_dwc$dwc_occurrence),
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
test_that("[SQL] write_dwc() supports uppercase animal_project_codes", {
  skip_if_not_localdb()
  result <- suppressMessages(
    write_dwc(animal_project_code = "2011_RIVIERPRIK", directory = NULL)
  )

  expect_identical(names(result), "dwc_occurrence")
  expect_s3_class(result$dwc_occurrence, "tbl")
  expect_gte(length(result$dwc_occurrence$occurrenceID), 1)
})


test_that("[SQL] write_dwc() allows setting of rights_holder", {
  skip_if_not_localdb()
  result <- suppressMessages(
    write_dwc(animal_project_code = "2014_demer",
              rights_holder = "my_rightholder",
              directory = NULL)
  )

  expect_identical(
    unique(result$dwc_occurrence$rightsHolder),
    "my_rightholder"
  )
})

test_that("[SQL] write_dwc() returns an empty column for rights holder by default", {
  skip_if_not_localdb()
  result <- suppressMessages(
    write_dwc(animal_project_code = "2014_demer",
              directory = NULL)
  )

  expect_identical(
    unique(result$dwc_occurrence$rightsHolder),
    NA_character_
  )
})
