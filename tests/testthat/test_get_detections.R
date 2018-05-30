context("test_get_detections")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

testthat::test_that("test_input_get_detections", {
  expect_error(get_detections("I am not a connection"),
               "Not a connection object to database.")
  expect_error(get_detections(con, network_project = "very_bad_project"))
  expect_error(get_detections(con, network_project = c("thornton",
                                                      "very_bad_project")))
  expect_error(get_detections(con, animal_project = "very_bad_project",
                              network_project = "thornton"))
  expect_error(get_detections(con,
                              animal_project = c("phd_reubens", "i_am_bad"),
                              network_project = "thornton"))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              start_date = "bad_date"))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              start_date = "2011", end_date = "bad_brrrr"))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              start_date = "2011", end_date = "bad_brrrr"))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              deployment_station_name = "no_way"))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              deployment_station_name = c("R03","no_way")))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              transmitter = c("R03","no_way")))
  expect_error(get_detections(con,
                              animal_project = "phd_reubens",
                              network_project = "thornton",
                              receiver = c("superraar")))
  expect_error(get_detections(con, scientific_name = c("I am not an animal")))
})


start_date <- "2011"
end_date <- "2011-02-01"
start <- check_datetime(start_date, "start_date")
end <- check_datetime(end_date, "end_date")
test1 <- get_detections(con, start_date = start_date, limit = 5)
test2 <- get_detections(con, start_date = start_date, limit = 2)
animal_project <- "phd_reubens"
network_project <- "thornton"
limit <- 5
transmitter <- "A69-1303-65302"
receiver <- "VR2W-122360"
scientific_name <- "Anguilla anguilla"

test3<- get_detections(con, animal_project = animal_project,
                       network_project = network_project, start_date = start_date,
                       end_date = end_date, limit = limit,
                       transmitter = transmitter)
deployment_station_name <- "R03"
test4 <- get_detections(con, animal_project = animal_project,
                        network_project = network_project,
                        deployment_station_name = deployment_station_name,
                        limit = limit, transmitter = transmitter)

test5 <- get_detections(con, transmitter = transmitter, limit = limit)
test6 <- get_detections(con, receiver = receiver, limit = limit)
test7 <- get_detections(con, scientific_name = scientific_name, limit = limit)

testthat::test_that("test_output_get_detections", {
  expect_equal(nrow(test1), 5)
  expect_equal(nrow(test2), 2)
  expect_equal(ncol(test1), ncol(test2))
  expect_equal(ncol(test2), ncol(test3))
  expect_equal(ncol(test3), ncol(test4))
  expect_equal(ncol(test4), ncol(test5))
  expect_true(test1 %>%
                 select(datetime) %>%
                 summarize(min_datetime = min(datetime)) %>%
                 pull(min_datetime) > start)
  expect_true(test2 %>%
                select(datetime) %>%
                summarize(min_datetime = min(datetime)) %>%
                pull(min_datetime) > start)
  expect_true(test3 %>%
                select(datetime) %>%
                summarize(min_datetime = min(datetime)) %>%
                pull(min_datetime) > start)
  expect_true(test3 %>%
                select(datetime) %>%
                summarize(max_datetime = max(datetime)) %>%
                pull(max_datetime) < end)
  expect_true(test3 %>%
                distinct(animal_project_code) %>%
                pull() == animal_project)
  expect_true(test3 %>%
                distinct(network_project_code) %>%
                pull() == network_project)
  expect_lte(test3 %>% nrow(), limit)
  expect_true(test4 %>%
                distinct(deployment_station_name) %>%
                pull() == deployment_station_name)
  expect_true(test5 %>%
                distinct(transmitter) %>%
                pull() == transmitter)
  expect_true(test6 %>%
                distinct(receiver) %>%
                pull() == receiver)
  expect_true(test7 %>%
                distinct(scientific_name) %>%
                pull() == scientific_name)
})

