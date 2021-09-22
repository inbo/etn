con <- connect_to_etn()

test_that("get_animals() returns error for incorrect connection", {
  expect_error(
    get_animals("not_a_connection"),
    "Not a connection object to database."
  )
})

test_that("get_animals() returns a tibble", {
  animals <- get_animals()
  expect_s3_class(animals, "data.frame")
  expect_s3_class(animals, "tbl")
})

test_that("get_animals() returns unique animal_id", {
  animals <- get_animals()
  expect_equal(nrow(animals), nrow(animals %>% distinct(animal_id)))
})

test_that("get_animals() returns the expected columns", {
  animals <- get_animals()
  expected_col_names <- c(
    "animal_id",
    "animal_project_code",
    "tag_serial_number",
    "tag_type",
    "scientific_name",
    "common_name",
    "aphia_id",
    "animal_label",
    "animal_nickname",
    "tagger",
    "capture_date_time",
    "capture_location",
    "capture_latitude",
    "capture_longitude",
    "capture_method",
    "capture_depth",
    "capture_temperature_change",
    "release_date_time",
    "release_location",
    "release_latitude",
    "release_longitude",
    "recapture_date_time",
    "length1_type",
    "length1",
    "length1_unit",
    "length2_type",
    "length2",
    "length2_unit",
    "length3_type",
    "length3",
    "length3_unit",
    "length4_type",
    "length4",
    "length4_unit",
    "weight",
    "weight_unit",
    "age",
    "age_unit",
    "sex",
    "life_stage",
    "wild_or_hatchery",
    "stock",
    "surgery_date_time",
    "surgery_location",
    "surgery_latitude",
    "surgery_longitude",
    "treatment_type",
    "tagging_type",
    "tagging_methodology",
    "dna_sample",
    "sedative",
    "sedative_concentration",
    "anaesthetic",
    "buffer",
    "anaesthetic_concentration",
    "buffer_concentration_in_anaesthetic",
    "anaesthetic_concentration_in_recirculation",
    "buffer_concentration_in_recirculation",
    "dissolved_oxygen",
    "pre_surgery_holding_period",
    "post_surgery_holding_period",
    "holding_temperature",
    "comments"
  )
  expect_equal(names(animals), expected_col_names)
})

test_that("get_animals() allows selecting on animal_id", {
  # Errors
  expect_error(get_animals(animal_id = 0)) # Not an existing animal_id
  expect_error(get_animals(animal_id = c(384, 0)))
  expect_error(get_animals(con, animal_id = 20.2)) # Not an integer

  # Select single value
  single_select <- 384
  single_select_df <- get_animals(animal_id = single_select)
  expect_equal(
    single_select_df %>% distinct(animal_id) %>% pull(),
    c(single_select)
  )
  expect_equal(nrow(single_select_df), 1)

  # Select multiple values
  multi_select <- c(384, "385") # Characters are allowed
  multi_select_df <- get_animals(animal_id = multi_select)
  expect_equal(
    multi_select_df %>% distinct(animal_id) %>% pull(),
    c(as.integer(multi_select)) # Output will be all integer
  )
  expect_equal(nrow(multi_select_df), 2)
})

test_that("get_animals() allows selecting on animal_project_code", {
  # Errors
  expect_error(get_animals(animal_project_code = "not_a_project"))
  expect_error(get_animals(animal_project_code = c("2014_demer", "not_a_project")))

  # Select single value
  single_select <- "2014_demer"
  single_select_df <- get_animals(animal_project_code = single_select)
  expect_equal(
    single_select_df %>% distinct(animal_project_code) %>% pull(),
    c(single_select)
  )

  # Selection is case insensitive
  expect_equal(
    get_animals(animal_project_code = "2014_demer"),
    get_animals(animal_project_code = "2014_DEMER")
  )

  # Select multiple values
  multi_select <- c("2014_demer", "2015_dijle")
  multi_select_df <- get_animals(animal_project_code = multi_select)
  expect_equal(
    multi_select_df %>% distinct(animal_project_code) %>% pull(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df)) # Expect more records
})

test_that("get_animals() allows selecting on scientific_name", {
  # Errors
  expect_error(get_animals(scientific_name = "not_a_sciname"))
  expect_error(get_animals(scientific_name = "silurus glanis")) # Case sensitive
  expect_error(get_animals(scientific_name = c("Silurus glanis", "not_a_sciname")))

  # Select single value
  single_select <- "Silurus glanis"
  single_select_df <- get_animals(scientific_name = single_select)
  expect_equal(
    single_select_df %>% distinct(scientific_name) %>% pull(),
    c(single_select)
  )

  # Select multiple values
  multi_select <- c("Silurus glanis", "Petromyzon marinus")
  multi_select_df <- get_animals(scientific_name = multi_select)
  expect_equal(
    multi_select_df %>% distinct(scientific_name) %>% pull(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df)) # Expect more records
})

test_that("get_animals() allows to exclude non-animals", {
  # Errors
  expect_error(get_animals(exclude_non_animals = "not_a_logical"))

  # Non-animals do are excluded from results
  non_animals <- c("Built-in", "Plastic", "Range tag", "Sync tag")
  expect_equal(
    get_animals(exclude_non_animals = TRUE) %>%
      filter(scientific_name %in% non_animals) %>%
      nrow(),
    0
  )
})

test_that("get_animals() allows selecting on multiple parameters", {
  multiple_parameters_df <- get_animals(
    animal_project_code = "2014_demer",
    scientific_name = "Silurus glanis"
  )
  # There are 9 Silurus glanis records in 2014_demer
  expect_equal(nrow(multiple_parameters_df), 9)
})

test_that("get_animals() collapses multiple associated tags to one row", {
  # Animal 5841 (project SPAWNSEIS) has 2 associated tags (1280688,1280688)
  animal_two_tags_df <- get_animals(animal_id = 5841)

  expect_equal(nrow(animal_two_tags_df), 1) # Rows should be collapsed

  # Columns starting with tag_ are collapsed with comma
  tag_col_names <- c(
    "tag_serial_number",
    "tag_type",
    "tagger",
    "tagging_type",
    "tagging_methodology"
  )
  has_comma <- apply(
    animal_two_tags_df %>% select(tag_col_names),
    MARGIN = 2,
    function(x) grepl(pattern = ",", x = x)
  )
  expect_true(all(has_comma))
})
