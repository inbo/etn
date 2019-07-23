context("test_get_animals")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

# Valid column names
valid_col_names_animals <- c(
"projectname",
"projectmember",
"tag_code_space",
"person_id",
"animal_id",
"scientific_name",
"common_name",
"length",
"length_type",
"length_units",
"length2",
"length2_type",
"length2_units",
"weight_units",
"age",
"age_units",
"sex",
"life_stage",
"capture_location",
"capture_depth",
"utc_release_date_time",
"comments",
"est_tag_life","wild_or_hatchery",
"stock",
"dna_sample_taken",
"treatment_type",
"dissolved_oxygen",
"sedative",
"sedative_concentration",
"temperature_change",
"holding_temperature",
"preop_holding_period",
"post_op_holding_period",
"surgery_location",
"date_of_surgery",
"anaesthetic","buffer",
"anaesthetic_concentration",
"buffer_concentration_in_anaesthetic",
"anesthetic_concentration_in_recirculation",
"buffer_concentration_in_recirculation",
"id_pk",
"catched_date_time",
"capture_latitude",
"capture_longitude",
"release_latitude",
"release_longitude",
"surgery_latitude",
"surgery_longitude",
"recapture_date",
"implant_type",
"implant_method",
"date_modified",
"date_created",
"release_location",
"length3",
"length3_type",
"length3_units",
"length4",
"length4_type",
"length4_units",
"weight",
"end_date_tag",
"capture_method",
"project_fk",
"animal_tag_release_id_pk",
"thelma_converted_code",
"projectcode",
"tag_full_id",
"principal_investigator",
"owner_organization",
"id_code",
"type",
"model",
"serial_number",
"activation_date",
"name",
"manufacturer"
)

test1 <- get_animals(con, network_project = NULL)
test2 <- get_animals(con, animal_project = "phd_reubens")
test3 <- get_animals(con, animal_project = "2012_leopoldkanaal")

projects_test4 <- c("phd_reubens", "2012_leopoldkanaal")
test4 <- get_animals(con, animal_project = projects_test4)
animals_test5 <- c("Gadus morhua", "Sentinel", "Anguilla anguilla")
test5 <- get_animals(con, scientific_name = animals_test5)
animals_test6 <- c("Gadus morhua")
projects_test6 <- "phd_reubens"
test6 <- get_animals(con, animal_project = projects_test6,
                     scientific_name = animals_test6)
test7 <- get_animals(con, network_project = "thornton")

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
  expect_is(test7, "data.frame")
  expect_true(all(names(test1) %in% valid_col_names_animals))
  expect_true(all(valid_col_names_animals %in% names(test1)))
  expect_gte(nrow(test1), nrow(test2))
  expect_gte(nrow(test1), nrow(test3))
  expect_gte(nrow(test1), nrow(test4))
  expect_gte(nrow(test1), nrow(test5))
  expect_gte(nrow(test1), nrow(test6))
  expect_gte(nrow(test1), nrow(test7))
  expect_equal(names(test1), names(test2))
  expect_equal(names(test1), names(test3))
  expect_equal(names(test1), names(test4))
  expect_equal(names(test1), names(test5))
  expect_equal(names(test1), names(test6))
  expect_equal(names(test1), names(test7))
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
                                         distinct(projectcode) %>%
                                         pull()))
  )
  expect_identical(test6 %>%
                     distinct(scientific_name) %>%
                     pull(scientific_name),
                   animals_test6
  )
  expect_identical(test6 %>%
                     distinct(projectcode) %>%
                     pull(projectcode),
                   projects_test6
  )
  expect_true(all(projects_test4 %in%
                    (test7 %>%
                       distinct(projectcode) %>%
                       pull()))
  )
})
