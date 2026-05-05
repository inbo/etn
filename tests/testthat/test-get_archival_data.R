test_that("get_archival_data() can filter on tag_serial_number", {
  expect_identical(
    get_archival_data(tag_serial_number = "A15757") |>
      dplyr::pull("tag_id") |>
      unique(),
    "A15757"
  )
})

test_that("get_archival_data() returns a tibble", {
  expect_s3_class(
    get_archival_data(tag_serial_number = "A15757"),
    "tbl"
  )
})
 expect_s3_class(
    get_archival_data(tag_serial_number = "A15757"),
    "tbl"
  )
test_that("get_archival_data() returns the expected fields", {
expect_named(get_archival_data(tag_serial_number = "A15757"),
             c("tag_id",
               "timestamp_utc",
               "measurement_type",
               "measurement_value",
               "measurement_unit",
               "tag_serial_number",
               "animal_id",
               "animal_project_code"))
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

test_that("get_archival_data() is case insensitive for animal_project_code", {

})

test_that("get_archival_data() returns error on invalid animal_project_code", {

})
