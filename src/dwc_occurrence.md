# Mapping fish tracking data to Darwin Core Occurrence

Peter Desmet
2017-06-30

## Setup




Load libraries


```r
library(tidyverse)
library(janitor)
library(pander)
library(knitr)
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

