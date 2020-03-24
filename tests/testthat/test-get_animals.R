con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names <- c(
  "pk",
  "animal_id",
  "animal_project_code",
  "tag_id",
  "tag_fk",
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
tag_col_names <- c(
  "tag_id",
  "tag_fk",
  "tagger",
  "tagging_type",
  "tagging_methodology"
)

project1 <- "phd_reubens"
project2 <- "2013_albertkanaal"
project_multiple <- c("2013_albertkanaal", "phd_reubens")
animal_pk_multiple_tags <- 2369
sciname1 <- "Gadus morhua"
sciname_multiple <- c("Anguilla anguilla", "Gadus morhua", "Sentinel")

animals_all <- get_animals(con)
animals_project1 <- get_animals(con, animal_project_code = project1)
animals_project2 <- get_animals(con, animal_project_code = project2)
animals_project_multiple <- get_animals(con, animal_project_code = project_multiple)
animals_sciname_multiple <- get_animals(con, scientific_name = sciname_multiple)
animals_project1_sciname1 <- get_animals(con, animal_project_code = project1, scientific_name = sciname1)
animals_tag_multiple <- animals_all %>% filter(pk == 2827)

testthat::test_that("Test input", {
  expect_error(
    get_animals("not_a_connection"),
    "Not a connection object to database."
  )
  expect_error(
    get_animals(con, network_project_code = "not_a_project")
  )
  expect_error(
    get_animals(con, network_project_code = c("thornton", "not_a_project"))
  )
})

testthat::test_that("Test output type", {
  expect_is(animals_all, "data.frame")
  expect_is(animals_project1, "data.frame")
  expect_is(animals_project2, "data.frame")
  expect_is(animals_project_multiple, "data.frame")
  expect_is(animals_sciname_multiple, "data.frame")
  expect_is(animals_project1_sciname1, "data.frame")
})

testthat::test_that("Test column names", {
  expect_equal(names(animals_all), expected_col_names)
  expect_equal(names(animals_project1), expected_col_names)
  expect_equal(names(animals_project2), expected_col_names)
  expect_equal(names(animals_project_multiple), expected_col_names)
  expect_equal(names(animals_sciname_multiple), expected_col_names)
  expect_equal(names(animals_project1_sciname1), expected_col_names)
})

testthat::test_that("Test number of records", {
  expect_equal(nrow(animals_project2), 309)
  expect_gt(nrow(animals_all), nrow(animals_project1))
  expect_gt(nrow(animals_all), nrow(animals_project2))
  expect_gt(nrow(animals_all), nrow(animals_project_multiple))
  expect_equal(nrow(animals_project_multiple), nrow(animals_project1) + nrow(animals_project2))
  expect_gt(nrow(animals_all), nrow(animals_sciname_multiple))
  expect_gt(nrow(animals_all), nrow(animals_project1_sciname1))
  expect_gt(nrow(animals_project1), nrow(animals_project1_sciname1))
})

testthat::test_that("Test if data is filtered on paramater", {
  expect_equal(
    animals_project1 %>% distinct(animal_project_code) %>% pull(),
    c(project1)
  )
  expect_equal(
    animals_project2 %>% distinct(animal_project_code) %>% pull(),
    c(project2)
  )
  expect_equal(
    animals_project_multiple %>% distinct(animal_project_code) %>% arrange(animal_project_code) %>% pull(),
    c(project_multiple)
  )
  expect_equal(
    animals_sciname_multiple %>% distinct(scientific_name) %>% arrange(scientific_name) %>% pull(),
    c(sciname_multiple)
  )
  expect_equal(
    animals_project1_sciname1 %>% distinct(animal_project_code) %>% pull(),
    c(project1)
  )
  expect_equal(
    animals_project1_sciname1 %>% distinct(scientific_name) %>% pull(),
    c(sciname1)
  )
})

testthat::test_that("Test unique ids and collapsed tag information", {
  expect_equal(nrow(animals_all), nrow(animals_all %>% distinct(pk)))
  expect_equal(nrow(animals_all), nrow(animals_all %>% distinct(animal_id)))

  has_comma <- apply(
    animals_tag_multiple %>% select(tag_col_names),
    MARGIN = 2,
    function(x) grepl(pattern = ",", x = x)
  )
  expect_true(all(has_comma))
})
