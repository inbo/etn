# Get acoustic deployment data

Get data for deployments of acoustic receivers, with options to filter
results.

## Usage

``` r
get_acoustic_deployments(
  connection,
  deployment_id = NULL,
  receiver_id = NULL,
  acoustic_project_code = NULL,
  station_name = NULL,
  open_only = FALSE
)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- deployment_id:

  Integer (vector). One or more deployment identifiers.

- receiver_id:

  Character (vector). One or more receiver identifiers.

- acoustic_project_code:

  Character (vector). One or more acoustic project codes.
  Case-insensitive.

- station_name:

  Character (vector). One or more deployment station names.

- open_only:

  Logical. Restrict deployments to those that are currently open (i.e.
  no end date defined). Defaults to `FALSE`.

## Value

A tibble with acoustic deployment data, sorted by
`acoustic_project_code`, `station_name` and `deploy_date_time`.

## Examples

``` r
# Get all acoustic deployments
get_acoustic_deployments()
#> # A tibble: 21,495 × 38
#>    deployment_id receiver_id acoustic_project_code station_name
#>            <int> <chr>       <chr>                 <chr>       
#>  1          6660 VR20-2029   2004_Gudena           GUD1        
#>  2          6670 VR2-3536    2004_Gudena           GUD1        
#>  3          6661 VR2-1908    2004_Gudena           GUD2        
#>  4          6671 VR2-1908    2004_Gudena           GUD2        
#>  5          6680 VR2-2566    2004_Gudena           KATNORD     
#>  6          6679 VR2-2719    2004_Gudena           KATSYD      
#>  7          6662 VR2-3538    2004_Gudena           RAN1        
#>  8          6672 VR2-3538    2004_Gudena           RAN1        
#>  9          6663 VR2-1909    2004_Gudena           RAN2        
#> 10          6673 VR2-1909    2004_Gudena           RAN2        
#> # ℹ 21,485 more rows
#> # ℹ 34 more variables: station_description <chr>, station_manager <chr>,
#> #   deploy_date_time <dttm>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   intended_latitude <dbl>, intended_longitude <dbl>, mooring_type <chr>,
#> #   bottom_depth <chr>, riser_length <chr>, deploy_depth <chr>,
#> #   battery_installation_date <dttm>, battery_estimated_end_date <dttm>,
#> #   activation_date_time <dttm>, recover_date_time <dttm>, …

# Get specific acoustic deployment
get_acoustic_deployments(deployment_id = 1437)
#> # A tibble: 1 × 38
#>   deployment_id receiver_id acoustic_project_code station_name
#>           <int> <chr>       <chr>                 <chr>       
#> 1          1437 VR2W-124070 demer                 de-9        
#> # ℹ 34 more variables: station_description <chr>, station_manager <chr>,
#> #   deploy_date_time <dttm>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   intended_latitude <dbl>, intended_longitude <dbl>, mooring_type <chr>,
#> #   bottom_depth <chr>, riser_length <chr>, deploy_depth <chr>,
#> #   battery_installation_date <dttm>, battery_estimated_end_date <dttm>,
#> #   activation_date_time <dttm>, recover_date_time <dttm>,
#> #   recover_latitude <dbl>, recover_longitude <dbl>, …

# Get acoustic deployments for a specific receiver
get_acoustic_deployments(receiver_id = "VR2W-124070")
#> # A tibble: 8 × 38
#>   deployment_id receiver_id acoustic_project_code station_name
#>           <int> <chr>       <chr>                 <chr>       
#> 1          1437 VR2W-124070 demer                 de-9        
#> 2          1588 VR2W-124070 demer                 de-9        
#> 3          1803 VR2W-124070 dijle                 M-2         
#> 4          1804 VR2W-124070 dijle                 M-2         
#> 5          1805 VR2W-124070 dijle                 M-2         
#> 6          1806 VR2W-124070 dijle                 M-2         
#> 7          1807 VR2W-124070 dijle                 M-2         
#> 8          2511 VR2W-124070 dijle                 M-2         
#> # ℹ 34 more variables: station_description <chr>, station_manager <chr>,
#> #   deploy_date_time <dttm>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   intended_latitude <dbl>, intended_longitude <dbl>, mooring_type <chr>,
#> #   bottom_depth <chr>, riser_length <chr>, deploy_depth <chr>,
#> #   battery_installation_date <dttm>, battery_estimated_end_date <dttm>,
#> #   activation_date_time <dttm>, recover_date_time <dttm>,
#> #   recover_latitude <dbl>, recover_longitude <dbl>, …

