context("check_get_animals")

test1 <- get_animals(con, network_project = "thornton")
test2 <- get_animals(con, network_project = NULL)
test3 <- get_animals(con, animal_project = "2012_leopoldkanaal")

projects_test4 <- c("2012_leopoldkanaal", "phd_reubens")
test4 <- get_animals(con, animal_project = projects_test4)
animals_test4 <- c("Gadus morhua", "Sentinel", "Anguilla anguilla")
test5 <- get_animals(con, scientific_name = animals_test4)
animals_test6 <- c("Gadus morhua")
projects_test6 <- "phd_reubens"
test6 <- get_animals(con, animal_project = "phd_reubens",
                     scientific_name = animals_test6)

testthat::test_that("check_get_animals", {
  expect_error(get_animals("I am not a connection"),
               "Not a connection object to database.")
  expect_is(test1, "data.frame")
  expect_is(test2, "data.frame")
  expect_gte(nrow(test1), nrow(test2))
  expect_identical(animals_test4,
                   test4 %>%
                     distinct(scientific_name) %>%
                     pull(scientific_name))
  expect_true(all(projects_test4 %in% (test5 %>%
                 distinct(projectcode) %>%
                 pull(projectcode))))
  expect_identical(test6 %>%
                     distinct(scientific_name) %>%
                     pull(scientific_name),
                   animals_test6)
  expect_identical(test6 %>%
                     distinct(projectcode) %>%
                     pull(projectcode),
                   projects_test6)
})



