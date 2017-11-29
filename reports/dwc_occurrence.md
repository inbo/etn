# Darwin Core mapping for occurrence dataset

By: Peter Desmet

Date: 2017-11-30

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
library(stringr)   # For string manipulation

# Other packages
library(janitor)   # For cleaning input data
library(knitr)     # For nicer (kable) tables
```

Set file paths (all paths should be relative to this script):

``` r
raw_data_file = "../data/input/denormalized_observations_50000.csv"
dwc_occurrence_file = "../data/output/dwc_occurrence/occurrence.csv"
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

List all fields:

``` r
raw_colnames
```

    ##   [1] "raw_id"                                       
    ##   [2] "raw_receiver"                                 
    ##   [3] "raw_transmitter"                              
    ##   [4] "raw_transmitter_name"                         
    ##   [5] "raw_transmitter_serial"                       
    ##   [6] "raw_sensor_value"                             
    ##   [7] "raw_sensor_unit"                              
    ##   [8] "raw_sensor2_value"                            
    ##   [9] "raw_sensor2_unit"                             
    ##  [10] "raw_station_name"                             
    ##  [11] "raw_datetime"                                 
    ##  [12] "raw_id_pk"                                    
    ##  [13] "raw_qc_flag"                                  
    ##  [14] "raw_file"                                     
    ##  [15] "raw_latitude"                                 
    ##  [16] "raw_longitude"                                
    ##  [17] "raw_deployment_fk"                            
    ##  [18] "raw_signal_to_noise_ratio"                    
    ##  [19] "raw_detection_file_id"                        
    ##  [20] "raw_tag_type"                                 
    ##  [21] "raw_tag_model"                                
    ##  [22] "raw_tag_code_space"                           
    ##  [23] "raw_tag_owner_pi"                             
    ##  [24] "raw_tag_owner_organization"                   
    ##  [25] "raw_tag_min_delay"                            
    ##  [26] "raw_tag_max_delay"                            
    ##  [27] "raw_tag_frequency"                            
    ##  [28] "raw_acoustic_tag_type"                        
    ##  [29] "raw_tag_sensor_type"                          
    ##  [30] "raw_tag_intercept"                            
    ##  [31] "raw_tag_slope"                                
    ##  [32] "raw_sensor_value_depth_meters"                
    ##  [33] "raw_person_id"                                
    ##  [34] "raw_animal_id"                                
    ##  [35] "raw_scientific_name"                          
    ##  [36] "raw_common_name"                              
    ##  [37] "raw_length"                                   
    ##  [38] "raw_length_type"                              
    ##  [39] "raw_length_units"                             
    ##  [40] "raw_length2"                                  
    ##  [41] "raw_length2_type"                             
    ##  [42] "raw_length2_units"                            
    ##  [43] "raw_weight_units"                             
    ##  [44] "raw_age"                                      
    ##  [45] "raw_age_units"                                
    ##  [46] "raw_sex"                                      
    ##  [47] "raw_life_stage"                               
    ##  [48] "raw_capture_location"                         
    ##  [49] "raw_capture_depth"                            
    ##  [50] "raw_utc_release_date_time"                    
    ##  [51] "raw_comments"                                 
    ##  [52] "raw_est_tag_life"                             
    ##  [53] "raw_wild_or_hatchery"                         
    ##  [54] "raw_stock"                                    
    ##  [55] "raw_dna_sample_taken"                         
    ##  [56] "raw_treatment_type"                           
    ##  [57] "raw_dissolved_oxygen"                         
    ##  [58] "raw_sedative"                                 
    ##  [59] "raw_sedative_concentration"                   
    ##  [60] "raw_temperature_change"                       
    ##  [61] "raw_holding_temperature"                      
    ##  [62] "raw_preop_holding_period"                     
    ##  [63] "raw_post_op_holding_period"                   
    ##  [64] "raw_surgery_location"                         
    ##  [65] "raw_date_of_surgery"                          
    ##  [66] "raw_anaesthetic"                              
    ##  [67] "raw_buffer"                                   
    ##  [68] "raw_anaesthetic_concentration"                
    ##  [69] "raw_buffer_concentration_in_anaesthetic"      
    ##  [70] "raw_anesthetic_concentration_in_recirculation"
    ##  [71] "raw_buffer_concentration_in_recirculation"    
    ##  [72] "raw_id_pk_1"                                  
    ##  [73] "raw_catched_date_time"                        
    ##  [74] "raw_tag_fk"                                   
    ##  [75] "raw_capture_latitude"                         
    ##  [76] "raw_capture_longitude"                        
    ##  [77] "raw_release_latitude"                         
    ##  [78] "raw_release_longitude"                        
    ##  [79] "raw_surgery_latitude"                         
    ##  [80] "raw_surgery_longitude"                        
    ##  [81] "raw_recapture_date"                           
    ##  [82] "raw_implant_type"                             
    ##  [83] "raw_implant_method"                           
    ##  [84] "raw_date_modified"                            
    ##  [85] "raw_date_created"                             
    ##  [86] "raw_release_location"                         
    ##  [87] "raw_length3"                                  
    ##  [88] "raw_length3_type"                             
    ##  [89] "raw_length3_units"                            
    ##  [90] "raw_length4"                                  
    ##  [91] "raw_length4_type"                             
    ##  [92] "raw_length4_units"                            
    ##  [93] "raw_weight"                                   
    ##  [94] "raw_end_date_tag"                             
    ##  [95] "raw_capture_method"                           
    ##  [96] "raw_project_fk"                               
    ##  [97] "raw_animal_project"                           
    ##  [98] "raw_animal_project_name"                      
    ##  [99] "raw_animal_project_code"                      
    ## [100] "raw_animal_moratorium"                        
    ## [101] "raw_network_project"                          
    ## [102] "raw_network_project_name"                     
    ## [103] "raw_network_project_code"                     
    ## [104] "raw_network_moratorium"                       
    ## [105] "raw_deployment_station_name"                  
    ## [106] "raw_deployment_deploy_date_time"              
    ## [107] "raw_deployment_location"                      
    ## [108] "raw_deployment_location_manager"              
    ## [109] "raw_deployment_location_description"          
    ## [110] "raw_deployment_deploy_lat"                    
    ## [111] "raw_deployment_deploy_long"                   
    ## [112] "raw_deployment_recoverr_lat"                  
    ## [113] "raw_deployment_recover_long"                  
    ## [114] "raw_deployment_intended_lat"                  
    ## [115] "raw_deployment_intended_long"                 
    ## [116] "raw_deployment_bottom_depth"                  
    ## [117] "raw_deployment_riser_length"                  
    ## [118] "raw_deployment_instrument_depth"              
    ## [119] "raw_receiver_serial_number"                   
    ## [120] "raw_receiver_model_number"                    
    ## [121] "raw_receiver_owner_organization"              
    ## [122] "raw_receiver_status"                          
    ## [123] "raw_receiver_receiver_type"                   
    ## [124] "raw_receiver_manufacturer_fk"

