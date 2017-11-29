# Darwin Core mapping for occurrence dataset

By: Peter Desmet

Date: `r Sys.Date()`

## Setup

Set locale (so we use UTF-8 character encoding):

``` r
# This works on Mac OS X, might not work on other OS
Sys.setlocale("LC_CTYPE", "en_US.UTF-8")
```

    ## [1] "en_US.UTF-8"

Load libraries:

``` r
library(tidyverse) # For data transformations

# None core tidyverse packages:
library(magrittr)  # For %<>% pipes

# Other packages
library(janitor)   # For cleaning input data
library(knitr)     # For nicer (kable) tables
```

Set file paths (all paths should be relative to this script):

``` r
raw_data_file = "../data/raw/denormalized_observations_50000.csv"
processed_dwc_occurrence_file = "..data/processed/dwc_occurrence/occurrence.csv"
```

## Read data

Read the source data:

``` r
raw_data <- read.csv(raw_data_file, fileEncoding = "UTF-8")
```

Clean data somewhat:

``` r
raw_data %>%
  # Remove empty rows
  remove_empty_rows() %>%
  # Have sensible (lowercase) column names
  clean_names() -> raw_data
```

Add prefix `raw_` to all column names to avoid name clashes with Darwin Core terms:

``` r
colnames(raw_data) <- paste0("raw_", colnames(raw_data))
```

Save those column names as a list (makes it easier to remove them all later):

``` r
raw_colnames <- colnames(raw_data)
```

Preview data:

``` r
kable(head(raw_data))
```

