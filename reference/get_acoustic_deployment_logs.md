# Get acoustic deployment logs

Get log data for deployments of acoustic receivers. These contain
diagnostic information that may be helpful to figure what happened with
a receiver during deployment. For example, a deviation in tilt angle may
decrease detection capabilities. For some receivers, other information
such as water temperature is available.

## Usage

``` r
get_acoustic_deployment_logs(deployment_id, limit = FALSE)
```

## Arguments

- deployment_id:

  Integer (vector). One or more deployment identifiers.

- limit:

  Logical. Limit the number of returned records to 100 (useful for
  testing purposes). Defaults to `FALSE`.

## Value

A tibble with acoustic deployment log data.

## Details

The log data are returned as a tibble with one row per log entry. The
columns of the tibble may vary depending on the deployment and receiver.
If no log entries are found for a deployment id, an empty tibble is
returned.

## Name repair

It is possible that the columns contained in the log data overlap with
the default columns always returned by `get_acoustic_deployment_logs()`.
If duplicate columns are found, their names are made unique with
[`make.unique()`](https://rdrr.io/r/base/make.unique.html) and a message
is returned, which can be silenced with
[`suppressMessages()`](https://rdrr.io/r/base/message.html).

## See also

Other access functions:
[`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md),
[`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md),
[`get_acoustic_projects()`](https://inbo.github.io/etn/reference/get_acoustic_projects.md),
[`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md),
[`get_animal_projects()`](https://inbo.github.io/etn/reference/get_animal_projects.md),
[`get_animals()`](https://inbo.github.io/etn/reference/get_animals.md),
[`get_bibliography()`](https://inbo.github.io/etn/reference/get_bibliography.md),
[`get_cpod_projects()`](https://inbo.github.io/etn/reference/get_cpod_projects.md),
[`get_package()`](https://inbo.github.io/etn/reference/get_package.md),
[`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md)

## Examples

``` r
get_acoustic_deployment_logs(deployment_id = 25259, limit = TRUE)
#> # A tibble: 100 × 13
#>    deployment_id receiver_id record_type       datetime            station_name
#>            <int> <chr>       <chr>             <dttm>              <chr>       
#>  1         25259 VR2W-120425 DIAG_VR2W         2017-06-18 00:00:00 PREVOST_25  
#>  2         25259 VR2W-120425 DIAG_VR2W         2017-06-25 00:00:00 PREVOST_25  
#>  3         25259 VR2W-120425 HEALTH_VR2W       2017-06-12 00:00:00 PREVOST_25  
#>  4         25259 VR2W-120425 BATTERY           2017-05-25 00:00:00 PREVOST_25  
#>  5         25259 VR2W-120425 BATTERY           2017-06-01 00:00:00 PREVOST_25  
#>  6         25259 VR2W-120425 HEALTH_VR2W       2017-06-14 00:00:00 PREVOST_25  
#>  7         25259 VR2W-120425 HEALTH_VR2W       2017-05-29 00:00:00 PREVOST_25  
#>  8         25259 VR2W-120425 DIAG_VR2W_INTERIM 2017-06-27 06:54:03 PREVOST_25  
#>  9         25259 VR2W-120425 BATTERY           2017-06-18 00:00:00 PREVOST_25  
#> 10         25259 VR2W-120425 HEALTH_VR2W       2017-06-07 00:00:00 PREVOST_25  
#> # ℹ 90 more rows
#> # ℹ 8 more variables: RTC_time <chr>, device_time_UTC <dttm>,
#> #   `memory_remaining_%` <dbl>, battery_voltage_V <dbl>, original_file <chr>,
#> #   external_time_zone <chr>, external_time_UTC <dttm>,
#> #   PPM_total_accepted_detections <int>
get_acoustic_deployment_logs(deployment_id = 74535)
#> # A tibble: 8,388 × 18
#>    deployment_id receiver_id record_type datetime            station_name       
#>            <int> <chr>       <chr>       <dttm>              <chr>              
#>  1         74535 VR2W-136724 DIAG        2023-05-16 18:00:00 Tijdenskan. - Hamd…
#>  2         74535 VR2W-136724 BATTERY     2022-10-21 00:00:00 Tijdenskan. - Hamd…
#>  3         74535 VR2W-136724 DIAG        2022-09-01 23:00:00 Tijdenskan. - Hamd…
#>  4         74535 VR2W-136724 DIAG        2022-12-12 07:00:00 Tijdenskan. - Hamd…
#>  5         74535 VR2W-136724 DIAG        2023-02-15 12:00:00 Tijdenskan. - Hamd…
#>  6         74535 VR2W-136724 DIAG        2022-10-13 19:00:00 Tijdenskan. - Hamd…
#>  7         74535 VR2W-136724 DIAG        2023-05-18 00:00:00 Tijdenskan. - Hamd…
#>  8         74535 VR2W-136724 DIAG        2023-03-22 12:00:00 Tijdenskan. - Hamd…
#>  9         74535 VR2W-136724 BATTERY     2023-03-06 00:00:00 Tijdenskan. - Hamd…
#> 10         74535 VR2W-136724 DIAG        2022-08-21 11:00:00 Tijdenskan. - Hamd…
#> # ℹ 8,378 more rows
#> # ℹ 13 more variables: PPM_pings <int>, PPM_detections <int>,
#> #   device_time_UTC <dttm>, battery_voltage_V <dbl>, RTC_time <chr>,
#> #   `memory_remaining_%` <dbl>, event_type <chr>, source <chr>,
#> #   external_time_UTC <dttm>, external_difference_s <int>, original_file <chr>,
#> #   external_time_zone <chr>, PPM_total_accepted_detections <int>
```
