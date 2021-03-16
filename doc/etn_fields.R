## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----include=FALSE------------------------------------------------------------
library(etn)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(glue)
library(DBI)
library(kableExtra)

## ----include=FALSE------------------------------------------------------------
con <- connect_to_etn(Sys.getenv("userid"), Sys.getenv("pwd"))
query <- glue_sql("
    SELECT
      viewname,
      field,
      trim(regexp_replace(definition, '[\\s+]+', ' ', 'g')) AS definition,
      trim(regexp_replace(example, '[\\s+]+', ' ', 'g')) AS example,
      CASE
        WHEN datatype = 'character varying' THEN 'character'
        WHEN datatype = 'text' THEN 'character'
        WHEN datatype = 'double precision' THEN 'double'
        WHEN datatype = 'numeric' THEN 'double'
        WHEN datatype = 'timestamp without time zone' THEN 'datetime'
        WHEN datatype = 'smallint' THEN 'integer'
        ELSE datatype
      END AS datatype,
      \"order\"
    FROM
      vliz.field_definitions
    ORDER BY
      viewname,
      \"order\"
    ", .con = connection)
etn_fields <- dbGetQuery(con, query)

## ----include=FALSE------------------------------------------------------------
write_csv(etn_fields, "../inst/assets/etn_fields.csv", na = "")

## ----include=FALSE------------------------------------------------------------
# Create helper function to display tables for each view
view_table <- function(view_name) {
  view_data <-
    etn_fields %>%
    # Filter on view
    filter(viewname == view_name) %>%
    # Order by order (should already be done by query)
    arrange(order) %>%
    # Select columns
    select(field, definition, example, datatype) %>%
    # Convert quotes to backticks, so examples are shown as markdown monospaced code
    mutate(across(everything(), ~ str_replace_all(., "\"", "`"))) %>%
    # Wrap "field" in backticks
    mutate(field = if_else(!is.na(field), paste0("`", field, "`"), field)) %>%
    # Convert "NA" to empty strings
    mutate(across(everything(), ~ replace_na(., "")))
  
  view_kable <-
    kable(view_data) %>%
    # field: some have long names, break-word will force them to wrap
    column_spec(1, width = "25%", extra_css = "word-break: break-word") %>%
    # definition
    column_spec(2, width = "40%") %>%
    # example
    column_spec(3, width = "25%") %>%
    # data type
    column_spec(4, width = "10%")
  
  return(view_kable)
}

## ----echo=FALSE---------------------------------------------------------------
view_table("projects_view2")

## ----echo=FALSE---------------------------------------------------------------
view_table("animals_view2")

## ----echo=FALSE---------------------------------------------------------------
view_table("tags_view2")

## ----echo=FALSE---------------------------------------------------------------
view_table("detections_view2")

## ----echo=FALSE---------------------------------------------------------------
view_table("deployments_view2")

## ----echo=FALSE---------------------------------------------------------------
view_table("receivers_view2")