Number of records:

``` r
count(raw_data)
```

    ## # A tibble: 1 x 1
    ##       n
    ##   <int>
    ## 1 50000

Preview data:

``` r
kable(head(raw_data))
```

|  raw\_id| raw\_receiver | raw\_transmitter | raw\_transmitter\_name | raw\_transmitter\_serial | raw\_sensor\_value | raw\_sensor\_unit | raw\_sensor2\_value | raw\_sensor2\_unit | raw\_station\_name | raw\_datetime       |  raw\_id\_pk| raw\_qc\_flag | raw\_file                     |  raw\_latitude|  raw\_longitude|  raw\_deployment\_fk| raw\_signal\_to\_noise\_ratio | raw\_detection\_file\_id | raw\_tag\_type | raw\_tag\_model | raw\_tag\_code\_space | raw\_tag\_owner\_pi | raw\_tag\_owner\_organization |  raw\_tag\_min\_delay|  raw\_tag\_max\_delay| raw\_tag\_frequency | raw\_acoustic\_tag\_type | raw\_tag\_sensor\_type | raw\_tag\_intercept | raw\_tag\_slope | raw\_sensor\_value\_depth\_meters |  raw\_person\_id| raw\_animal\_id | raw\_scientific\_name | raw\_common\_name |  raw\_length| raw\_length\_type | raw\_length\_units |  raw\_length2| raw\_length2\_type | raw\_length2\_units | raw\_weight\_units | raw\_age | raw\_age\_units | raw\_sex | raw\_life\_stage | raw\_capture\_location                                                                                                           | raw\_capture\_depth | raw\_utc\_release\_date\_time | raw\_comments    | raw\_est\_tag\_life | raw\_wild\_or\_hatchery | raw\_stock | raw\_dna\_sample\_taken | raw\_treatment\_type | raw\_dissolved\_oxygen | raw\_sedative | raw\_sedative\_concentration | raw\_temperature\_change | raw\_holding\_temperature | raw\_preop\_holding\_period | raw\_post\_op\_holding\_period | raw\_surgery\_location | raw\_date\_of\_surgery | raw\_anaesthetic | raw\_buffer | raw\_anaesthetic\_concentration | raw\_buffer\_concentration\_in\_anaesthetic | raw\_anesthetic\_concentration\_in\_recirculation | raw\_buffer\_concentration\_in\_recirculation |  raw\_id\_pk\_1| raw\_catched\_date\_time |  raw\_tag\_fk|  raw\_capture\_latitude|  raw\_capture\_longitude|  raw\_release\_latitude|  raw\_release\_longitude| raw\_surgery\_latitude | raw\_surgery\_longitude | raw\_recapture\_date | raw\_implant\_type | raw\_implant\_method | raw\_date\_modified | raw\_date\_created  | raw\_release\_location |  raw\_length3| raw\_length3\_type | raw\_length3\_units |  raw\_length4| raw\_length4\_type | raw\_length4\_units |  raw\_weight| raw\_end\_date\_tag | raw\_capture\_method |  raw\_project\_fk| raw\_animal\_project | raw\_animal\_project\_name | raw\_animal\_project\_code |  raw\_animal\_moratorium| raw\_network\_project | raw\_network\_project\_name | raw\_network\_project\_code |  raw\_network\_moratorium| raw\_deployment\_station\_name | raw\_deployment\_deploy\_date\_time | raw\_deployment\_location                      |  raw\_deployment\_location\_manager| raw\_deployment\_location\_description         |  raw\_deployment\_deploy\_lat|  raw\_deployment\_deploy\_long|  raw\_deployment\_recoverr\_lat|  raw\_deployment\_recover\_long|  raw\_deployment\_intended\_lat|  raw\_deployment\_intended\_long| raw\_deployment\_bottom\_depth | raw\_deployment\_riser\_length | raw\_deployment\_instrument\_depth |  raw\_receiver\_serial\_number| raw\_receiver\_model\_number | raw\_receiver\_owner\_organization | raw\_receiver\_status | raw\_receiver\_receiver\_type |  raw\_receiver\_manufacturer\_fk|
|--------:|:--------------|:-----------------|:-----------------------|:-------------------------|:-------------------|:------------------|:--------------------|:-------------------|:-------------------|:--------------------|------------:|:--------------|:------------------------------|--------------:|---------------:|--------------------:|:------------------------------|:-------------------------|:---------------|:----------------|:----------------------|:--------------------|:------------------------------|---------------------:|---------------------:|:--------------------|:-------------------------|:-----------------------|:--------------------|:----------------|:----------------------------------|----------------:|:----------------|:----------------------|:------------------|------------:|:------------------|:-------------------|-------------:|:-------------------|:--------------------|:-------------------|:---------|:----------------|:---------|:-----------------|:---------------------------------------------------------------------------------------------------------------------------------|:--------------------|:------------------------------|:-----------------|:--------------------|:------------------------|:-----------|:------------------------|:---------------------|:-----------------------|:--------------|:-----------------------------|:-------------------------|:--------------------------|:----------------------------|:-------------------------------|:-----------------------|:-----------------------|:-----------------|:------------|:--------------------------------|:--------------------------------------------|:--------------------------------------------------|:----------------------------------------------|---------------:|:-------------------------|-------------:|-----------------------:|------------------------:|-----------------------:|------------------------:|:-----------------------|:------------------------|:---------------------|:-------------------|:---------------------|:--------------------|:--------------------|:-----------------------|-------------:|:-------------------|:--------------------|-------------:|:-------------------|:--------------------|------------:|:--------------------|:---------------------|-----------------:|:---------------------|:---------------------------|:---------------------------|------------------------:|:----------------------|:----------------------------|:----------------------------|-------------------------:|:-------------------------------|:------------------------------------|:-----------------------------------------------|-----------------------------------:|:-----------------------------------------------|-----------------------------:|------------------------------:|-------------------------------:|-------------------------------:|-------------------------------:|--------------------------------:|:-------------------------------|:-------------------------------|:-----------------------------------|------------------------------:|:-----------------------------|:-----------------------------------|:----------------------|:------------------------------|--------------------------------:|
|        1| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:08:26 |     23235003| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap |                      50.86547|                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           |                                1|
|        2| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:08:51 |     23235004| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap |                      50.86547|                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           |                                1|
|        3| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:09:23 |     23235005| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap |                      50.86547|                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           |                                1|
|        4| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:09:52 |     23235006| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap |                      50.86547|                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           |                                1|
|        5| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:10:17 |     23235007| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap |                      50.86547|                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           |                                1|
|        6| VR2W-120095   | A69-1601-34500   | NA                     | NA                       | NA                 | NA                | NA                  | NA                 | 120095             | 2015-05-04 15:12:18 |     23235008| NA            | VR2W\_120095\_20150609\_1.csv |       52.12614|         5.19245|                 1454| NA                            | NA                       | internal       | V7-2x           | A69-1601-34500        | ANS MOUTON          | EVINBO                        |                    15|                    30| 069k                | animal                   | NA                     | NA                  | NA              | NA                                |               40|                 | Salmo salar           | NA                |         26.4| total length      | cm                 |            NA|                    |                     | g                  | NA       | NA              |          |                  | Ereze: Salmoniculture du Service Public Wallon (SPW) situe  Ereze. Les poissons proviennent de la production de smolts 2013. | NA                  | 2015-04-27 00:00:00           | ; durif\_index : | NA                  | hatched                 | NA         | NA                      | INTERNAL TAGGING     | NA                     | NA            | NA                           | NA                       | NA                        | NA                          | NA                             |                        |                        |                  | NA          |                                 | NA                                          | NA                                                | NA                                            |             539| 2015-04-27 00:00:00      |           632|                      NA|                       NA|                50.61468|                 5.604782| NA                     | NA                      | NA                   | NA                 | NA                   | 2016-02-02 11:28:21 | 2016-02-02 11:28:21 | Grosses Battes         |            NA|                    |                     |            NA|                    |                     |        175.5| 2015-06-30          |                      |                18| Albertkanaal         | Albertkanaal 2013          | albert2013                 |                        1| Maas Nederland        | Maas Nederland              | maasnl                      |                         0| ma-2                           | 2015-03-02 00:00:00                 | LO stroomop stuw Borgharen, aan ingang vistrap |                                   7| LO stroomop stuw Borgharen, aan ingang vistrap |                      50.86547|                       5.697744|                        52.12614|                         5.19245|                              NA|                               NA| NA                             | NA                             | NA                                 |                         120095| VR2W                         | SVN                                | Active                | acoustic\_telemetry           |                                1|

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