# Get open acoustic deployments for a specific receiver
get_acoustic_deployments(receiver_id = "VR2W-124070", open_only = TRUE)
#> # A tibble: 0 × 38
#> # ℹ 38 variables: deployment_id <int>, receiver_id <chr>,
#> #   acoustic_project_code <chr>, station_name <chr>, station_description <chr>,
#> #   station_manager <chr>, deploy_date_time <dttm>, deploy_latitude <dbl>,
#> #   deploy_longitude <dbl>, intended_latitude <dbl>, intended_longitude <dbl>,
#> #   mooring_type <chr>, bottom_depth <chr>, riser_length <chr>,
#> #   deploy_depth <chr>, battery_installation_date <dttm>,
#> #   battery_estimated_end_date <dttm>, activation_date_time <dttm>, …

# Get acoustic deployments for a specific acoustic project
get_acoustic_deployments(acoustic_project_code = "demer")
#> # A tibble: 46 × 38
#>    deployment_id receiver_id acoustic_project_code station_name
#>            <int> <chr>       <chr>                 <chr>       
#>  1          1424 VR2W-122350 demer                 de-1        
#>  2          1658 VR2W-122345 demer                 de-2        
#>  3          1478 VR2W-122325 demer                 de-2        
#>  4          1661 VR2W-122344 demer                 de-3        
#>  5          1381 VR2W-122339 demer                 de-3        
#>  6          2869 VR2W-122339 demer                 de-3        
#>  7          1662 VR2W-122323 demer                 de-4        
#>  8          1425 VR2W-122337 demer                 de-5        
#>  9          1663 VR2W-122341 demer                 de-6        
#> 10          1378 VR2W-122320 demer                 de-7        
#> # ℹ 36 more rows
#> # ℹ 34 more variables: station_description <chr>, station_manager <chr>,
#> #   deploy_date_time <dttm>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   intended_latitude <dbl>, intended_longitude <dbl>, mooring_type <chr>,
#> #   bottom_depth <chr>, riser_length <chr>, deploy_depth <chr>,
#> #   battery_installation_date <dttm>, battery_estimated_end_date <dttm>,
#> #   activation_date_time <dttm>, recover_date_time <dttm>, …

# Get acoustic deployments for two specific stations
get_acoustic_deployments(station_name = c("de-9", "de-10"))
#> # A tibble: 3 × 38
#>   deployment_id receiver_id acoustic_project_code station_name
#>           <int> <chr>       <chr>                 <chr>       
#> 1          1437 VR2W-124070 demer                 de-9        
#> 2          1588 VR2W-124070 demer                 de-9        
#> 3          1428 VR2W-124078 demer                 de-10       
#> # ℹ 34 more variables: station_description <chr>, station_manager <chr>,
#> #   deploy_date_time <dttm>, deploy_latitude <dbl>, deploy_longitude <dbl>,
#> #   intended_latitude <dbl>, intended_longitude <dbl>, mooring_type <chr>,
#> #   bottom_depth <chr>, riser_length <chr>, deploy_depth <chr>,
#> #   battery_installation_date <dttm>, battery_estimated_end_date <dttm>,
#> #   activation_date_time <dttm>, recover_date_time <dttm>,
#> #   recover_latitude <dbl>, recover_longitude <dbl>, …
```
