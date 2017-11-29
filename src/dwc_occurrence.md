# Darwin Core mapping for occurrence dataset

Peter Desmet

2017-11-29

## Setup




Set locale (so we use UTF-8 character encoding):


```r
# This works on Mac OS X, might not work on other OS
Sys.setlocale("LC_CTYPE", "en_US.UTF-8")
```

```
## [1] "en_US.UTF-8"
```

Load libraries:


```r
library(tidyverse) # For data transformations

# None core tidyverse packages:
library(magrittr)  # For %<>% pipes

# Other packages
library(janitor)   # For cleaning input data
library(knitr)     # For nicer (kable) tables
```

Set file paths (all paths should be relative to this script):


```r
raw_data_file = "../data/raw/denormalized_observations_50000.csv"
processed_dwc_occurrence_file = "..data/processed/dwc_occurrence/occurrence.csv"
```

## Read data

Read the source data:


```r
raw_data <- read.csv(raw_data_file, fileEncoding = "UTF-8")
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



| raw_id|raw_receiver |raw_transmitter |raw_transmitter_name |raw_transmitter_serial |raw_sensor_value |raw_sensor_unit |raw_sensor2_value |raw_sensor2_unit |raw_station_name |raw_datetime        | raw_id_pk|raw_qc_flag |raw_file                   | raw_latitude| raw_longitude| raw_deployment_fk|raw_signal_to_noise_ratio |raw_detection_file_id |raw_tag_type |raw_tag_model |raw_tag_code_space |raw_tag_owner_pi |raw_tag_owner_organization | raw_tag_min_delay| raw_tag_max_delay|raw_tag_frequency |raw_acoustic_tag_type |raw_tag_sensor_type |raw_tag_intercept |raw_tag_slope |raw_sensor_value_depth_meters | raw_person_id|raw_animal_id |raw_scientific_name |raw_common_name | raw_length|raw_length_type |raw_length_units | raw_length2|raw_length2_type |raw_length2_units |raw_weight_units |raw_age |raw_age_units |raw_sex |raw_life_stage |raw_capture_location                                                                                                             |raw_capture_depth |raw_utc_release_date_time |raw_comments    |raw_est_tag_life |raw_wild_or_hatchery |raw_stock |raw_dna_sample_taken |raw_treatment_type |raw_dissolved_oxygen |raw_sedative |raw_sedative_concentration |raw_temperature_change |raw_holding_temperature |raw_preop_holding_period |raw_post_op_holding_period |raw_surgery_location |raw_date_of_surgery |raw_anaesthetic |raw_buffer |raw_anaesthetic_concentration |raw_buffer_concentration_in_anaesthetic |raw_anesthetic_concentration_in_recirculation |raw_buffer_concentration_in_recirculation | raw_id_pk_1|raw_catched_date_time | raw_tag_fk| raw_capture_latitude| raw_capture_longitude| raw_release_latitude| raw_release_longitude|raw_surgery_latitude |raw_surgery_longitude |raw_recapture_date |raw_implant_type |raw_implant_method |raw_date_modified   |raw_date_created    |raw_release_location | raw_length3|raw_length3_type |raw_length3_units | raw_length4|raw_length4_type |raw_length4_units | raw_weight|raw_end_date_tag |raw_capture_method | raw_project_fk|raw_animal_project |raw_animal_project_name |raw_animal_project_code | raw_animal_moratorium|raw_network_project |raw_network_project_name |raw_network_project_code | raw_network_moratorium|raw_deployment_station_name |raw_deployment_deploy_date_time |raw_deployment_location                        | raw_deployment_location_manager|raw_deployment_location_description            |raw_deployment_deploy_lat | raw_deployment_deploy_long| raw_deployment_recoverr_lat| raw_deployment_recover_long| raw_deployment_intended_lat| raw_deployment_intended_long|raw_deployment_bottom_depth |raw_deployment_riser_length |raw_deployment_instrument_depth | raw_receiver_serial_number|raw_receiver_model_number |raw_receiver_owner_organization |raw_receiver_status |raw_receiver_receiver_type |raw_receiver_manufacturer_fk |
|------:|:------------|:---------------|:--------------------|:----------------------|:----------------|:---------------|:-----------------|:----------------|:----------------|:-------------------|---------:|:-----------|:--------------------------|------------:|-------------:|-----------------:|:-------------------------|:---------------------|:------------|:-------------|:------------------|:----------------|:--------------------------|-----------------:|-----------------:|:-----------------|:---------------------|:-------------------|:-----------------|:-------------|:-----------------------------|-------------:|:-------------|:-------------------|:---------------|----------:|:---------------|:----------------|-----------:|:----------------|:-----------------|:----------------|:-------|:-------------|:-------|:--------------|:--------------------------------------------------------------------------------------------------------------------------------|:-----------------|:-------------------------|:---------------|:----------------|:--------------------|:---------|:--------------------|:------------------|:--------------------|:------------|:--------------------------|:----------------------|:-----------------------|:------------------------|:--------------------------|:--------------------|:-------------------|:---------------|:----------|:-----------------------------|:---------------------------------------|:---------------------------------------------|:-----------------------------------------|-----------:|:---------------------|----------:|--------------------:|---------------------:|--------------------:|---------------------:|:--------------------|:---------------------|:------------------|:----------------|:------------------|:-------------------|:-------------------|:--------------------|-----------:|:----------------|:-----------------|-----------:|:----------------|:-----------------|----------:|:----------------|:------------------|--------------:|:------------------|:-----------------------|:-----------------------|---------------------:|:-------------------|:------------------------|:------------------------|----------------------:|:---------------------------|:-------------------------------|:----------------------------------------------|-------------------------------:|:----------------------------------------------|:-------------------------|--------------------------:|---------------------------:|---------------------------:|---------------------------:|----------------------------:|:---------------------------|:---------------------------|:-------------------------------|--------------------------:|:-------------------------|:-------------------------------|:-------------------|:--------------------------|:----------------------------|
|      1|VR2W-120095  |A69-1601-34500  |NA                   |NA                     |NA               |NA              |NA                |NA               |120095           |2015-05-04 15:08:26 |  23235003|NA          |VR2W_120095_20150609_1.csv |     52.12614|       5.19245|              1454|NA                        |NA                    |internal     |V7-2x         |A69-1601-34500     |ANS MOUTON       |EVINBO                     |                15|                30|069k              |animal                |NA                  |NA                |NA            |NA                            |            40|              |Salmo salar         |NA              |       26.4|total length    |cm               |          NA|                 |                  |g                |NA      |NA            |        |               |Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. |NA                |2015-04-27 00:00:00       |; durif_index : |NA               |hatched              |NA        |NA                   |INTERNAL TAGGING   |NA                   |NA           |NA                         |NA                     |NA                      |NA                       |NA                         |                     |                    |                |NA         |                              |NA                                      |NA                                            |NA                                        |         539|2015-04-27 00:00:00   |        632|                   NA|                    NA|             50.61468|              5.604782|NA                   |NA                    |NA                 |NA               |NA                 |2016-02-02 11:28:21 |2016-02-02 11:28:21 |Grosses Battes       |          NA|                 |                  |          NA|                 |                  |      175.5|2015-06-30       |                   |             18|Albertkanaal       |Albertkanaal 2013       |albert2013              |                     1|Maas Nederland      |Maas Nederland           |maasnl                   |                      0|ma-2                        |2015-03-02 00:00:00             |LO stroomop stuw Borgharen, aan ingang vistrap |                               7|LO stroomop stuw Borgharen, aan ingang vistrap |50.865472                 |                   5.697744|                    52.12614|                     5.19245|                          NA|                           NA|NA                          |NA                          |NA                              |                     120095|VR2W                      |SVN                             |Active              |acoustic_telemetry         |1                            |
|      2|VR2W-120095  |A69-1601-34500  |NA                   |NA                     |NA               |NA              |NA                |NA               |120095           |2015-05-04 15:08:51 |  23235004|NA          |VR2W_120095_20150609_1.csv |     52.12614|       5.19245|              1454|NA                        |NA                    |internal     |V7-2x         |A69-1601-34500     |ANS MOUTON       |EVINBO                     |                15|                30|069k              |animal                |NA                  |NA                |NA            |NA                            |            40|              |Salmo salar         |NA              |       26.4|total length    |cm               |          NA|                 |                  |g                |NA      |NA            |        |               |Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. |NA                |2015-04-27 00:00:00       |; durif_index : |NA               |hatched              |NA        |NA                   |INTERNAL TAGGING   |NA                   |NA           |NA                         |NA                     |NA                      |NA                       |NA                         |                     |                    |                |NA         |                              |NA                                      |NA                                            |NA                                        |         539|2015-04-27 00:00:00   |        632|                   NA|                    NA|             50.61468|              5.604782|NA                   |NA                    |NA                 |NA               |NA                 |2016-02-02 11:28:21 |2016-02-02 11:28:21 |Grosses Battes       |          NA|                 |                  |          NA|                 |                  |      175.5|2015-06-30       |                   |             18|Albertkanaal       |Albertkanaal 2013       |albert2013              |                     1|Maas Nederland      |Maas Nederland           |maasnl                   |                      0|ma-2                        |2015-03-02 00:00:00             |LO stroomop stuw Borgharen, aan ingang vistrap |                               7|LO stroomop stuw Borgharen, aan ingang vistrap |50.865472                 |                   5.697744|                    52.12614|                     5.19245|                          NA|                           NA|NA                          |NA                          |NA                              |                     120095|VR2W                      |SVN                             |Active              |acoustic_telemetry         |1                            |
|      3|VR2W-120095  |A69-1601-34500  |NA                   |NA                     |NA               |NA              |NA                |NA               |120095           |2015-05-04 15:09:23 |  23235005|NA          |VR2W_120095_20150609_1.csv |     52.12614|       5.19245|              1454|NA                        |NA                    |internal     |V7-2x         |A69-1601-34500     |ANS MOUTON       |EVINBO                     |                15|                30|069k              |animal                |NA                  |NA                |NA            |NA                            |            40|              |Salmo salar         |NA              |       26.4|total length    |cm               |          NA|                 |                  |g                |NA      |NA            |        |               |Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. |NA                |2015-04-27 00:00:00       |; durif_index : |NA               |hatched              |NA        |NA                   |INTERNAL TAGGING   |NA                   |NA           |NA                         |NA                     |NA                      |NA                       |NA                         |                     |                    |                |NA         |                              |NA                                      |NA                                            |NA                                        |         539|2015-04-27 00:00:00   |        632|                   NA|                    NA|             50.61468|              5.604782|NA                   |NA                    |NA                 |NA               |NA                 |2016-02-02 11:28:21 |2016-02-02 11:28:21 |Grosses Battes       |          NA|                 |                  |          NA|                 |                  |      175.5|2015-06-30       |                   |             18|Albertkanaal       |Albertkanaal 2013       |albert2013              |                     1|Maas Nederland      |Maas Nederland           |maasnl                   |                      0|ma-2                        |2015-03-02 00:00:00             |LO stroomop stuw Borgharen, aan ingang vistrap |                               7|LO stroomop stuw Borgharen, aan ingang vistrap |50.865472                 |                   5.697744|                    52.12614|                     5.19245|                          NA|                           NA|NA                          |NA                          |NA                              |                     120095|VR2W                      |SVN                             |Active              |acoustic_telemetry         |1                            |
|      4|VR2W-120095  |A69-1601-34500  |NA                   |NA                     |NA               |NA              |NA                |NA               |120095           |2015-05-04 15:09:52 |  23235006|NA          |VR2W_120095_20150609_1.csv |     52.12614|       5.19245|              1454|NA                        |NA                    |internal     |V7-2x         |A69-1601-34500     |ANS MOUTON       |EVINBO                     |                15|                30|069k              |animal                |NA                  |NA                |NA            |NA                            |            40|              |Salmo salar         |NA              |       26.4|total length    |cm               |          NA|                 |                  |g                |NA      |NA            |        |               |Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. |NA                |2015-04-27 00:00:00       |; durif_index : |NA               |hatched              |NA        |NA                   |INTERNAL TAGGING   |NA                   |NA           |NA                         |NA                     |NA                      |NA                       |NA                         |                     |                    |                |NA         |                              |NA                                      |NA                                            |NA                                        |         539|2015-04-27 00:00:00   |        632|                   NA|                    NA|             50.61468|              5.604782|NA                   |NA                    |NA                 |NA               |NA                 |2016-02-02 11:28:21 |2016-02-02 11:28:21 |Grosses Battes       |          NA|                 |                  |          NA|                 |                  |      175.5|2015-06-30       |                   |             18|Albertkanaal       |Albertkanaal 2013       |albert2013              |                     1|Maas Nederland      |Maas Nederland           |maasnl                   |                      0|ma-2                        |2015-03-02 00:00:00             |LO stroomop stuw Borgharen, aan ingang vistrap |                               7|LO stroomop stuw Borgharen, aan ingang vistrap |50.865472                 |                   5.697744|                    52.12614|                     5.19245|                          NA|                           NA|NA                          |NA                          |NA                              |                     120095|VR2W                      |SVN                             |Active              |acoustic_telemetry         |1                            |
|      5|VR2W-120095  |A69-1601-34500  |NA                   |NA                     |NA               |NA              |NA                |NA               |120095           |2015-05-04 15:10:17 |  23235007|NA          |VR2W_120095_20150609_1.csv |     52.12614|       5.19245|              1454|NA                        |NA                    |internal     |V7-2x         |A69-1601-34500     |ANS MOUTON       |EVINBO                     |                15|                30|069k              |animal                |NA                  |NA                |NA            |NA                            |            40|              |Salmo salar         |NA              |       26.4|total length    |cm               |          NA|                 |                  |g                |NA      |NA            |        |               |Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. |NA                |2015-04-27 00:00:00       |; durif_index : |NA               |hatched              |NA        |NA                   |INTERNAL TAGGING   |NA                   |NA           |NA                         |NA                     |NA                      |NA                       |NA                         |                     |                    |                |NA         |                              |NA                                      |NA                                            |NA                                        |         539|2015-04-27 00:00:00   |        632|                   NA|                    NA|             50.61468|              5.604782|NA                   |NA                    |NA                 |NA               |NA                 |2016-02-02 11:28:21 |2016-02-02 11:28:21 |Grosses Battes       |          NA|                 |                  |          NA|                 |                  |      175.5|2015-06-30       |                   |             18|Albertkanaal       |Albertkanaal 2013       |albert2013              |                     1|Maas Nederland      |Maas Nederland           |maasnl                   |                      0|ma-2                        |2015-03-02 00:00:00             |LO stroomop stuw Borgharen, aan ingang vistrap |                               7|LO stroomop stuw Borgharen, aan ingang vistrap |50.865472                 |                   5.697744|                    52.12614|                     5.19245|                          NA|                           NA|NA                          |NA                          |NA                              |                     120095|VR2W                      |SVN                             |Active              |acoustic_telemetry         |1                            |
|      6|VR2W-120095  |A69-1601-34500  |NA                   |NA                     |NA               |NA              |NA                |NA               |120095           |2015-05-04 15:12:18 |  23235008|NA          |VR2W_120095_20150609_1.csv |     52.12614|       5.19245|              1454|NA                        |NA                    |internal     |V7-2x         |A69-1601-34500     |ANS MOUTON       |EVINBO                     |                15|                30|069k              |animal                |NA                  |NA                |NA            |NA                            |            40|              |Salmo salar         |NA              |       26.4|total length    |cm               |          NA|                 |                  |g                |NA      |NA            |        |               |Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. |NA                |2015-04-27 00:00:00       |; durif_index : |NA               |hatched              |NA        |NA                   |INTERNAL TAGGING   |NA                   |NA           |NA                         |NA                     |NA                      |NA                       |NA                         |                     |                    |                |NA         |                              |NA                                      |NA                                            |NA                                        |         539|2015-04-27 00:00:00   |        632|                   NA|                    NA|             50.61468|              5.604782|NA                   |NA                    |NA                 |NA               |NA                 |2016-02-02 11:28:21 |2016-02-02 11:28:21 |Grosses Battes       |          NA|                 |                  |          NA|                 |                  |      175.5|2015-06-30       |                   |             18|Albertkanaal       |Albertkanaal 2013       |albert2013              |                     1|Maas Nederland      |Maas Nederland           |maasnl                   |                      0|ma-2                        |2015-03-02 00:00:00             |LO stroomop stuw Borgharen, aan ingang vistrap |                               7|LO stroomop stuw Borgharen, aan ingang vistrap |50.865472                 |                   5.697744|                    52.12614|                     5.19245|                          NA|                           NA|NA                          |NA                          |NA                              |                     120095|VR2W                      |SVN                             |Active              |acoustic_telemetry         |1                            |

## Create occurrence core

### Pre-processing


```r
occurrence <- raw_data
```

Sort by transmitter and date:


```r
occurrence %<>% arrange(raw_transmitter, raw_datetime)
```

### Term mapping

Map the source data to [Darwin Core Occurrence](http://rs.gbif.org/core/dwc_occurrence_2015-07-02.xml) (but in the classic Darwin Core order):
#### type


```r
occurrence %<>% mutate(type = "Event")
```

#### modified
#### language


```r
occurrence %<>% mutate(language = "en")
```

#### license


```r
occurrence %<>% mutate(license = "http://creativecommons.org/publicdomain/zero/1.0/")
```

#### rightsHolder
#### accessRights


```r
occurrence %<>% mutate(accessRights = "http://www.inbo.be/en/norms-for-data-use")
```

#### bibliographicCitation
#### references
#### institutionID
#### collectionID
#### datasetID
#### institutionCode
#### collectionCode
#### datasetName
#### ownerInstitutionCode
#### basisOfRecord
#### informationWithheld
#### dataGeneralizations
#### dynamicProperties
#### occurrenceID
#### catalogNumber
#### recordNumber
#### recordedBy
#### individualCount
#### organismQuantity
#### organismQuantityType
#### sex
#### lifeStage
#### reproductiveCondition
#### behavior
#### establishmentMeans
#### occurrenceStatus
#### preparations
#### disposition
#### associatedMedia
#### associatedReferences
#### associatedSequences
#### associatedTaxa
#### otherCatalogNumbers
#### occurrenceRemarks
#### organismID
#### organismName
#### organismScope
#### associatedOccurrences
#### associatedOrganisms
#### previousIdentifications
#### organismRemarks
#### materialSampleID
#### eventID
#### parentEventID
#### fieldNumber
#### eventDate
#### eventTime
#### startDayOfYear
#### endDayOfYear
#### year
#### month
#### day
#### verbatimEventDate
#### habitat
#### samplingProtocol
#### sampleSizeValue
#### sampleSizeUnit
#### samplingEffort
#### fieldNotes
#### eventRemarks
#### locationID
#### higherGeographyID
#### higherGeography
#### continent
#### waterBody
#### islandGroup
#### island
#### country
#### countryCode
#### stateProvince
#### county
#### municipality
#### locality
#### verbatimLocality
#### minimumElevationInMeters
#### maximumElevationInMeters
#### verbatimElevation
#### minimumDepthInMeters
#### maximumDepthInMeters
#### verbatimDepth
#### minimumDistanceAboveSurfaceInMeters
#### maximumDistanceAboveSurfaceInMeters
#### locationAccordingTo
#### locationRemarks
#### decimalLatitude
#### decimalLongitude
#### geodeticDatum
#### coordinateUncertaintyInMeters
#### coordinatePrecision
#### pointRadiusSpatialFit
#### verbatimCoordinates
#### verbatimLatitude
#### verbatimLongitude
#### verbatimCoordinateSystem
#### verbatimSRS
#### footprintWKT
#### footprintSRS
#### footprintSpatialFit
#### georeferencedBy
#### georeferencedDate
#### georeferenceProtocol
#### georeferenceSources
#### georeferenceVerificationStatus
#### georeferenceRemarks
#### geologicalContextID
#### earliestEonOrLowestEonothem
#### latestEonOrHighestEonothem
#### earliestEraOrLowestErathem
#### latestEraOrHighestErathem
#### earliestPeriodOrLowestSystem
#### latestPeriodOrHighestSystem
#### earliestEpochOrLowestSeries
#### latestEpochOrHighestSeries
#### earliestAgeOrLowestStage
#### latestAgeOrHighestStage
#### lowestBiostratigraphicZone
#### highestBiostratigraphicZone
#### lithostratigraphicTerms
#### group
#### formation
#### member
#### bed
#### identificationID
#### identificationQualifier
#### typeStatus
#### identifiedBy
#### dateIdentified
#### identificationReferences
#### identificationVerificationStatus
#### identificationRemarks
#### taxonID
#### scientificNameID
#### acceptedNameUsageID
#### parentNameUsageID
#### originalNameUsageID
#### nameAccordingToID
#### namePublishedInID
#### taxonConceptID
#### scientificName
#### acceptedNameUsage
#### parentNameUsage
#### originalNameUsage
#### nameAccordingTo
#### namePublishedIn
#### namePublishedInYear
#### higherClassification
#### kingdom
#### phylum
#### class
#### order
#### family
#### genus
#### subgenus
#### specificEpithet
#### infraspecificEpithet
#### taxonRank
#### verbatimTaxonRank
#### scientificNameAuthorship
#### vernacularName
#### nomenclaturalCode
#### taxonomicStatus
#### nomenclaturalStatus
#### taxonRemarks

### Post-processing

Remove the original columns:


```r
occurrence %<>% select(-one_of(raw_colnames))
```

Preview data:


```r
kable(head(occurrence))
```



|type  |language |license                                           |accessRights                             |
|:-----|:--------|:-------------------------------------------------|:----------------------------------------|
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |http://www.inbo.be/en/norms-for-data-use |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |http://www.inbo.be/en/norms-for-data-use |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |http://www.inbo.be/en/norms-for-data-use |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |http://www.inbo.be/en/norms-for-data-use |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |http://www.inbo.be/en/norms-for-data-use |
|Event |en       |http://creativecommons.org/publicdomain/zero/1.0/ |http://www.inbo.be/en/norms-for-data-use |