#### language

``` r
occurrence %<>% mutate(language = "en")
```

#### license

``` r
occurrence %<>% mutate(license = "http://creativecommons.org/publicdomain/zero/1.0/")
```

#### rightsHolder

Organization who owns the tag (receiver network can be used by all):

``` r
occurrence %<>% mutate(rightsHolder = recode(as.character(raw_tag_owner_organization),
  "EVINBO"                       = "INBO",
  "INST. VOOR NATUUR-&"          = "INBO",
  "INST. VOOR NATUUR-EN"         = "INBO",
  "INST. VORR NATUUR-&"          = "INBO",
  "LIFEWATCH-INBO"               = "INBO",
  "VLAAMS INSTITUUT VOOR DE ZEE" = "VLIZ",
  .default = "",
  .missing = ""
))

# TODO: was supposed to be animal project organization
```

Show mapped values:

``` r
occurrence %>% 
  select(raw_tag_owner_organization, rightsHolder) %>%
  group_by(raw_tag_owner_organization, rightsHolder) %>%
  summarize(records = n()) %>%
  arrange(raw_tag_owner_organization) %>%
  kable()
```

| raw\_tag\_owner\_organization | rightsHolder |  records|
|:------------------------------|:-------------|--------:|
| EVINBO                        | INBO         |    32042|
| INST. VOOR NATUUR-&           | INBO         |      261|
| INST. VOOR NATUUR-EN          | INBO         |    13563|
| INST. VORR NATUUR-&           | INBO         |        7|
| LIFEWATCH-INBO                | INBO         |     3987|
| VLAAMS INSTITUUT VOOR DE ZEE  | VLIZ         |      140|

