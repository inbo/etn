## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----load_pkg-----------------------------------------------------------------
library(etn)

## ----connect_to_db------------------------------------------------------------
con <- connect_to_etn(Sys.getenv("userid"), Sys.getenv("pwd"))

## ----load_other_pkgs, message=FALSE-------------------------------------------
library(dplyr)
library(lubridate)
library(leaflet)
library(htmltools)

## ----get_my_projects----------------------------------------------------------
my_projects <- get_projects()

## -----------------------------------------------------------------------------
my_projects<- 
  my_projects %>%
  filter(project_type == "animal")
# show the first 10 projects
my_projects %>%
  head(10)

## ----get_my_projects_directly-------------------------------------------------
my_projects <- get_projects(project_type = "animal")
# show the first 10 projects
my_projects %>%
  head(10)

## ----projects_study-----------------------------------------------------------
projects_study <- c("2014_demer", "2013_albertkanaal")

## ----start_end_date-----------------------------------------------------------
my_projects %>%
  filter(project_code %in% c(projects_study)) %>% 
  select(start_date, end_date)

## ----get_species_and_number_individuals---------------------------------------
animals <- get_animals(animal_project_code = projects_study)
animals %>%
  count(scientific_name)

## ----get_detections_silurus---------------------------------------------------
detections_silurus <- get_detections(animal_project_code = projects_study,
                                     start_date = "2014-01-01",
                                     end_date = "2015-12-31",
                                     scientific_name = "Silurus glanis")

## ----detections_silurus_period------------------------------------------------
detections_silurus_period <-
  detections_silurus %>%
  mutate(date = date(date_time)) %>%
  group_by(animal_id) %>%
  summarise(start = min(date),
            end = max(date))
detections_silurus_period

## ----duration_tracking--------------------------------------------------------
detections_silurus_duration <-
  detections_silurus %>%
  group_by(animal_id) %>%
  summarise(duration = max(date_time) - min(date_time))
detections_silurus_duration

## ----n_detections-------------------------------------------------------------
detections_silurus %>%
  group_by(animal_id) %>%
  count()

## -----------------------------------------------------------------------------
detections_silurus %>%
  group_by(animal_id) %>%
  distinct(station_name) %>%
  count()

## ----deployments_silurus------------------------------------------------------
deployments_silurus <-
  detections_silurus %>%
  select(starts_with("deploy"), station_name) %>%
  distinct()
deployments_silurus

## ----map_deployments----------------------------------------------------------
leaflet(deployments_silurus) %>%
  addTiles() %>%
  addMarkers(lng = ~deploy_longitude,
             lat = ~deploy_latitude,
             popup = ~htmlEscape(paste0(station_name, " (", deployment_fk, ")")))

## ----n_detections_per_deployment----------------------------------------------
detections_silurus %>%
  group_by(deployment_fk, station_name) %>%
  count()

## ----networks_involved--------------------------------------------------------
networks_silurus <- 
  detections_silurus %>%
  distinct(network_project_code)
networks_silurus

## ----get_deployment_info------------------------------------------------------
deployments_silurus <-
  # get all deployments from the involved networks
  get_deployments(network_project_code = networks_silurus$network_project_code,
                  open_only = FALSE) %>%
  # filter the deployments based on their unique identifier
  filter(pk %in% detections_silurus$deployment_fk)

deployments_silurus

## ----deployment_duration------------------------------------------------------
deployments_silurus_duration <- 
  deployments_silurus %>%
  mutate(duration = recover_date_time - deploy_date_time) %>%
  select(pk, station_name, duration)
deployments_silurus_duration

## ----n_active_days_deployments_silurus----------------------------------------
n_active_days_deployments_silurus <- 
  detections_silurus %>%
  mutate(date = date(date_time)) %>%
  distinct(deployment_fk, station_name, date) %>%
  group_by(deployment_fk, station_name) %>%
  summarise(n_days = n())
n_active_days_deployments_silurus

## -----------------------------------------------------------------------------
n_active_days_deployments_silurus %>%
  left_join(deployments_silurus_duration,
            by = c("deployment_fk" = "pk", "station_name")) %>%
  mutate(relative_detection_duration = n_days / as.numeric(duration)) %>%
  select(deployment_fk, station_name, relative_detection_duration)

