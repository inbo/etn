context("test_get_deployments")

# Valid connection
con <- connect_to_etn(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test1 <- get_deployments(con)
test2 <- get_deployments(con, network_project = "thornton")
test3 <- get_deployments(con, network_project = c("thornton",
                                                  "leopold"))
test4 <- get_deployments(con, receiver_status = "Broken")
test5 <- get_deployments(con, receiver_status = c("Broken", "Lost"))

testthat::test_that("test_input_get_deployments", {
  expect_error(get_transmitters("I am not a connection"),
               "Not a connection object to database.")
  expect_error(get_deployments(con, network_project = "very_bad_project"))
  expect_error(get_deployments(con, network_project = c("thornton",
                                                        "very_bad_project")))
  expect_error(get_deployments(con, network_project = "thornton",
                               receiver_status = "very_bad_receiver_status"))
  expect_error(get_deployments(con, network_project = "thornton",
                               receiver_status = c("Broken",
                                                   "very_bad_receiver_status")))
})


testthat::test_that("test_output_get_deployments", {
  library(dplyr)
  expect_is(test1, "data.frame")
  expect_is(test2, "data.frame")
  expect_is(test3, "data.frame")
  expect_gte(nrow(test1), nrow(test2))
  expect_gte(nrow(test1), nrow(test3))
  expect_gte(nrow(test3), nrow(test2))
  expect_gte(nrow(test5), nrow(test4))
  expect_equal(ncol(test1), ncol(test2))
  expect_equal(ncol(test2), ncol(test3))
  expect_equal(ncol(test3), ncol(test4))
  expect_equal(ncol(test4), ncol(test5))
  expect_gte(test1 %>% distinct(receiver_status) %>% nrow(),
             test2 %>% distinct(receiver_status) %>% nrow())
  expect_gte(test3 %>% distinct(receiver_status) %>% nrow(),
             test2 %>% distinct(receiver_status) %>% nrow())
  expect_gte(test1 %>% distinct(receiver_status) %>% nrow(),
             test3 %>% distinct(receiver_status) %>% nrow())
  expect_gte(test1 %>% distinct(receiver_status) %>% nrow(),
             test5 %>% distinct(receiver_status) %>% nrow())
  expect_gte(test5 %>% distinct(receiver_status) %>% nrow(),
             test4 %>% distinct(receiver_status) %>% nrow())
  expect_gte(test1 %>% distinct(projectcode) %>% nrow(),
             test2 %>% distinct(projectcode) %>% nrow())
  expect_gte(test3 %>% distinct(projectcode) %>% nrow(),
             test2 %>% distinct(projectcode) %>% nrow())
  expect_gte(test1 %>% distinct(projectcode) %>% nrow(),
             test5 %>% distinct(projectcode) %>% nrow())
  expect_gte(test5 %>% distinct(projectcode) %>% nrow(),
             test4 %>% distinct(projectcode) %>% nrow())
  expect_true(test2 %>% distinct(projectcode) %>% pull() == "thornton")
  expect_true(all(test3 %>% distinct(projectcode) %>% pull() %in% c("thornton",
                                                                  "leopold")))
  expect_true(all(test3 %>% distinct(receiver_status) %>% pull() %in%
                    (test2 %>% distinct(receiver_status) %>% pull())))
  expect_true(all(test3 %>% distinct(receiver_status) %>% pull() %in%
                    (test1 %>% distinct(receiver_status) %>% pull())))
  expect_true(test4 %>% distinct(receiver_status) %>% pull() == "Broken")
  expect_true(all(test5 %>% distinct(receiver_status) %>% pull() %in% c("Broken",
                                                                  "Lost")))
})
