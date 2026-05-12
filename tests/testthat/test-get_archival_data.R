test_that("get_archival_data() returns a tibble by default", {
  expect_s3_class(
    get_archival_data(limit = TRUE),
    "tbl"
  )
})

test_that("get_archival_data() can return an arrow datasetquery", {
  expect_s3_class(
    get_archival_data(return_as = "arrow",
                      limit = TRUE),
    "arrow_dplyr_query"
  )
})

test_that("get_archival_data() returns the expected fields", {
  expect_named(
    get_archival_data(tag_serial_number = "A15757",
                      limit = TRUE),
    c(
      "tag_id",
      "timestamp_utc",
      "measurement_type",
      "measurement_value",
      "measurement_unit",
      "animal_project_code",
      "animal_id",
      "tag_serial_number"
    )
  )
})

test_that("get_archival_data() returns the expected column classes", {
  expect_identical(
    purrr::map(
      get_archival_data(tag_serial_number = "A15757",
                        limit = TRUE),
      class
    ),
    list(
      tag_id = "character",
      timestamp_utc = c("POSIXct", "POSIXt"),
      measurement_type = "character",
      measurement_value = "numeric",
      measurement_unit = "character",
      animal_project_code = "character",
      animal_id = "integer",
      tag_serial_number = "character"
    )
  )
})

test_that("get_archival_data() has values for identifier columns", {
  # These columns are fetched via get_archival_data_uuid() from a database view,
  # and should never be empty.
  archival_data <- get_archival_data(tag_serial_number = "A15757",
                                     limit = TRUE)
  expect_all_false(is.na(archival_data$tag_serial_number))
  expect_all_false(is.na(archival_data$animal_id))
  expect_all_false(is.na(archival_data$animal_project_code))
})

test_that("get_archival_data() returns error on no archival data found", {
  expect_error(
    # This tag does not have archival data as of writing this test.
    get_archival_data(tag_serial_number = "A19163"),
    class = "archival_data_not_found"
  )

  # But it should return the remaining data if only some tags have no data

})

test_that("get_archival_data() can filter on tag_serial_number", {
  expect_identical(
    get_archival_data(tag_serial_number = "A15757",
                      limit = TRUE) |>
      dplyr::pull("tag_serial_number") |>
      unique(),
    "A15757"
  )
})

test_that("get_archival_data() can filter on animal_id", {
  expect_identical(
    get_archival_data(animal_id = 18113,
                      limit = TRUE) |>
      dplyr::pull("animal_id") |>
      unique(),
    18113L
  )
})

test_that("get_archival_data() can filter on animal_project_code", {
  expect_identical(
    get_archival_data(animal_project_code = "2018_EC", limit = TRUE) |>
      dplyr::pull("animal_project_code") |>
      unique(),
    "2018_EC"
  )
})

test_that("get_archival_data() returns 100 rows when limit is set", {
  expect_shape(
    get_archival_data(animal_project_code = "2018_EC", limit = TRUE),
    nrow = 100L
  )
})

test_that("get_archival_data() is case insensitive for animal_project_code", {
  expect_identical(
    get_archival_data(animal_project_code = "Lumpfish", limit = TRUE),
    get_archival_data(animal_project_code = "LUMPFISH", limit = TRUE)
  )
})

test_that("get_archival_data() returns error on invalid animal_project_code", {
  expect_error(
    get_archival_data(animal_project_code = "not_an_animal_project_code"),
    regexp = "Can't find animal_project_code",
    fixed = FALSE
  )
})

test_that("get_archival_data() can write out to a path", {
  loc_tempdir <- withr::local_tempdir()

  get_archival_data(tag_serial_number = "A15757", path = loc_tempdir)
  # Assume that if the files in the folder created for this test have the right
  # header, they are the right files.
  csv_files_to_test <- list.files(loc_tempdir, full.names = TRUE)
  csv_files_to_test |>
    purrr::map(
      \(file_to_test){
        readr::read_csv(file_to_test, n_max = 2, show_col_types = FALSE) |>
          expect_named(
            c(
              "tag_id",
              "timestamp_utc",
              "measurement_type",
              "measurement_value",
              "measurement_unit"
            )
          )
      }
    )
})
