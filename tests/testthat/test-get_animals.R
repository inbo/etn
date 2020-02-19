# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Valid column names
valid_col_names_animals <- c(
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

test1 <- get_animals(con)
test2 <- get_animals(con, animal_project = "phd_reubens")
test3 <- get_animals(con, animal_project = "2013_albertkanaal")

projects_test4 <- c("phd_reubens", "2013_albertkanaal")
test4 <- get_animals(con, animal_project = projects_test4)
animals_test5 <- c("Gadus morhua", "Sentinel", "Anguilla anguilla")
test5 <- get_animals(con, scientific_name = animals_test5)
animals_test6 <- c("Gadus morhua")
projects_test6 <- "phd_reubens"
test6 <- get_animals(con, animal_project = projects_test6,
                     scientific_name = animals_test6)

testthat::test_that("test_input_get_animals", {
  expect_error(get_animals("I am not a connection"),
               "Not a connection object to database.")
})


testthat::test_that("test_output_get_animals", {
  library(dplyr)
  expect_is(test1, "data.frame")
  expect_is(test2, "data.frame")
  expect_is(test3, "data.frame")
  expect_is(test4, "data.frame")
  expect_is(test5, "data.frame")
  expect_is(test6, "data.frame")
  expect_true(all(names(test1) %in% valid_col_names_animals))
  expect_true(all(valid_col_names_animals %in% names(test1)))
  expect_gte(nrow(test1), nrow(test2))
  expect_gte(nrow(test1), nrow(test3))
  expect_gte(nrow(test1), nrow(test4))
  expect_gte(nrow(test1), nrow(test5))
  expect_gte(nrow(test1), nrow(test6))
  expect_equal(nrow(test3), 309)
  expect_equal(names(test1), names(test2))
  expect_equal(names(test1), names(test3))
  expect_equal(names(test1), names(test4))
  expect_equal(names(test1), names(test5))
  expect_equal(names(test1), names(test6))
  expect_gte(test1 %>%
               distinct(scientific_name) %>%
               pull() %>%
               length(),
             test4 %>%
               distinct(scientific_name) %>%
               pull() %>%
               length()
  )
  expect_lte(test4 %>%
                     distinct(scientific_name) %>%
                     pull() %>%
                     length(),
                   (test2 %>%
                      distinct(scientific_name) %>%
                      pull() %>%
                      length() +
                    test3 %>%
                      distinct(scientific_name) %>%
                      pull() %>%
                      length())
  )
  expect_true(all(projects_test4 %in% (test5 %>%
                                         distinct(animal_project_code) %>%
                                         pull()))
  )
  expect_identical(test6 %>%
                     distinct(scientific_name) %>%
                     pull(scientific_name),
                   animals_test6
  )
  expect_identical(test6 %>%
                     distinct(animal_project_code) %>%
                     pull(animal_project_code),
                   projects_test6
  )
})
