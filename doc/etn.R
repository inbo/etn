## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(etn)

## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  if (!"devtools" %in% installed.packages()) install.packages("devtools")
#  devtools::install_github("inbo/etn")

## -----------------------------------------------------------------------------
con <- connect_to_etn(Sys.getenv("userid"), Sys.getenv("pwd"))

## ----projects-----------------------------------------------------------------
my_projects <- get_projects(con)
head(my_projects, 10) # print 10 first

## ----my_animal_projects-------------------------------------------------------
my_network_projects <- get_projects(con, project_type = "network")
head(my_network_projects, 10) # print 10 first

## -----------------------------------------------------------------------------
ws3_deployments <- get_deployments(con, network_project_code = "ws3")
head(ws3_deployments, 10) # print 10 first

## -----------------------------------------------------------------------------
ws_deployments <- get_deployments(con, network_project_code = c("ws1", "ws3"))
head(ws_deployments, 10) # print 10 first

## -----------------------------------------------------------------------------
library(dplyr)

## -----------------------------------------------------------------------------
ws_deployments %>%
  select(receiver_id, station_name) %>%
  head(10) # print 10 first

## -----------------------------------------------------------------------------
my_deployments <- get_deployments(con, network_project_code = "ws1")

# Get list of receivers
receiver_ids <- my_deployments %>% distinct(receiver_id) %>% pull()

# Find receivers that are broken or lost
broken_receiver_ids <-
  get_receivers(con, receiver_id = receiver_ids, status = c("Broken", "Lost")) %>%
  pull(receiver_id)

# Filter deployments on those with broken or lost receivers
my_deployments %>%
  filter(receiver_id %in% broken_receiver_ids) %>%
  head() # print 10 first

## -----------------------------------------------------------------------------
my_animals <- get_animals(con, animal_project_code = "2012_leopoldkanaal")
head(my_animals, 10) # print 10 first

## ----case_check---------------------------------------------------------------
my_animals_case_check <- get_animals(con, animal_project_code = "2012_LEopoLdkAnAaL")
identical(my_animals, my_animals_case_check)

## -----------------------------------------------------------------------------
my_tags <- get_tags(con)
head(my_tags, 10) # print 10 first

## -----------------------------------------------------------------------------
my_detections <- get_detections(con,
  animal_project_code = "2010_phd_reubens",
  start_date = "2011-01-28",
  end_date = "2011-02-01",
  limit = TRUE # Limit number of records for this example
)
head(my_detections, 10) # print 10 first

