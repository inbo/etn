# cached version of API response for 2014_demer
vcr::use_cassette("2014_demer_dwc",
                  {
  # Request without writing to disk
  demer_dwc <- write_dwc(
    animal_project_code = "2014_demer",
    directory = NULL,
    api = TRUE
  )

  test_that("write_dwc() can write csv files to a path", {
    out_dir <- file.path(tempdir(), "dwc")
    unlink(out_dir, recursive = TRUE)
    dir.create(out_dir)
    # Request that writes to disk
    suppressMessages(write_dwc(
      animal_project_code = "2014_demer",
      directory = out_dir,
      api = TRUE
    ))

    expect_identical(list.files(out_dir, pattern = "*.csv"),
                     "dwc_occurrence.csv")
  })

  test_that("write_dwc() can return data as list of tibbles rather than files",
            {
              expect_identical(names(demer_dwc), "dwc_occurrence")
              expect_s3_class(demer_dwc$dwc_occurrence, "tbl")
            })

  test_that("write_dwc() returns the expected Darwin Core terms as columns",
            {
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
})
