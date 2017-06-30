# Mapping fish tracking data to Darwin Core Occurrence

Peter Desmet
2017-07-01

## Setup




Load libraries:


```r
library(tidyverse) # For data transformations
library(janitor)   # For cleaning input data
library(knitr)     # For nicer (kable) tables
```

Set file paths (all paths should be relative to this script):


```r
raw_data_file = "../data/raw/20170516_etn_sample_detections_view.csv"
processed_dwc_occurrence_file = "..data/processed/dwc_occurrence/occurrence.csv"
```

## Read data

Read the source data:


```r
raw_data <- read.csv(raw_data_file)
```

Clean data somewhat:


```r
raw_data %>%
  # Remove empty rows
  remove_empty_rows() %>%
  # Have sensible (lowercase) column names
  clean_names() -> raw_data
```

Add prefix `raw_` to all column names to avoid name clashes with Darwin Core terms:


```r
colnames(raw_data) <- paste0("raw_", colnames(raw_data))
```

Save those column names as a list (makes it easier to remove them all later):


```r
raw_colnames <- colnames(raw_data)
```

Preview data:


```r
kable(head(raw_data))
```



| raw_x|raw_receiver |raw_transmitter |raw_transmitter_name |raw_transmitter_serial |raw_sensor_value |raw_sensor_unit |raw_sensor2_value |raw_sensor2_unit |raw_station_name |raw_datetime        | raw_id_pk|raw_qc_flag |raw_file                    | raw_latitude| raw_longitude| raw_deployment_fk|raw_scientific_name |raw_location_name |raw_deployment_station_name |raw_deploy_date_time |raw_animal_project |raw_animal_project_name |raw_animal_project_code | raw_animal_moratorium|raw_network_project |raw_network_project_name |raw_network_project_code | raw_network_moratorium|raw_signal_to_noise_ratio |raw_detection_file_id |
|-----:|:------------|:---------------|:--------------------|:----------------------|:----------------|:---------------|:-----------------|:----------------|:----------------|:-------------------|---------:|:-----------|:---------------------------|------------:|-------------:|-----------------:|:-------------------|:-----------------|:---------------------------|:--------------------|:------------------|:-----------------------|:-----------------------|---------------------:|:-------------------|:------------------------|:------------------------|----------------------:|:-------------------------|:---------------------|
|     1|VR2AR-545718 |A69-1601-60511  |NA                   |NA                     |NA               |NA              |NA                |NA               |CNB05            |2016-10-25 14:58:29 |  34485917|NA          |VR2AR_545718_20161027_1.csv |     51.67029|       2.80098|              2209|Built-in            |bpns-CNB05        |bpns-CNB05                  |2016-09-20           |rangetest          |rangetest               |rangetest               |                     1|BPNS                |BPNS                     |bpns                     |                      0|NA                        |NA                    |
|     2|VR2AR-545718 |A69-1601-60511  |NA                   |NA                     |NA               |NA              |NA                |NA               |CNB05            |2016-10-25 15:07:41 |  34485919|NA          |VR2AR_545718_20161027_1.csv |     51.67029|       2.80098|              2209|Built-in            |bpns-CNB05        |bpns-CNB05                  |2016-09-20           |rangetest          |rangetest               |rangetest               |                     1|BPNS                |BPNS                     |bpns                     |                      0|NA                        |NA                    |
|     3|VR2AR-545718 |A69-1601-60511  |NA                   |NA                     |NA               |NA              |NA                |NA               |CNB05            |2016-10-25 15:17:03 |  34485920|NA          |VR2AR_545718_20161027_1.csv |     51.67029|       2.80098|              2209|Built-in            |bpns-CNB05        |bpns-CNB05                  |2016-09-20           |rangetest          |rangetest               |rangetest               |                     1|BPNS                |BPNS                     |bpns                     |                      0|NA                        |NA                    |
|     4|VR2AR-545718 |A69-1601-60511  |NA                   |NA                     |NA               |NA              |NA                |NA               |CNB05            |2016-10-25 15:26:43 |  34485922|NA          |VR2AR_545718_20161027_1.csv |     51.67029|       2.80098|              2209|Built-in            |bpns-CNB05        |bpns-CNB05                  |2016-09-20           |rangetest          |rangetest               |rangetest               |                     1|BPNS                |BPNS                     |bpns                     |                      0|NA                        |NA                    |
|     5|VR2AR-545718 |A69-1601-60511  |NA                   |NA                     |NA               |NA              |NA                |NA               |CNB05            |2016-10-25 15:37:01 |  34485925|NA          |VR2AR_545718_20161027_1.csv |     51.67029|       2.80098|              2209|Built-in            |bpns-CNB05        |bpns-CNB05                  |2016-09-20           |rangetest          |rangetest               |rangetest               |                     1|BPNS                |BPNS                     |bpns                     |                      0|NA                        |NA                    |
|     6|VR2AR-545718 |A69-1601-60507  |NA                   |NA                     |NA               |NA              |NA                |NA               |CNB05            |2016-10-25 16:00:34 |  34485929|NA          |VR2AR_545718_20161027_1.csv |     51.67029|       2.80098|              2209|Built-in            |bpns-CNB05        |bpns-CNB05                  |2016-09-20           |rangetest          |rangetest               |rangetest               |                     1|BPNS                |BPNS                     |bpns                     |                      0|NA                        |NA                    |

