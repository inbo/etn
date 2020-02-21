con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Expected column names
expected_col_names_animals <- c(
  "pk",
  "animal_id",
  "animal_project_code",
  "tag_id",
  "tag_fk",
  "scientific_name",
  "common_name",
  "aphia_id",
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

project1 <- "phd_reubens"
project2 <- "2013_albertkanaal"
projects_multiple <- c("phd_reubens", "2013_albertkanaal")
name1 <- "Gadus morhua"
names_multiple <- c("Gadus morhua", "Sentinel", "Anguilla anguilla")

animals_all <- get_animals(con)
animals_project1 <- get_animals(con, animal_project_code = project1)
animals_project2 <- get_animals(con, animal_project_code = project2)
animals_projects_multiple <- get_animals(con, animal_project_code = projects_multiple)
animals_names_multiple <- get_animals(con, scientific_name = names_multiple)
animals_project1_name1 <- get_animals(con,
  animal_project_code = project1,
  scientific_name = name1
)

testthat::test_that("test_input_get_animals", {
  expect_error(
    get_animals("I am not a connection"),
    "Not a connection object to database."
  )
})


testthat::test_that("test_output_get_animals", {
  library(dplyr)
  expect_is(animals_all, "data.frame")
  expect_is(animals_project1, "data.frame")
  expect_is(animals_project2, "data.frame")
  expect_is(animals_projects_multiple, "data.frame")
  expect_is(animals_names_multiple, "data.frame")
  expect_is(animals_project1_name1, "data.frame")
  expect_true(all(names(animals_all) %in% expected_col_names_animals))
  expect_true(all(expected_col_names_animals %in% names(animals_all)))
  expect_gte(nrow(animals_all), nrow(animals_project1))
  expect_gte(nrow(animals_all), nrow(animals_project2))
  expect_gte(nrow(animals_all), nrow(animals_projects_multiple))
  expect_gte(nrow(animals_all), nrow(animals_names_multiple))
  expect_gte(nrow(animals_all), nrow(animals_project1_name1))
  expect_equal(nrow(animals_project2), 309)
  expect_equal(names(animals_all), names(animals_project1))
  expect_equal(names(animals_all), names(animals_project2))
  expect_equal(names(animals_all), names(animals_projects_multiple))
  expect_equal(names(animals_all), names(animals_names_multiple))
  expect_equal(names(animals_all), names(animals_project1_name1))
  expect_gte(
    animals_all %>% distinct(scientific_name) %>% pull() %>% length(),
    animals_projects_multiple %>% distinct(scientific_name) %>% pull() %>% length()
  )
  expect_lte(
    animals_projects_multiple %>% distinct(scientific_name) %>% pull() %>% length(),
    (animals_project1 %>% distinct(scientific_name) %>% pull() %>% length() +
      animals_project2 %>% distinct(scientific_name) %>% pull() %>% length())
  )
  expect_true(all(projects_multiple %in%
    (animals_names_multiple %>% distinct(animal_project_code) %>% pull())))
  expect_identical(
    animals_project1_name1 %>% distinct(scientific_name) %>% pull(scientific_name),
    c(name1)
  )
  expect_identical(
    animals_project1_name1 %>% distinct(animal_project_code) %>% pull(animal_project_code),
    c(project1)
  )
  # expect_equal(nrow(animals_all), nrow(animals_all %>% distinct(pk)))
})
