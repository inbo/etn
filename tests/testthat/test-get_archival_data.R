test_that("get_archival_data() returns a tibble by default", {
  expect_s3_class(
    get_archival_data(tag_serial_number = "A15757"),
    "tbl"
  )
})

test_that("get_archival_data() can return an arrow datasetquery", {
  expect_s3_class(
    get_archival_data(tag_serial_number = "A15757", return_as = "arrow"),
    "arrow_dplyr_query"
  )
})

test_that("get_archival_data() returns the expected fields", {
  expect_named(
    get_archival_data(tag_serial_number = "A15757"),
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
      get_archival_data(tag_serial_number = "A15757"),
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
  archival_data <- get_archival_data()
  expect_all_false(
    is.na()
  )
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
    get_archival_data(tag_serial_number = "A15757") |>
      dplyr::pull("tag_id") |>
      unique(),
    "A15757"
  )
})

test_that("get_archival_data() can filter on animal_id", {
  expect_identical(
    get_archival_data(animal_id = 18113) |>
      dplyr::pull("animal_id") |>
      unique(),
    18113L
  )
})

test_that("get_archival_data() can filter on animal_project_code", {
  skip("THIS WILL CRASH YOUR SESSION")
  expect_identical(
    get_archival_data(animal_project_code = "2018_EC") |>
      dplyr::pull("animal_project_code") |>
      unique(),
    "2018_EC"
  )
})

test_that("get_archival_data() is case insensitive for animal_project_code", {})

test_that("get_archival_data() returns error on invalid animal_project_code", {})

