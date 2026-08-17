# List all available cpod project codes

List all available cpod project codes

## Usage

``` r
list_cpod_project_codes(connection)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

## Value

A vector of all unique `project_code` of `type = "cpod"` that are
available.

## See also

Other list functions:
[`list_acoustic_project_codes()`](https://inbo.github.io/etn/reference/list_acoustic_project_codes.md),
[`list_acoustic_tag_ids()`](https://inbo.github.io/etn/reference/list_acoustic_tag_ids.md),
[`list_animal_ids()`](https://inbo.github.io/etn/reference/list_animal_ids.md),
[`list_animal_project_codes()`](https://inbo.github.io/etn/reference/list_animal_project_codes.md),
[`list_deployment_ids()`](https://inbo.github.io/etn/reference/list_deployment_ids.md),
[`list_receiver_ids()`](https://inbo.github.io/etn/reference/list_receiver_ids.md),
[`list_scientific_names()`](https://inbo.github.io/etn/reference/list_scientific_names.md),
[`list_station_names()`](https://inbo.github.io/etn/reference/list_station_names.md),
[`list_tag_serial_numbers()`](https://inbo.github.io/etn/reference/list_tag_serial_numbers.md),
[`list_values()`](https://inbo.github.io/etn/reference/list_values.md)

## Examples

``` r
list_cpod_project_codes()
#>  [1] "Apelafico_acoustics"           "Apelafico_underwater"         
#>  [3] "ARMS_MBON_Belgium"             "Blueconnect"                  
#>  [5] "CODEVCO"                       "cpod-lifewatch"               
#>  [7] "cpod-od-natuur"                "HesseløOWF_2020-2021_PODdata" 
#>  [9] "Lifewatch_additional_stations" "Lifewatch_performance_test"   
#> [11] "mare_wind_finescale"           "NOVANA"                       
#> [13] "PAM-Borssele"                  "PelFish"                      
#> [15] "PhD_Parcerisas"                "PureWind"                     
#> [17] "SEAWave"                       "SMGMIT"                       
#> [19] "STRAITS_PAM"                   "VLIZ_SANDEEL"                 
#> [21] "VLIZ-MRC-AMUC-001"             "VLIZ-MRC-AMUC-002"            
#> [23] "WaveHub"                      
```
