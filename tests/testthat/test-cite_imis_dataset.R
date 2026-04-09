test_that("cite_imis_dataset() returns a tibble", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-8296")

  expect_s3_class(
    cite_imis_dataset(imis_dataset_ids = 8296),
    "tbl_df"
  )
})

test_that("cite_imis_dataset() can handle multiple datasets at a time",{
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-multiple")

  expect_identical(
    nrow(cite_imis_dataset(imis_dataset_ids = c(8296, 7915))),
    2L
  )
})

test_that("cite_imis_dataset() returns expected columns", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-7915")

  expect_named(
    cite_imis_dataset(imis_dataset_ids = 7915),
    c("imis_dataset_id", "citation", "doi", "name", "email", "institute")
  )
})

test_that("cite_imis_dataset() returns remaining data if some provided ids are NA", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-one-missing")

  expect_identical(
    nrow(cite_imis_dataset(
      imis_dataset_ids = c(NA, 8468, 5929)
    )),
    2L
  )
})

test_that("cite_imis_dataset() returns empty fields on missing `ownerships`", {
  # When MarineInfo/IMIS doesn't contain any ownerships information, return
  # empty columns

  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-7970")

  expect_identical(
    cite_imis_dataset(imis_dataset_ids = 7970) |>
      dplyr::select(dplyr::all_of(c("dataname", "email", "institute"))),
    dplyr::tibble(
      name = NA_character_,
      email = NA_character_,
      institute = NA_character_
    )
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

  vcr::local_cassette("citations-8856")

  expect_identical(
    # acoustic_project_code: 2004_gudena has a DOI
    cite_imis_dataset(imis_dataset_ids = 8856)$doi,
    "10.14284/735"
  )
})

test_that("cite_imis_dataset() can append doi to citation if available", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-8859")

  expect_true(
    stringr::str_ends(
      cite_imis_dataset(imis_dataset_ids = 8859)$citation,
      stringr::fixed("10.14284/744.")
    )
  )
})

test_that("cite_imis_dataset() doesn't append doi prefix or suffix when there is no DOI", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-no-doi")

  expect_no_match(
    cite_imis_dataset(imis_dataset_ids = 6336)$citation,
    "doi"
  )
})

test_that("cite_imis_dataset() doesn't convert a missing citation into a dot", {
  skip_if_offline("marineinfo.org")

   vcr::local_cassette("citations-5877")

  # Previous bug in citation and doi collation

  # A missing citation should be returned as NA
  expect_identical(
    cite_imis_dataset(5877)$citation,
    NA_character_
  )
})

test_that("cite_imis_dataset() converts `n.a.` citations into NA", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-na-conv")

  expect_no_match(cite_imis_dataset(6331)$citation, "n\\.a\\.")
  expect_no_match(cite_imis_dataset(6328)$citation, "n\\.a\\.")
  expect_no_match(cite_imis_dataset(6329)$citation, "n\\.a\\.")
})

test_that("cite_imis_dataset() removes html tags from citations", {
  # Some citations have html formatting embedded eg: <i>example</i>
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-html")

  expect_no_match(
    cite_imis_dataset(6336)$citation,
    "<[a-z]+>.+</[a-z]+>"
  )

  expect_no_match(
    cite_imis_dataset(8536)$citation,
    "<[a-z]+>.+</[a-z]+>"
  )
})

test_that("cite_imis_dataset() doesn't introduce encoding issues in citations", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-encoding")

  # skip("Encoding issue on the API ISSUE#521")

  # Compare against known group of citations of which some showed encoding
  # issues
  expect_snapshot(
    cite_imis_dataset(imis_dataset_ids = c(8856, 6336, 8857, 6333, 6716)) |>
      dplyr::pull("citation")
  )
})

test_that("cite_imis_dataset() doesn't cause encoding issue: all citations", {
  skip_on_ci()
  skip_on_covr()
  skip_if_offline("marineinfo.org")

  # Super-duper snapshot of all possible citations, probably want to remove this
  # one
  expect_snapshot(
    c(get_acoustic_projects()$imis_dataset_id,
      get_animal_projects()$imis_dataset_id) |>
      cite_imis_dataset(warn = FALSE) |>
      dplyr::pull("citation")
  )

})

test_that("cite_imis_dataset() doesn't suffix extra period behind citations", {
  # Some citations end on a period, some do not. A period should be added if a
  # doi is suffixed, except when one is already present.
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-period")

  expect_no_match(
    cite_imis_dataset(8853)$citation,
    "\\.\\.$"
  )
})

test_that("cite_imis_dataset() can forward MarineInfo API errors as warnings", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-api-warning")

  # Some IMIS dataset_id's can't be found on MarineInfo
  expect_warning(
    cite_imis_dataset(imis_dataset_ids = 7934,
                      warn = TRUE),
    class = "marineinfo_api_warning"
  )
})

test_that("cite_imis_dataset() returns 0 a row tibble when all MarineInfo requests fail", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-api-warning")

  expect_identical(
    cite_imis_dataset(imis_dataset_ids = 7934,
                      warn = FALSE),
    dplyr::tibble(
      imis_dataset_id = integer(),
      citation = character(),
      doi = character(),
      name = character(),
      email = character(),
      institute = character()
    )
  )
})

test_that("cite_imis_dataset() can handle getting all citations in a single call", {
  # NOTE: some IMIS dataset_ids result in a 404 on MarineInfo.
  skip_if_no_authentication()
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-all")

  all_imis_acoustic_codes <- get_acoustic_projects() |>
    # Some IMIS dataset_ids will result in a 404 on marineinfo.
    dplyr::pull(imis_dataset_id)

  # Some IMIS dataset_ids will result in a 404 on marineinfo, but we should be
  # able to get most of them.
  expect_gte(
    nrow(cite_imis_dataset(all_imis_acoustic_codes)),
    0.8 * length(all_imis_acoustic_codes)
  )

  all_imis_animal_codes <- get_animal_projects() |>
    dplyr::pull(imis_dataset_id)

  # Some IMIS dataset_ids will result in a 404 on marineinfo, but we should be
  # able to get most of them.
  expect_gte(
    nrow(cite_imis_dataset(all_imis_animal_codes)),
    0.8 * length(all_imis_animal_codes)
  )
})
