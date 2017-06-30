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

#' ## Create occurrence core
#' 
#' Map the source data to [Darwin Core Occurrence](http://rs.gbif.org/core/dwc_occurrence_2015-07-02.xml):

raw_data %>%
  arrange(raw_transmitter, raw_datetime) -> interim_data

#' Record-level terms:
interim_data %>% mutate(
  id = "TODO", # Use "id_pk" from DB
  type = "Event",
  # modified
  language = "en",
  license = "http://creativecommons.org/publicdomain/zero/1.0/",
  rightsHolder = "TODO", # Use "group" from animal project
  accessRights = "http://www.inbo.be/en/norms-for-data-use",
  # bibliographicCitation
  # references
  # institutionID
  # collectionID
  datasetID = "TODO", # Add DOI once available
  institutionCode = "TODO", # To be defined
  # collectionCode
  datasetName = "TODO", # To be defined
  # ownerInstitutionCode
  basisOfRecord = "MachineObservation",
  informationWithheld = "see metadata",
  # dataGeneralizations
  dynamicProperties = paste0(""), # Could contain, in json format: transmitter ID, receiver ID, animalproject, catch location, catch datetime, catchweight, catch length
) -> interim_data
  
#' Occurrence terms:
interim_data %>% mutate(
  occurrenceID = "TODO", # Use "id_pk" from DB
  # catalogNumber
  # recordNumber
  # recordedBy
  # individualCount
  # organismQuantity
  # organismQuantityType
  sex = "TODO", # Should be available for some animals
  lifeStage = "TODO", # At time of tagging
  # reproductiveCondition
  # behavior
  # establishmentMeans
  # occurrenceStatus
  # preparations
  # disposition
  # associatedMedia
  # associatedReferences
  # associatedSequences
  # associatedTaxa
  # otherCatalogNumbers
  # occurrenceRemarks
) -> interim_data
  
#' Organism terms:
interim_data %>% mutate(
  organismID = "TODO", # Should not be transmitterID, as that one can be replaced/reused. Find a good animalID
  # organismName
  # organismScope
  # associatedOccurrences
  # associatedOrganisms
  # previousIdentifications
  # organismRemarks
) -> interim_data

#' MaterialSample terms: not used
#' 
#' Event terms:
interim_data %>% mutate(
  # eventID
  # parentEventID
  # fieldNumber
  eventDate = raw_datetime, # Format in milliseconds: currently not used, but should be the case once VRL uploads are supported
  # eventTime
  # startDayOfYear
  # endDayOfYear
  # year
  # month
  # day
  # verbatimEventDate
  # habitat
  samplingProtocol = "TODO", # Should be ID of datapaper
  # samplingEffort
  # sampleSizeValue
  # sampleSizeUnit
  # fieldNotes
  # eventRemarks
) -> interim_data

#' Location terms:
interim_data %>% mutate(
  locationID = raw_station_name,
  # higherGeographyID
  # higherGeography
  # continent
  waterBody = "TODO maybe", # Maybe provide, based on marine regions gazetteer
  # islandGroup
  # island
  # country
  countryCode = "TODO maybe", # Maybe provide
  # stateProvince
  # county
  # municipality
  # locality: Not useful to provide raw Dutch location names
  # verbatimLocality
  # minimumElevationInMeters
  # maximumElevationInMeters
  # verbatimElevation
  # minimumDepthInMeters: Pressure tags collect depth info, but that info is not available in DB (until VRL files can be imported)
  # maximumDepthInMeters
  # verbatimDepth
  # minimumDistanceAboveSurfaceInMeters
  # maximumDistanceAboveSurfaceInMeters
  # locationAccordingTo
  # locationRemarks
  decimalLatitude = sprintf("%.5f", round(raw_latitude, digits = 5)),
  decimalLongitude = sprintf("%.5f", round(raw_longitude, digits = 5)),
  geodeticDatum = "WGS84",
  coordinateUncertaintyInMeters = "TODO", # Depends on area: sea / Westerscheldt: 200m on average, 500m extreme, while Albertkanaal: 2km
  # coordinatePrecision
  # pointRadiusSpatialFit
  # verbatimCoordinates
  # verbatimLatitude
  # verbatimLongitude
  # verbatimCoordinateSystem
  # verbatimSRS
  # footprintWKT
  # footprintSRS
  # footprintSpatialFit
  # georeferencedBy
  # georeferencedDate
  # georeferenceProtocol
  georeferenceSources = "GPS TODO", # Not always obtained by GPS, sometimes by map
  georeferenceVerificationStatus = "unverified",
  # georeferenceRemarks
) -> interim_data

#' GeologicalContext terms: not used
#' 
#' Identification terms: not used
#' 
#' Taxon terms:
interim_data %>% mutate(
  # taxonID
  # scientificNameID
  # acceptedNameUsageID
  # parentNameUsageID
  # originalNameUsageID
  # nameAccordingToID
  # namePublishedInID
  # taxonConceptID
  scientificName = raw_scientific_name,
  # acceptedNameUsage
  # parentNameUsage
  # originalNameUsage
  # nameAccordingTo
  # namePublishedIn
  # namePublishedInYear
  # higherClassification
  kingdom = "Animalia",
  # phylum
  # class
  # order
  # family
  # genus
  # subgenus
  # specificEpithet
  # infraspecificEpithet
  taxonRank = "species",
  # verbatimTaxonRank
  # scientificNameAuthorship
  vernacularName = case_when(
    .$raw_scientific_name == "Gadus morhua" ~ "Atlantic cod",
    .$raw_scientific_name == "Anguilla anguilla" ~ "European eel"
  )
  # nomenclaturalCode
  # taxonomicStatus
  # nomenclaturalStatus
  # taxonRemarks
) -> interim_data

#' Remove the original columns:
interim_data %>%
  select(-one_of(raw_colnames)) -> occurrence

#' Preview data:
kable(head(occurrence))