#### accessRights

``` r
occurrence %<>% mutate(accessRights = "http://www.inbo.be/en/norms-for-data-use")
```

#### datasetID

``` r
occurrence %<>% mutate(datasetID = "") # TODO: add DOI
```

#### institutionCode

``` r
occurrence %<>% mutate(institutionCode = rightsHolder)
```

#### datasetName

``` r
occurrence %<>% mutate(datasetName = "Acoustic telemetry tracking data of fish in the Scheldt river basin and the Belgian Part of the North Sea (BPNS)")
```

#### basisOfRecord

``` r
occurrence %<>% mutate(basisOfRecord = "MachineObservation")
```

#### informationWithheld

``` r
occurrence %<>% mutate(informationWithheld = "see metadata")
```

#### dynamicProperties

``` r
occurrence %<>% mutate(dynamicProperties = paste0(
  "{\"transmitter\":\"", raw_transmitter, "\", ",
  "\"receiver\":\"", raw_receiver, "\"}"
))
```

#### occurrenceID

``` r
occurrence %<>% mutate(occurrenceID = paste("otn", "lifewatch", raw_id_pk, sep = ":"))
```

Check for duplicate `occurrenceID`s (should be 0):

``` r
anyDuplicated(occurrence$occurrenceID)
```

    ## [1] 0

