test_that("get_bibiograpy() returns a data.frame", {
  test_input <-
    data.frame(
      animal_project_code = "STRAITS_GIBRALTAR_ANIMAL",
      acoustic_project_code = "MOVE_CCMAR_NETWORK"
    )
  expect_s3_class(
    get_bibiography(test_input),
    "data.frame"
  )
})

test_that("get_bibliography() returns data.frame with expected columns", {
  test_input <-
    data.frame(
      animal_project_code = "STRAITS_GIBRALTAR_ANIMAL",
      acoustic_project_code = "MOVE_CCMAR_NETWORK"
    )

  expect_named(
    get_bibiography(test_input),
    c("item", "type", "citation")
  )
})

test_that("get_bibliography() accepts dataframes with expected columns", {
    expect_s3_class(
      get_bibiography(read_resource(example_dataset(), "detections")),
    "data.frame"
  )

  test_input <-
    data.frame(
      animal_project_code = "STRAITS_GIBRALTAR_ANIMAL",
      acoustic_project_code = "MOVE_CCMAR_NETWORK"
    )

  expect_s3_class(
    get_bibiography(test_input),
    "data.frame"
  )
})

test_that("get_bibliography() returns error on missing columns", {
  expect_error(
    get_bibiography(
      data.frame(
        animal_project_code = "STRAITS_GIBRALTAR_ANIMAL"
      )
    ),
    class = ""
  )

  expect_error(
    get_bibiography(
      data.frame(
        acoustic_project_code = "MOVE_CCMAR_NETWORK"
      )
    ),
    class = ""
  )

  expect_error(
    get_bibiography(
      data.frame(
        other_column = "foo",
        another_column = "bar"
      )
    ),
    class = ""
  )
})

test_that("get_bibliography() returns error on unexpected input type", {

  expect_error(
    get_biography("not a data.frame"),
    class = ""
  )
})

test_that("get_bibliography() handles missing project codes", {
  expect_error(
    get_bibiography(
      data.frame(
        # valid code
        acoustic_project_code = "MOVE_CCMAR_NETWORK",
        # invalid code
        animal_project_code = "not an animal project code"
      )
    ),
    class = ""
  )

  expect_error(
    get_bibiography(
      data.frame(
        # valid code
        animal_project_code = "STRAITS_GIBRALTAR_ANIMAL",
        # invalid code
        acoustic_project_code = "not an acoustic project code"
      )
    ),
    class = ""
  )
})

test_that("get_bibliography() returns data.frame with expected shape", {
  # One row for the ETN data system, with a hardcoded citation
  # One row for the etn R package, with a citation to the latest (non-dev) release
  # One row for each animal project
  # One row for each acoustic project

  n_animal_projects <-
    read_resource(example_dataset(), "detections",
                  col_select = "animal_project_code") |>
    dplyr::n_distinct("animal_project_code")

  n_acoustic_projects <-
    read_resource(example_dataset(), "detections",
                  col_select = "acoustic_project_code") |>
    dplyr::n_distinct("acoustic_project_code")

  expected_columns <- c("item", "type", "citation")

  expect_shape(
    get_bibiography(read_resource(example_dataset(), "detections")),
    ncol = length(expected_columns),
    nrow = length(c(
      "ETN datasystem citation", "etn R package citation"
    )) + n_animal_projects + n_acoustic_projects
  )
})

test_that("get_bibliography() returns data.frame hardcoded ETN citation", {
  etn_ref <- paste(
    "European Tracking Network - Data Platform.",
    "Flanders Marine Institute (VLIZ)"
  )

  test_input <-
    data.frame(
      animal_project_code = "STRAITS_GIBRALTAR_ANIMAL",
      acoustic_project_code = "MOVE_CCMAR_NETWORK"
    )

  expect_identical(
    get_bibiography(test_input) |>
      dplyr::filter(.data$item == "ETN",
                    .data$type == "data platform") |>
      dplyr::pull("citation"),
    expected = etn_ref
  )
})

test_that("get_bibliography() returns package citation", {
  test_input <-
    data.frame(
      animal_project_code = "STRAITS_GIBRALTAR_ANIMAL",
      acoustic_project_code = "MOVE_CCMAR_NETWORK"
    )

  expect_identical(
    get_bibiograph(test_input) |>
      dplyr::filter(.data$item == "etn",
                    .data$type == "R Package") |>
      dplyr::pull("citation"),
    expected = etn_citation()
  )

})

test_that("get_bibliography() returns animal and project citations", {
  bibiography <-
    get_bibiography(read_resource(example_dataset(), "detections"))
  # Expect at least one animal project and one acoustic project in the bibliography
  expect_gte(dplyr::filter(bibiography, .data$type == "animal project"),
    expected = 1L
  )

  expect_gte(dplyr::filter(bibiography, .data$type == "acoustic project"),
    expected = 1L
  )

  animal_project_codes <- c(
    "2004_Gudena",
    "2010_phd_reubens",
    "2010_phd_reubens_sync",
    "2011_Loire",
    "2011_rivierprik"
  )
  animal_citations <-
    get_animal_projects(animal_project_code = animal_project_codes,
                        citation = TRUE) |>
    dplyr::select(dplyr::all_of(c("project_code", "citation")))

  acoustic_project_codes <- c(
    "2004_Gudena",
    "2011_bovenschelde",
    "2011_Loire",
    "2011_Warnow",
    "2013_Foyle"
  )
  acoustic_citations <-
    get_acoustic_projects(acoustic_project_code = acoustic_project_codes,
                          citation = TRUE) |>
    dplyr::select(dplyr::all_of(c("project_code", "citation")))

  expect_setequal(
    get_bibiography(
      dplyr::tibble(
        animal_project_code = animal_project_codes,
        acoustic_project_code = acoustic_project_codes,
      )
    ) |>
      dplyr::filter(type %in% c("animal project", "acoustic project")) |>
      dplyr::pull(citation),
    expected = c(
      dplyr::pull(animal_citations, "citation"),
      dplyr::pull(acoustic_citations, "citation")
    )
  )
})

test_that("get_bibiography() returns expected values for type", {
  expect_setequal(
    get_bibiography(
      read_resource(example_dataset(), "detections")
    ) |>
      dplyr::pull("type"),
    expected = c("data platform", "R package", "animal project", "acoustic project")
  )
})

test_that("get_bibiography() returns expected values for item", {
  project_codes <-
    read_resource(example_dataset(), "detections", col_select =
  c("acoustic_project_code", "animal_project_code")) |>
    unlist(use.names = FALSE) |>
    unique()

  expect_setequal(
    get_bibiography(
      read_resource(example_dataset(), "detections")
    ) |>
      dplyr::pull("item"),
    expected = c("ETN", "etn", project_codes)
  )
})
