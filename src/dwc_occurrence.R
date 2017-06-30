#' # Mapping fish tracking data to Darwin Core Occurrence
#' 
#' Peter Desmet
#' `r Sys.Date()`
#' 
#' ## Setup
#' 
#+ configure_knitr, include = FALSE
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)

#' Load libraries:
library(tidyverse) # For data transformations
library(janitor)   # For cleaning input data
library(knitr)     # For nicer (kable) tables

#' Set file paths (all paths should be relative to this script):
raw_data_file = "../data/raw/20170516_etn_sample_detections_view.csv"
processed_dwc_occurrence_file = "..data/processed/dwc_occurrence/occurrence.csv"

#' ## Read data
#' 
#' Read the source data:
raw_data <- read.csv(raw_data_file)

#' Clean data somewhat:
raw_data %>%
  # Remove empty rows
  remove_empty_rows() %>%
  # Have sensible (lowercase) column names
  clean_names() -> raw_data

#' Add prefix `raw_` to all column names to avoid name clashes with Darwin Core terms:
colnames(raw_data) <- paste0("raw_", colnames(raw_data))

#' Save those column names as a list (makes it easier to remove them all later):
raw_colnames <- colnames(raw_data)

#' Preview data:
kable(head(raw_data))
