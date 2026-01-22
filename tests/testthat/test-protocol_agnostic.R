# This file contains tests that verify that certain listing functions in the ETN
# package return identical results regardless of whether they are using the API
# or a local database connection.

# Test if listing functions are protocol agnostic -------------------------

# All these functions use similar internal referring to either simple API calls
# or etnservice. Thus I'd expect them to either all pass, or all fail, as long
# as etnservice is the same version locally on the test machine and deployed on
# OpenCPU
test_that("list_animal_project_codes() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_animal_project_codes())
})

test_that("list_acoustic_project_codes() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_acoustic_project_codes())
})

test_that("list_animal_ids() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_animal_ids())
})

test_that("list_tag_serial_numbers() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_tag_serial_numbers())
})

test_that("list_station_names() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_station_names())
})

test_that("list_scientific_names() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_scientific_names())
})

test_that("list_receiver_ids() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_receiver_ids())
})

test_that("list_cpod_project_codes() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_cpod_project_codes())
})

test_that("list_deployment_ids() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(list_deployment_ids())
})

# get_acoustic_detections -------------------------------------------------

# get_acoustic_detections() has internal logic, and should be tested in more
# detail.
test_that("get_acoustic_detections() returns identical results on limit", {
  expect_protocol_agnostic(get_acoustic_detections(limit = TRUE))
})

test_that("get_acoustic_detections() returns identical results on big query", {
  expect_protocol_agnostic(
    get_acoustic_detections(animal_project_code = "2011_Warnow")
  )
})

test_that("get_acoustic_detections() returns identical results for multiple stations", {
  expect_protocol_agnostic(
    get_acoustic_detections(
      acoustic_tag_id = "A69-1601-16130",
      station_name = c("de-9", "de-10")
    )
  )
})

test_that("get_acoustic_detections() returns identical results for multiple tag IDs", {
  expect_protocol_agnostic(
    get_acoustic_detections(
      acoustic_tag_id = c("A69-1601-16130", "A69-1601-16131"),
      station_name = "de-9"
    )
  )
})

test_that("get_acoustic_detections() returns identical results for multiple args", {
  # scientific_name, receiver_id, acoustic_project_code
  expect_protocol_agnostic(
    get_acoustic_detections(
      scientific_name = "Rutilus rutilus",
      receiver_id = "VR2W-124070",
      acoustic_project_code = "demer"
    )
  )

  # animal_project_code, start_date, end_date
  expect_protocol_agnostic(
    get_acoustic_detections(
      animal_project_code = "2014_demer",
      start_date = "2015-04",
      end_date = "2015-05"
    )
  )

  # tag_serial_number animal_project_code receiver_id
  expect_protocol_agnostic(
    get_acoustic_detections(
      tag_serial_number = "1283964",
      animal_project_code = "Carp_markermeer",
      receiver_id = "VR2W-133054"
    )
  )
})

# get_cpod_projects -------------------------------------------------------

test_that("get_cpod_projects() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(get_cpod_projects())
})

# get_animal_projects -----------------------------------------------------

test_that("get_animal_projects() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(get_animal_projects())
})

# get_acoustic_projects ---------------------------------------------------

test_that("get_acoustic_projects() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(get_acoustic_projects())
})

# get_animals -------------------------------------------------------------

test_that("get_animals() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(get_animals())
})

# get_tags ----------------------------------------------------------------

test_that("get_tags() returns identical results independent of the used protocol", {
  expect_protocol_agnostic(get_tags())
})
