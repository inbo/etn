# Get acoustic detections data

Get data for acoustic detections, with options to filter results. Use
`limit` to limit the number of returned records.

## Usage

``` r
get_acoustic_detections(
  connection,
  start_date = NULL,
  end_date = NULL,
  tag_serial_number = NULL,
  acoustic_tag_id = NULL,
  animal_project_code = NULL,
  scientific_name = NULL,
  acoustic_project_code = NULL,
  receiver_id = NULL,
  station_name = NULL,
  limit = FALSE,
  progress = TRUE
)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- start_date:

  Character. Start date (inclusive) in ISO 8601 format ( `yyyy-mm-dd`,
  `yyyy-mm` or `yyyy`).

- end_date:

  Character. End date (exclusive) in ISO 8601 format ( `yyyy-mm-dd`,
  `yyyy-mm` or `yyyy`).

- tag_serial_number:

  Character (vector). One or more acoustic tag serial numbers.

- acoustic_tag_id:

  Character (vector). One or more acoustic tag ids.

- animal_project_code:

  Character (vector). One or more animal project codes.
  Case-insensitive.

- scientific_name:

  Character (vector). One or more scientific names.

- acoustic_project_code:

  Character (vector). One or more acoustic project codes.
  Case-insensitive.

- receiver_id:

  Character (vector). One or more receiver identifiers.

- station_name:

  Character (vector). One or more deployment station names.

- limit:

  Logical. Limit the number of returned records to 100 (useful for
  testing purposes). Defaults to `FALSE`.

- progress:

  Logical. Show a progress bar while fetching data. Defaults to `TRUE`.

## Value

A tibble with acoustic detections data, sorted by `acoustic_tag_id` and
`date_time`. See also [field
definitions](https://inbo.github.io/etn/articles/etn_fields.html).

## Examples

``` r
# Get limited sample of acoustic detections
get_acoustic_detections(limit = TRUE)
#> ℹ Preparing 
#> ✔ Preparing : will fetch 100  detections [12ms]
#> 
#> ℹ Wrapping up
#> ✔ Wrapping up [103ms]
#> 
#> # A tibble: 100 × 20
#>    detection_id date_time           tag_serial_number acoustic_tag_id
#>           <int> <dttm>              <chr>             <chr>          
#>  1     18895442 2010-09-14 09:38:36 1097345           A69-1303-65302 
#>  2     18895443 2010-09-14 09:58:44 1097345           A69-1303-65302 
#>  3     18895444 2010-09-14 10:18:52 1097345           A69-1303-65302 
#>  4     18895445 2010-09-14 10:28:56 1097345           A69-1303-65302 
#>  5     18895447 2010-09-14 10:59:07 1097345           A69-1303-65302 
#>  6     18895448 2010-09-14 11:09:11 1097345           A69-1303-65302 
#>  7     18895449 2010-09-14 11:19:15 1097345           A69-1303-65302 
#>  8     18895450 2010-09-14 12:09:35 1097345           A69-1303-65302 
#>  9     18895451 2010-09-14 12:19:39 1097345           A69-1303-65302 
#> 10     18895452 2010-09-14 13:20:02 1097345           A69-1303-65302 
#> # ℹ 90 more rows
#> # ℹ 16 more variables: animal_project_code <chr>, animal_id <int>,
#> #   scientific_name <chr>, acoustic_project_code <chr>, receiver_id <chr>,
#> #   station_name <chr>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   sensor_value <dbl>, sensor_unit <chr>, sensor2_value <dbl>,
#> #   sensor2_unit <chr>, signal_to_noise_ratio <int>, source_file <chr>,
#> #   qc_flag <lgl>, deployment_id <int>

# Get all acoustic detections from a specific animal project
get_acoustic_detections(animal_project_code = "2014_demer")
#> ℹ Preparing 
#> ✔ Preparing : will fetch 235.81 k detections [2.8s]
#> 
#> Getting detections. ■■■■■■■■■■■                       33% [8s] | ETA: 16s
#> Getting detections. ■■■■■■■■■■■■■■■■■■■■■             67% [15.6s] | ETA:  8s
#> ℹ Wrapping up
#> ✔ Wrapping up [372ms]
#> 
#> # A tibble: 235,809 × 20
#>    detection_id date_time           tag_serial_number acoustic_tag_id
#>           <int> <dttm>              <chr>             <chr>          
#>  1     21655610 2014-04-18 16:02:26 1187449           A69-1601-16129 
#>  2     21676626 2014-04-18 15:45:00 1187449           A69-1601-16129 
#>  3     21745679 2014-04-18 15:47:45 1187449           A69-1601-16129 
#>  4     21746517 2014-04-18 15:55:08 1187449           A69-1601-16129 
#>  5     21801130 2014-04-18 15:57:00 1187449           A69-1601-16129 
#>  6     21823882 2014-04-18 15:49:00 1187449           A69-1601-16129 
#>  7     21919770 2014-04-18 15:47:00 1187449           A69-1601-16129 
#>  8     21966500 2014-04-18 15:58:00 1187449           A69-1601-16129 
#>  9     21976905 2014-04-18 15:49:02 1187449           A69-1601-16129 
#> 10     22452992 2014-04-18 15:57:26 1187449           A69-1601-16129 
#> # ℹ 235,799 more rows
#> # ℹ 16 more variables: animal_project_code <chr>, animal_id <int>,
#> #   scientific_name <chr>, acoustic_project_code <chr>, receiver_id <chr>,
#> #   station_name <chr>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   sensor_value <dbl>, sensor_unit <chr>, sensor2_value <dbl>,
#> #   sensor2_unit <chr>, signal_to_noise_ratio <int>, source_file <chr>,
#> #   qc_flag <lgl>, deployment_id <int>