#### sex

``` r
occurrence %<>% mutate(sex = recode(as.character(raw_sex),
  "F" = "female",
  "M" = "male",
  .default = "",
  .missing = ""
))
```

Show mapped values:

``` r
occurrence %>%
  select(raw_sex, sex) %>%
  group_by(raw_sex, sex) %>%
  summarize(records = n()) %>%
  arrange(raw_sex) %>%
  kable()
```

| raw\_sex | sex    |  records|
|:---------|:-------|--------:|
|          |        |    45839|
| F        | female |      174|
| M        | male   |     3987|

#### lifeStage

``` r
occurrence %<>% mutate(recode(as.character(raw_life_stage),
  "FV" = "?",
  "FIII" = "?",
  .default = "",
  .missing = ""
))

# TODO: complete this information... or add it to individuals table.
```

#### organismID

``` r
occurrence %<>% mutate(organismID = raw_animal_id) # TODO: This one is often NA
# Transmitter would have been nicer
```

#### eventID

``` r
# TODO: could potentially be deployment (more a parentEventID).
```

#### eventDate

`datetime` assumed to be UTC. For 3D analyses milliseconds will be required, but these won't be available in the source data until VRL imports are supported.

``` r
occurrence %<>% mutate(eventDate = format(as.POSIXct(raw_datetime), format = "%Y-%m-%dT%H:%M:%SZ")) # TODO: verify if UTC
```

#### eventTime

``` r
# TODO: could be used to indicate local time
```

#### samplingProtocol

``` r
# TODO: refer to DOI of methodology paper? Can some information be derived from source data?
# receiver_type: acoustic_telemetry, SVN, active
# receiver_model_number: VR2W, NA, 122325
# capture_method: NA, LINE FISHING, FYKE NETS
# 
```

#### locationID

The `station_name` is a fixed code for that deployment location. The `receiver` code is not adequate, as a receiver can be moved from one location to another.

``` r
occurrence %<>% mutate(locationID = raw_deployment_station_name)
# TODO: Should it be station_name (120095, S-3-1) or deployment_station_name (ma-2, s-3)?
```

#### waterBody

``` r
# TODO: Could be useful to filter? Either based on marine regions gazetteer from coordinates or based on a field in the source data?
```

#### countryCode

``` r
# TODO: Can be useful to filter and could be derived from coordinates, but trickier for records at sea?
```

#### locality

Although there is location information available in the `deployment_location` fields, it not very useful to share these raw Dutch location names:

``` r
occurrence %>%
  select(contains("deployment_location")) %>%
  unique() %>%
  head() %>%
  kable()
```

|     | raw\_deployment\_location |  raw\_deployment\_location\_manager| raw\_deployment\_location\_description                             |
|-----|:--------------------------|-----------------------------------:|:-------------------------------------------------------------------|
| 1   | 2 PPB                     |                                   5| Paulinapolder                                                      |
| 84  | 1 PPC                     |                                   5| Paulinapolder                                                      |
| 141 | Toevoerkanaal             |                                  NA| ter hoogte van inox meetkast                                       |
| 278 |                           |                                  NA| RO Grote Vijver rond seinpaal 15 (enkel bij laag water bereikbaar) |
| 297 | M-6                       |                                  NA| RO Grote Vijver rond seinpaal 15 (enkel bij laag water bereikbaar) |
| 402 | de-7                      |                                  NA| RO Grote Vijver rond seinpaal 15 (enkel bij laag water bereikbaar) |