|  raw\_id| raw\_receiver | raw\_transmitter | raw\_transmitter\_name | raw\_transmitter\_serial | raw\_sensor\_value | raw\_sensor\_unit | raw\_sensor2\_value | raw\_sensor2\_unit | raw\_station\_name | raw\_datetime       |  raw\_id\_pk| raw\_qc\_flag | raw\_file                     |  raw\_latitude|  raw\_longitude|  raw\_deployment\_fk| raw\_signal\_to\_noise\_ratio | raw\_detection\_file\_id | raw\_tag\_type | raw\_tag\_model | raw\_tag\_code\_space | raw\_tag\_owner\_pi | raw\_tag\_owner\_organization |  raw\_tag\_min\_delay|  raw\_tag\_max\_delay| raw\_tag\_frequency | raw\_acoustic\_tag\_type | raw\_tag\_sensor\_type | raw\_tag\_intercept | raw\_tag\_slope | raw\_sensor\_value\_depth\_meters |  raw\_person\_id| raw\_animal\_id | raw\_scientific\_name | raw\_common\_name |  raw\_length| raw\_length\_type | raw\_length\_units |  raw\_length2| raw\_length2\_type | raw\_length2\_units | raw\_weight\_units | raw\_age | raw\_age\_units | raw\_sex | raw\_life\_stage | raw\_capture\_location                                                                                                           | raw\_capture\_depth | raw\_utc\_release\_date\_time | raw\_comments    | raw\_est\_tag\_life | raw\_wild\_or\_hatchery | raw\_stock | raw\_dna\_sample\_taken | raw\_treatment\_type | raw\_dissolved\_oxygen | raw\_sedative | raw\_sedative\_concentration | raw\_temperature\_change | raw\_holding\_temperature | raw\_preop\_holding\_period | raw\_post\_op\_holding\_period | raw\_surgery\_location | raw\_date\_of\_surgery | raw\_anaesthetic | raw\_buffer | raw\_anaesthetic\_concentration | raw\_buffer\_concentration\_in\_anaesthetic | raw\_anesthetic\_concentration\_in\_recirculation | raw\_buffer\_concentration\_in\_recirculation |  raw\_id\_pk\_1| raw\_catched\_date\_time |  raw\_tag\_fk|  raw\_capture\_latitude|  raw\_capture\_longitude|  raw\_release\_latitude|  raw\_release\_longitude| raw\_surgery\_latitude | raw\_surgery\_longitude | raw\_recapture\_date | raw\_implant\_type | raw\_implant\_method | raw\_date\_modified | raw\_date\_created  | raw\_release\_location |  raw\_length3| raw\_length3\_type | raw\_length3\_units |  raw\_length4| raw\_length4\_type | raw\_length4\_units |  raw\_weight| raw\_end\_date\_tag | raw\_capture\_method |  raw\_project\_fk| raw\_animal\_project | raw\_animal\_project\_name | raw\_animal\_project\_code |  raw\_animal\_moratorium| raw\_network\_project | raw\_network\_project\_name | raw\_network\_project\_code |  raw\_network\_moratorium| raw\_deployment\_station\_name | raw\_deployment\_deploy\_date\_time | raw\_deployment\_location                      |  raw\_deployment\_location\_manager| raw\_deployment\_location\_description         | raw\_deployment\_deploy\_lat |  raw\_deployment\_deploy\_long|  raw\_deployment\_recoverr\_lat|  raw\_deployment\_recover\_long|  raw\_deployment\_intended\_lat|  raw\_deployment\_intended\_long| raw\_deployment\_bottom\_depth | raw\_deployment\_riser\_length | raw\_deployment\_instrument\_depth |  raw\_receiver\_serial\_number| raw\_receiver\_model\_number | raw\_receiver\_owner\_organization | raw\_receiver\_status | raw\_receiver\_receiver\_type | raw\_receiver\_manufacturer\_fk |
|--------:|:--------------|:-----------------|:-----------------------|:-------------------------|:-------------------|:------------------|:--------------------|:-------------------|:-------------------|:--------------------|------------:|:--------------|:------------------------------|--------------:|---------------:|--------------------:|:------------------------------|:-------------------------|:---------------|:----------------|:----------------------|:--------------------|:------------------------------|---------------------:|---------------------:|:--------------------|:-------------------------|:-----------------------|:--------------------|:----------------|:----------------------------------|----------------:|:----------------|:----------------------|:------------------|------------:|:------------------|:-------------------|-------------:|:-------------------|:--------------------|:-------------------|:---------|:----------------|:---------|:-----------------|:---------------------------------------------------------------------------------------------------------------------------------|:--------------------|:------------------------------|:-----------------|:--------------------|:------------------------|:-----------|:------------------------|:---------------------|:-----------------------|:--------------|:-----------------------------|:-------------------------|:--------------------------|:----------------------------|:-------------------------------|:-----------------------|:-----------------------|:-----------------|:------------|:--------------------------------|:--------------------------------------------|:--------------------------------------------------|:----------------------------------------------|---------------:|:-------------------------|-------------:|-----------------------:|------------------------:|-----------------------:|------------------------:|:-----------------------|:------------------------|:---------------------|:-------------------|:---------------------|:--------------------|:--------------------|:-----------------------|-------------:|:-------------------|:--------------------|-------------:|:-------------------|:--------------------|------------:|:--------------------|:---------------------|-----------------:|:---------------------|:---------------------------|:---------------------------|------------------------:|:----------------------|:----------------------------|:----------------------------|-------------------------:|:-------------------------------|:------------------------------------|:-----------------------------------------------|-----------------------------------:|:-----------------------------------------------|:-----------------------------|------------------------------:|-------------------------------:|-------------------------------:|-------------------------------:|--------------------------------:|:-------------------------------|:-------------------------------|:-----------------------------------|------------------------------:|:-----------------------------|:-----------------------------------|:----------------------|:------------------------------|:--------------------------------|
|        1| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:08:26 |     23235003| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap | 50.865472                    |                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           | 1                               |
|        2| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:08:51 |     23235004| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap | 50.865472                    |                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           | 1                               |
|        3| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:09:23 |     23235005| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap | 50.865472                    |                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           | 1                               |
|        4| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:09:52 |     23235006| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap | 50.865472                    |                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           | 1                               |
|        5| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:10:17 |     23235007| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap | 50.865472                    |                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           | 1                               |
|        6| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:12:18 |     23235008| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap | 50.865472                    |                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           | 1                               |

## Create occurrence core

### Pre-processing

``` r
occurrence <- raw_data
```

Sort by transmitter and date:

``` r
occurrence %<>% arrange(raw_transmitter, raw_datetime)
```

### Term mapping

Map the source data to [Darwin Core Occurrence](http://rs.gbif.org/core/dwc_occurrence_2015-07-02.xml) (but in the classic Darwin Core order):

#### type

``` r
occurrence %<>% mutate(type = "Event")
```

#### modified

#### language

``` r
occurrence %<>% mutate(language = "en")
```

#### license

``` r
occurrence %<>% mutate(license = "http://creativecommons.org/publicdomain/zero/1.0/")
```

#### rightsHolder

#### accessRights

``` r
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

``` r
occurrence %<>% select(-one_of(raw_colnames))
```

Preview data:

``` r
kable(head(occurrence))
```

| type  | language | license                                             | accessRights                               |
|:------|:---------|:----------------------------------------------------|:-------------------------------------------|
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | <http://www.inbo.be/en/norms-for-data-use> |
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | <http://www.inbo.be/en/norms-for-data-use> |
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | <http://www.inbo.be/en/norms-for-data-use> |
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | <http://www.inbo.be/en/norms-for-data-use> |
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | <http://www.inbo.be/en/norms-for-data-use> |
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | <http://www.inbo.be/en/norms-for-data-use> |