# Get 2015 acoustic detections from that animal project
get_acoustic_detections(
  animal_project_code = "2014_demer",
  start_date = "2015",
  end_date = "2016",
)
#> ℹ Preparing 
#> ✔ Preparing : will fetch 23.70 k detections [2.8s]
#> 
#> ℹ Wrapping up
#> ✔ Wrapping up [113ms]
#> 
#> # A tibble: 23,695 × 20
#>    detection_id date_time           tag_serial_number acoustic_tag_id
#>           <int> <dttm>              <chr>             <chr>          
#>  1     23629467 2015-05-06 04:11:52 1187468           A69-1601-16148 
#>  2     23630262 2015-05-07 15:59:24 1187468           A69-1601-16148 
#>  3     23630263 2015-05-07 16:45:38 1187468           A69-1601-16148 
#>  4     23630265 2015-05-07 16:56:22 1187468           A69-1601-16148 
#>  5     23630267 2015-05-07 17:00:18 1187468           A69-1601-16148 
#>  6     23630274 2015-05-07 17:06:13 1187468           A69-1601-16148 
#>  7     23630278 2015-05-07 17:08:54 1187468           A69-1601-16148 
#>  8     23630285 2015-05-07 17:15:07 1187468           A69-1601-16148 
#>  9     23630294 2015-05-07 17:23:21 1187468           A69-1601-16148 
#> 10     23630300 2015-05-07 17:27:27 1187468           A69-1601-16148 
#> # ℹ 23,685 more rows
#> # ℹ 16 more variables: animal_project_code <chr>, animal_id <int>,
#> #   scientific_name <chr>, acoustic_project_code <chr>, receiver_id <chr>,
#> #   station_name <chr>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   sensor_value <dbl>, sensor_unit <chr>, sensor2_value <dbl>,
#> #   sensor2_unit <chr>, signal_to_noise_ratio <int>, source_file <chr>,
#> #   qc_flag <lgl>, deployment_id <int>

# Get April 2015 acoustic detections from that animal project
get_acoustic_detections(
  animal_project_code = "2014_demer",
  start_date = "2015-04",
  end_date = "2015-05",
)
#> ℹ Preparing 
#> ✔ Preparing : will fetch 442  detections [1.9s]
#> 
#> ℹ Wrapping up
#> ✔ Wrapping up [59ms]
#> 
#> # A tibble: 442 × 20
#>    detection_id date_time           tag_serial_number acoustic_tag_id
#>           <int> <dttm>              <chr>             <chr>          
#>  1     23863772 2015-04-20 17:18:27 1171781           A69-1601-26535 
#>  2     23863773 2015-04-20 17:20:27 1171781           A69-1601-26535 
#>  3     23863774 2015-04-20 17:23:03 1171781           A69-1601-26535 
#>  4     23863775 2015-04-20 17:44:07 1171781           A69-1601-26535 
#>  5     23863776 2015-04-20 17:58:38 1171781           A69-1601-26535 
#>  6     23863777 2015-04-20 18:00:52 1171781           A69-1601-26535 
#>  7     23863778 2015-04-20 18:02:37 1171781           A69-1601-26535 
#>  8     23863779 2015-04-20 18:04:44 1171781           A69-1601-26535 
#>  9     23863780 2015-04-20 18:06:13 1171781           A69-1601-26535 
#> 10     23863781 2015-04-20 18:07:47 1171781           A69-1601-26535 
#> # ℹ 432 more rows
#> # ℹ 16 more variables: animal_project_code <chr>, animal_id <int>,
#> #   scientific_name <chr>, acoustic_project_code <chr>, receiver_id <chr>,
#> #   station_name <chr>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   sensor_value <dbl>, sensor_unit <chr>, sensor2_value <dbl>,
#> #   sensor2_unit <chr>, signal_to_noise_ratio <int>, source_file <chr>,
#> #   qc_flag <lgl>, deployment_id <int>

