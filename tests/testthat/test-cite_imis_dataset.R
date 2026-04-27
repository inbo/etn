test_that("cite_imis_dataset() returns a tibble", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-8296")

  expect_s3_class(
    cite_imis_dataset(imis_dataset_ids = 8296),
    "tbl_df"
  )
})

test_that("cite_imis_dataset() can handle multiple datasets at a time", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-multiple")

  expect_shape(
    cite_imis_dataset(imis_dataset_ids = c(8296, 7915)),
    nrow = 2L
  )
})

test_that("cite_imis_dataset() returns expected columns", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-7915")

  expect_named(
    cite_imis_dataset(imis_dataset_ids = 7915),
    c(
      "imis_dataset_id",
      "citation",
      "doi",
      "contact_name",
      "contact_email",
      "contact_affiliation"
    )
  )
})

test_that("cite_imis_dataset() returns remaining data if some ids are NA", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-one-missing")

  expect_shape(
    cite_imis_dataset(
      imis_dataset_ids = c(NA, 8468, 5929)
    ),
    nrow = 2L
  )
})

test_that("cite_imis_dataset() returns empty fields on missing `ownerships`", {
  # When MarineInfo/IMIS doesn't contain any ownerships information, return
  # empty columns

  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-7970")

  expect_identical(
    cite_imis_dataset(imis_dataset_ids = 7970) |>
      dplyr::select(dplyr::all_of(
        c("contact_name", "contact_email", "contact_affiliation")
      )),
    dplyr::tibble(
      contact_name = NA_character_,
      contact_email = NA_character_,
      contact_affiliation = NA_character_
    )
  )
})

test_that("cite_imis_dataset() can handle `ownerships` with no first owner", {
  # dataset 6349 has OrderNr 2 and 3, but not 1 under ownerships.
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-no-first-auth")

  # Previously, a hard filter on OrderNr resulted in NA for all `ownership`
  # child elements
  expect_identical(
    dplyr::pull(
      cite_imis_dataset(imis_dataset_ids = 6349),
      "contact_affiliation"
    ),
    "Ege University"
  )
})

test_that("cite_imis_dataset() can handle `ownerships` with missing order", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-auth-unordered")

   # 6557 has NA for it's ownerships$OrderNr
  expect_shape(
    cite_imis_dataset(6557),
    nrow = 1
  )

  # 8029 has only one missing OrderNr but the rest is present
  expect_shape(
    cite_imis_dataset(6557),
    nrow = 1
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
  expect_shape(
    cite_imis_dataset(imis_dataset_ids = NA),
    nrow = 0L
  )
})

test_that("cite_imis_dataset() returns DOI for known dataset with DOI", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-8856")

  expect_identical(
    # acoustic_project_code: 2004_gudena has a DOI
    cite_imis_dataset(imis_dataset_ids = 8856)$doi,
    "https://doi.org/10.14284/735"
  )
})

test_that("cite_imis_dataset() can append doi to citation if available", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-8859")

  expect_true(
    stringr::str_ends(
      cite_imis_dataset(imis_dataset_ids = 8859)$citation,
      stringr::fixed("https://doi.org/10.14284/744")
    )
  )
})

test_that("cite_imis_dataset() doesn't destroy citation upon appending doi", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-5871")

  # value should not be NA
  expect_false(
    is.na(cite_imis_dataset(imis_dataset_ids = 5871)$citation)
  )
})

test_that("cite_imis_dataset() returns citation even when there is no doi", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-6336")
  # animal project 2011_Loire has a Citation, but not a doi
  expect_true(
    is.na(cite_imis_dataset(imis_dataset_ids = 6336)$doi)
  )

  expect_false(
    is.na(cite_imis_dataset(imis_dataset_ids = 6336)$citation)
  )

  expect_match(
    cite_imis_dataset(imis_dataset_ids = 6336)$citation,
    "telemetry\\.$"
  )
})

test_that("cite_imis_dataset() doesn't append doi when there is no doi", {
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

test_that("cite_imis_dataset() doesn't introduce encoding issues", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-encoding")

  skip("Encoding issue on the API ISSUE#521")

  # Compare against known group of citations of which some showed encoding
  # issues
  expect_snapshot(
    cite_imis_dataset(imis_dataset_ids = c(8856, 6336, 8857, 6333, 6716)) |>
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

test_that("cite_imis_dataset() returns 0 a row tibble when all requests fail", {
  skip_if_offline("marineinfo.org")

  vcr::local_cassette("citations-api-warning")

  expect_identical(
    cite_imis_dataset(imis_dataset_ids = 7934,
                      warn = FALSE),
    dplyr::tibble(
      imis_dataset_id = integer(),
      citation = character(),
      doi = character(),
      contact_name = character(),
      contact_email = character(),
      contact_affiliation = character()
    )
  )
})
