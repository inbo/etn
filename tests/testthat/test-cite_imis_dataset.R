test_that("cite_imis_dataset() returns a tibble", {
  skip_if_offline("marineinfo.org")

  expect_s3_class(
    cite_imis_dataset(imis_dataset_ids = 8296),
    "tbl_df"
  )
})

test_that("cite_imis_dataset() returns expected columns", {
  skip_if_offline("marineinfo.org")

  expect_named(
    cite_imis_dataset(imis_dataset_ids = 7915),
    c("imis_dataset_id", "citation", "doi", "name", "email", "institute")
  )
})

test_that("cite_imis_dataset() returns remaining data if some provided ids are NA", {
  skip_if_offline("marineinfo.org")

  expect_identical(
    nrow(cite_imis_dataset(
      imis_dataset_ids = c(NA, 8468, 5929)
    )),
    2L
  )
})

test_that("cite_imis_dataset() returns a 0 row tibble early on missing id", {
  # No internet is actually needed for this test.

  # Still return the columns
  expect_length(
    cite_imis_dataset(imis_dataset_ids = NA),
    6L
  )

  # Return 0 row tibble.
  expect_identical(
    nrow(cite_imis_dataset(imis_dataset_ids = NA)),
    0L
  )
})

test_that("cite_imis_dataset() returns DOI for known dataset with DOI", {
  skip_if_offline("marineinfo.org")

  expect_identical(
    # acoustic_project_code: 2004_gudena has a DOI
    cite_imis_dataset(imis_dataset_ids = 8856)$doi,
    "10.14284/735"
  )
})

test_that("cite_imis_dataset() can append doi to citation if available", {
  skip_if_offline("marineinfo.org")

  expect_true(
    stringr::str_ends(
      cite_imis_dataset(imis_dataset_ids = 8856),
      stringr::fixed("10.14284/735")
    )
  )
})

test_that("cite_imis_dataset() doesn't append doi prefix or suffix when there is no DOI", {
  skip_if_offline("marineinfo.org")

})

test_that("cite_imis_dataset() can handle getting all citations in a single call", {
  skip_if_no_authentication()
  skip_if_offline("marineinfo.org")

  all_imis_dataset_codes <- get_acoustic_projects()$imis_dataset_id

  expect_identical(
    nrow(cite_imis_dataset(all_imis_dataset_codes)),
    length(all_imis_dataset_codes)
  )
})