#### minimumDepthInMeters

Pressure tags collect depth information, but that won't be available in the source data until VRL imports are supported.

#### decimalLatitude

There are several columns with coordinates information (listing percentage of `NA`s):

``` r
occurrence %>%
  select(contains("_lat"), contains("_long")) %>% # Looking for _lat(itude) in column name
  select(order(colnames(.))) %>% # Order alphabetically
  sapply(function(x) 100*mean(is.na(x))) %>%
  kable()
```

|                                 |         |
|:--------------------------------|--------:|
| raw\_capture\_latitude          |   64.226|
| raw\_capture\_longitude         |   64.226|
| raw\_deployment\_deploy\_lat    |    0.000|
| raw\_deployment\_deploy\_long   |    0.000|
| raw\_deployment\_intended\_lat  |   99.332|
| raw\_deployment\_intended\_long |   99.332|
| raw\_deployment\_recover\_long  |   99.054|
| raw\_deployment\_recoverr\_lat  |   99.054|
| raw\_latitude                   |   99.054|
| raw\_longitude                  |   99.054|
| raw\_release\_latitude          |    0.280|
| raw\_release\_longitude         |    0.280|
| raw\_surgery\_latitude          |  100.000|
| raw\_surgery\_longitude         |  100.000|

Of those the **deployment** coordinates of the receiver are the closest approximation of the position of the fish and always populated (no `NA`s in table above):

``` r
occurrence %<>% mutate(decimalLatitude = sprintf("%.7f", round(raw_deployment_deploy_lat, digits = 7)))
```

#### decimalLongitude

``` r
occurrence %<>% mutate(decimalLongitude = sprintf("%.7f", round(raw_deployment_deploy_long, digits = 7)))
```

#### geodeticDatum

``` r
occurrence %<>% mutate(geodeticDatum = "WGS84")
```

#### coordinateUncertaintyInMeters

``` r
# Depends on area: sea / Westerscheldt: 200m on average, 500m extreme, while Albertkanaal: 2km
# TODO: on which field should this be based?
# network_project_code?
# animal_project_code?
# receiver?
```

#### georeferenceSources

``` r
occurrence %<>% mutate(georeferenceSources = "GPS") # TODO: not always GPS, maybe drop term
```

#### georeferenceVerificationStatus

``` r
occurrence %<>% mutate(georeferenceVerificationStatus = "unverified") # TODO: maybe drop term
```

#### scientificName

Show unique values:

``` r
occurrence %>%
  select(raw_scientific_name) %>%
  group_by(raw_scientific_name) %>%
  summarize(records = n()) %>%
  kable()
```

| raw\_scientific\_name |  records|
|:----------------------|--------:|
| Alosa fallax          |      291|
| Anguilla anguilla     |      174|
| Cyprinus carpio       |      202|
| Gadus morhua          |      140|
| Platichthys flesus    |      193|
| Rutilus rutilus       |     2359|
| Salmo salar           |       42|
| Silurus glanis        |    14738|
| Sync tag              |    31861|

Map scientific name:

``` r
occurrence %<>% mutate(scientificName = raw_scientific_name)
```

#### kingdom

``` r
occurrence %<>% mutate(kingdom = "animalia")
```

Some other higher classication terms could be populated, but with the limited number of species it's not really useful as extra filters.

#### taxonRank

``` r
occurrence %<>% mutate(taxonRank = "species") # TODO: all species?
```

#### vernacularName

``` r
# occurrence %<>% mutate(vernacularName = raw_common_name) # TODO: ever populated?
```

### Post-processing

Filter out records with `Sync tag` as scientific name:

``` r
occurrence %<>% filter(raw_scientific_name != "Sync tag")
count(occurrence)
```

    ## # A tibble: 1 x 1
    ##       n
    ##   <int>
    ## 1 18139

Filter out records under a moratorium:

``` r
occurrence %<>% filter(raw_animal_moratorium == 1) # TODO: or was it network_moratorium?
count(occurrence)
```

    ## # A tibble: 1 x 1
    ##       n
    ##   <int>
    ## 1  4755

Remove the original columns:

``` r
occurrence %<>% select(-one_of(raw_colnames))
```

Preview data:

``` r
kable(head(occurrence))
```