## Create occurrence core

Map the source data to [Darwin Core Occurrence](http://rs.gbif.org/core/dwc_occurrence_2015-07-02.xml):


```r
raw_data %>%
  arrange(raw_transmitter, raw_datetime) -> interim_occurrence
```

Record-level terms:


```r
interim_occurrence %>% mutate(
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
) -> interim_occurrence
```

Occurrence terms:


```r
interim_occurrence %>% mutate(
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
) -> interim_occurrence
```

Organism terms:


```r
interim_occurrence %>% mutate(
  organismID = "TODO", # Should not be transmitterID, as that one can be replaced/reused. Find a good animalID
  # organismName
  # organismScope
  # associatedOccurrences
  # associatedOrganisms
  # previousIdentifications
  # organismRemarks
) -> interim_occurrence
```

MaterialSample terms: not used

Event terms:


```r
interim_occurrence %>% mutate(
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
) -> interim_occurrence
```

Location terms:


```r
interim_occurrence %>% mutate(
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
) -> interim_occurrence
```

GeologicalContext terms: not used

Identification terms: not used

Taxon terms:


```r
interim_occurrence %>% mutate(
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
) -> interim_occurrence
```

Remove the original columns:


```r
interim_occurrence %>%
  select(-one_of(raw_colnames)) -> occurrence
```

Preview data:


```r
kable(head(occurrence))
```



|id   |type  |language |license                                           |rightsHolder |accessRights                             |datasetID |institutionCode |datasetName |basisOfRecord      |informationWithheld |dynamicProperties |occurrenceID |sex  |lifeStage |organismID |eventDate           |samplingProtocol |locationID |waterBody  |countryCode |decimalLatitude |decimalLongitude |geodeticDatum |coordinateUncertaintyInMeters |georeferenceSources |georeferenceVerificationStatus |scientificName    |kingdom  |taxonRank |vernacularName |
|:----|:-----|:--------|:-------------------------------------------------|:------------|:----------------------------------------|:---------|:---------------|:-----------|:------------------|:-------------------|:-----------------|:------------|:----|:---------|:----------|:-------------------|:----------------|:----------|:----------|:-----------|:---------------|:----------------|:-------------|:-----------------------------|:-------------------|:------------------------------|:-----------------|:--------|:---------|:--------------|
|TODO |Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |TODO         |http://www.inbo.be/en/norms-for-data-use |TODO      |TODO            |TODO        |MachineObservation |see metadata        |                  |TODO         |TODO |TODO      |TODO       |2016-04-05 22:36:49 |TODO             |HH7        |TODO maybe |TODO maybe  |0.00000         |0.00000          |WGS84         |TODO                          |GPS TODO            |unverified                     |Anguilla anguilla |Animalia |species   |European eel   |
|TODO |Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |TODO         |http://www.inbo.be/en/norms-for-data-use |TODO      |TODO            |TODO        |MachineObservation |see metadata        |                  |TODO         |TODO |TODO      |TODO       |2016-04-05 22:38:33 |TODO             |HH7        |TODO maybe |TODO maybe  |0.00000         |0.00000          |WGS84         |TODO                          |GPS TODO            |unverified                     |Anguilla anguilla |Animalia |species   |European eel   |
|TODO |Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |TODO         |http://www.inbo.be/en/norms-for-data-use |TODO      |TODO            |TODO        |MachineObservation |see metadata        |                  |TODO         |TODO |TODO      |TODO       |2016-04-05 22:39:06 |TODO             |HH7        |TODO maybe |TODO maybe  |0.00000         |0.00000          |WGS84         |TODO                          |GPS TODO            |unverified                     |Anguilla anguilla |Animalia |species   |European eel   |
|TODO |Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |TODO         |http://www.inbo.be/en/norms-for-data-use |TODO      |TODO            |TODO        |MachineObservation |see metadata        |                  |TODO         |TODO |TODO      |TODO       |2016-04-05 22:39:36 |TODO             |HH7        |TODO maybe |TODO maybe  |0.00000         |0.00000          |WGS84         |TODO                          |GPS TODO            |unverified                     |Anguilla anguilla |Animalia |species   |European eel   |
|TODO |Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |TODO         |http://www.inbo.be/en/norms-for-data-use |TODO      |TODO            |TODO        |MachineObservation |see metadata        |                  |TODO         |TODO |TODO      |TODO       |2016-04-05 22:39:58 |TODO             |HH7        |TODO maybe |TODO maybe  |0.00000         |0.00000          |WGS84         |TODO                          |GPS TODO            |unverified                     |Anguilla anguilla |Animalia |species   |European eel   |
|TODO |Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |TODO         |http://www.inbo.be/en/norms-for-data-use |TODO      |TODO            |TODO        |MachineObservation |see metadata        |                  |TODO         |TODO |TODO      |TODO       |2016-04-05 22:40:21 |TODO             |HH7        |TODO maybe |TODO maybe  |0.00000         |0.00000          |WGS84         |TODO                          |GPS TODO            |unverified                     |Anguilla anguilla |Animalia |species   |European eel   |