# Get April 24, 2015 acoustic detections from that animal project
get_acoustic_detections(
  animal_project_code = "2014_demer",
  start_date = "2015-04-24",
  end_date = "2015-04-25",
)
#> ℹ Preparing 
#> ✔ Preparing : will fetch 2  detections [1.7s]
#> 
#> ℹ Wrapping up
#> ✔ Wrapping up [52ms]
#> 
#> # A tibble: 2 × 20
#>   detection_id date_time           tag_serial_number acoustic_tag_id
#>          <int> <dttm>              <chr>             <chr>          
#> 1     23053006 2015-04-24 07:54:12 1171781           A69-1601-26535 
#> 2     23053007 2015-04-24 07:56:29 1171781           A69-1601-26535 
#> # ℹ 16 more variables: animal_project_code <chr>, animal_id <int>,
#> #   scientific_name <chr>, acoustic_project_code <chr>, receiver_id <chr>,
#> #   station_name <chr>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   sensor_value <dbl>, sensor_unit <chr>, sensor2_value <dbl>,
#> #   sensor2_unit <chr>, signal_to_noise_ratio <int>, source_file <chr>,
#> #   qc_flag <lgl>, deployment_id <int>

# Get acoustic detections for a specific tag at two specific stations
get_acoustic_detections(
  acoustic_tag_id = "A69-1601-16130",
  station_name = c("de-9", "de-10")
)
#> ℹ Preparing 
#> ✔ Preparing : will fetch 50  detections [1.8s]
#> 
#> ℹ Wrapping up
#> ✔ Wrapping up [57ms]
#> 
#> # A tibble: 50 × 20
#>    detection_id date_time           tag_serial_number acoustic_tag_id
#>           <int> <dttm>              <chr>             <chr>          
#>  1     20638636 2014-04-26 12:46:40 1187450           A69-1601-16130 
#>  2     20641245 2014-04-26 13:18:00 1187450           A69-1601-16130 
#>  3     20701797 2014-04-26 13:12:00 1187450           A69-1601-16130 
#>  4     20904420 2014-04-26 12:51:00 1187450           A69-1601-16130 
#>  5     20951670 2014-04-28 18:34:00 1187450           A69-1601-16130 
#>  6     21107986 2014-04-28 18:37:07 1187450           A69-1601-16130 
#>  7     21159804 2014-04-26 12:49:22 1187450           A69-1601-16130 
#>  8     21193066 2014-04-26 12:49:00 1187450           A69-1601-16130 
#>  9     21198095 2014-04-28 18:32:53 1187450           A69-1601-16130 
#> 10     21387447 2014-04-26 12:51:23 1187450           A69-1601-16130 
#> # ℹ 40 more rows
#> # ℹ 16 more variables: animal_project_code <chr>, animal_id <int>,
#> #   scientific_name <chr>, acoustic_project_code <chr>, receiver_id <chr>,
#> #   station_name <chr>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   sensor_value <dbl>, sensor_unit <chr>, sensor2_value <dbl>,
#> #   sensor2_unit <chr>, signal_to_noise_ratio <int>, source_file <chr>,
#> #   qc_flag <lgl>, deployment_id <int>

# Get acoustic detections for a specific species, receiver and acoustic project
get_acoustic_detections(
  scientific_name = "Rutilus rutilus",
  receiver_id = "VR2W-124070",
  acoustic_project_code = "demer"
)
#> ℹ Preparing 
#> ✔ Preparing : will fetch 38  detections [1.7s]
#> 
#> ℹ Wrapping up
#> ✔ Wrapping up [58ms]
#> 
#> # A tibble: 38 × 20
#>    detection_id date_time           tag_serial_number acoustic_tag_id
#>           <int> <dttm>              <chr>             <chr>          
#>  1     20962095 2014-04-18 16:12:26 1187449           A69-1601-16129 
#>  2     21250456 2014-04-18 16:10:52 1187449           A69-1601-16129 
#>  3     21261941 2014-04-18 16:17:05 1187449           A69-1601-16129 
#>  4     21697884 2014-04-18 16:12:00 1187449           A69-1601-16129 
#>  5     21863649 2014-04-18 16:17:00 1187449           A69-1601-16129 
#>  6     22013363 2014-04-18 16:15:00 1187449           A69-1601-16129 
#>  7     22153161 2014-04-18 16:15:32 1187449           A69-1601-16129 
#>  8     22437907 2014-04-18 16:10:00 1187449           A69-1601-16129 
#>  9     20621280 2014-04-26 11:22:25 1187450           A69-1601-16130 
#> 10     20667884 2014-04-26 10:23:51 1187450           A69-1601-16130 
#> # ℹ 28 more rows
#> # ℹ 16 more variables: animal_project_code <chr>, animal_id <int>,
#> #   scientific_name <chr>, acoustic_project_code <chr>, receiver_id <chr>,
#> #   station_name <chr>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   sensor_value <dbl>, sensor_unit <chr>, sensor2_value <dbl>,
#> #   sensor2_unit <chr>, signal_to_noise_ratio <int>, source_file <chr>,
#> #   qc_flag <lgl>, deployment_id <int>
```
