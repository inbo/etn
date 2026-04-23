test_that("get_package() errors on invalid animal_project_code length", {
  expect_error(
    get_package(c("2014_demer", "another dataset")),
    class = "etn_error_multiple_animal_project_code"
  )
})

test_that("get_package() returns a valid package", {
  skip_if_no_authentication()
  vcr::local_cassette("package_demer")

  package <- suppressMessages(get_package("2014_demer"))
  expect_no_error(suppressMessages(frictionless::check_package(package)))
})

test_that("get_package() creates the expected package", {
  skip_if_no_authentication()
  vcr::local_cassette("package_demer")

  datapackage_path <- withr::local_tempdir(pattern = "2014_demer")
  package <- suppressMessages(get_package("2014_demer"))
  write_package(package, datapackage_path)
  files_to_create <- c(
    "animals.csv",
    "tags.csv",
    "detections.csv",
    "deployments.csv",
    "receivers.csv",
    "references.csv",
    "datapackage.json"
  )

  # Function creates the expected files
  expect_true(all(files_to_create %in% list.files(datapackage_path)))
  expect_snapshot_file(file.path(datapackage_path, "datapackage.json"))
  expect_snapshot_file(file.path(datapackage_path, "animals.csv"))
  expect_snapshot_file(file.path(datapackage_path, "tags.csv"))
  expect_snapshot_file(file.path(datapackage_path, "detections.csv"))
  expect_snapshot_file(file.path(datapackage_path, "deployments.csv"))
  expect_snapshot_file(file.path(datapackage_path, "receivers.csv"))
  expect_snapshot_file(file.path(datapackage_path, "references.csv"))
})

test_that("get_package() sets dataset_id when doi is missing", {
  skip_if_no_authentication()
  vcr::local_cassette("package_ESGL")

  package <- suppressMessages(get_package("ESGL"))
  expect_equal(package$id, "https://marineinfo.org/id/dataset/6291")
})