| type  | language | license                                             | rightsHolder | accessRights                               | datasetID | institutionCode | datasetName                                                                                                      | basisOfRecord      | informationWithheld | dynamicProperties                                          | occurrenceID           | sex | organismID | eventDate            | locationID | decimalLatitude | decimalLongitude | geodeticDatum | georeferenceSources | georeferenceVerificationStatus | scientificName | kingdom  | taxonRank |
|:------|:---------|:----------------------------------------------------|:-------------|:-------------------------------------------|:----------|:----------------|:-----------------------------------------------------------------------------------------------------------------|:-------------------|:--------------------|:-----------------------------------------------------------|:-----------------------|:----|:-----------|:---------------------|:-----------|:----------------|:-----------------|:--------------|:--------------------|:-------------------------------|:---------------|:---------|:----------|
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | VLIZ         | <http://www.inbo.be/en/norms-for-data-use> |           | VLIZ            | Acoustic telemetry tracking data of fish in the Scheldt river basin and the Belgian Part of the North Sea (BPNS) | MachineObservation | see metadata        | {"transmitter":"A69-1601-13730", "receiver":"VR2W-120887"} | otn:lifewatch:23235428 |     | A56        | 2015-08-18T15:04:10Z | ws-PPB     | 51.3536136      | 3.7376409        | WGS84         | GPS                 | unverified                     | Gadus morhua   | animalia | species   |
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | VLIZ         | <http://www.inbo.be/en/norms-for-data-use> |           | VLIZ            | Acoustic telemetry tracking data of fish in the Scheldt river basin and the Belgian Part of the North Sea (BPNS) | MachineObservation | see metadata        | {"transmitter":"A69-1601-13730", "receiver":"VR2W-120887"} | otn:lifewatch:23235429 |     | A56        | 2015-08-18T15:08:50Z | ws-PPB     | 51.3536136      | 3.7376409        | WGS84         | GPS                 | unverified                     | Gadus morhua   | animalia | species   |
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | VLIZ         | <http://www.inbo.be/en/norms-for-data-use> |           | VLIZ            | Acoustic telemetry tracking data of fish in the Scheldt river basin and the Belgian Part of the North Sea (BPNS) | MachineObservation | see metadata        | {"transmitter":"A69-1601-13730", "receiver":"VR2W-120887"} | otn:lifewatch:23235430 |     | A56        | 2015-08-18T15:11:16Z | ws-PPB     | 51.3536136      | 3.7376409        | WGS84         | GPS                 | unverified                     | Gadus morhua   | animalia | species   |
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | VLIZ         | <http://www.inbo.be/en/norms-for-data-use> |           | VLIZ            | Acoustic telemetry tracking data of fish in the Scheldt river basin and the Belgian Part of the North Sea (BPNS) | MachineObservation | see metadata        | {"transmitter":"A69-1601-13730", "receiver":"VR2W-120887"} | otn:lifewatch:23235431 |     | A56        | 2015-08-18T15:13:06Z | ws-PPB     | 51.3536136      | 3.7376409        | WGS84         | GPS                 | unverified                     | Gadus morhua   | animalia | species   |
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | VLIZ         | <http://www.inbo.be/en/norms-for-data-use> |           | VLIZ            | Acoustic telemetry tracking data of fish in the Scheldt river basin and the Belgian Part of the North Sea (BPNS) | MachineObservation | see metadata        | {"transmitter":"A69-1601-13730", "receiver":"VR2W-120887"} | otn:lifewatch:23235432 |     | A56        | 2015-08-18T15:15:42Z | ws-PPB     | 51.3536136      | 3.7376409        | WGS84         | GPS                 | unverified                     | Gadus morhua   | animalia | species   |
| Event | en       | <http://creativecommons.org/publicdomain/zero/1.0/> | VLIZ         | <http://www.inbo.be/en/norms-for-data-use> |           | VLIZ            | Acoustic telemetry tracking data of fish in the Scheldt river basin and the Belgian Part of the North Sea (BPNS) | MachineObservation | see metadata        | {"transmitter":"A69-1601-13730", "receiver":"VR2W-120887"} | otn:lifewatch:23235433 |     | A56        | 2015-08-18T15:17:50Z | ws-PPB     | 51.3536136      | 3.7376409        | WGS84         | GPS                 | unverified                     | Gadus morhua   | animalia | species   |

Save to CSV:

``` r
write.csv(occurrence, file = dwc_occurrence_file, na = "", row.names = FALSE, fileEncoding = "UTF-8")
```
