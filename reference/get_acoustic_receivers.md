# Get acoustic receiver data

Get data for acoustic receivers, with options to filter results.

## Usage

``` r
get_acoustic_receivers(connection, receiver_id = NULL, status = NULL)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- receiver_id:

  Character (vector). One or more receiver identifiers.

- status:

  Character. One or more statuses, e.g. `available` or `broken`.

## Value

A tibble with acoustic receiver data, sorted by `receiver_id`. See also
[field
definitions](https://inbo.github.io/etn/articles/etn_fields.html).
Values for `owner_organization` will only be visible if you are member
of the group.

## Examples

``` r
# Get all acoustic receivers
get_acoustic_receivers()
#> # A tibble: 8,870 × 23
#>    receiver_id  manufacturer receiver_model receiver_serial_number modem_address
#>    <chr>        <chr>        <chr>          <chr>                  <chr>        
#>  1 ADTT-3       THELMA BIOT… ADTT           3                      NA           
#>  2 ADTT-4       THELMA BIOT… ADTT           4                      NA           
#>  3 ASCENT-AR-5… INNOVASEA    ASCENT         580023                 NA           
#>  4 ASCENT-AR-5… INNOVASEA    ASCENT         580025                 NA           
#>  5 ASCENT-AR-5… INNOVASEA    ASCENT         580027                 NA           
#>  6 ASCENT-AR-5… INNOVASEA    ASCENT         580109                 NA           
#>  7 BATTERY PAC… INNOVASEA    BATTERY PACK   151                    NA           
#>  8 BATTERY PAC… INNOVASEA    BATTERY PACK   159                    NA           
#>  9 BATTERY-153  INNOVASEA    BATTERY        153                    NA           
#> 10 BENTHIC POD… INNOVASEA    BENTHIC POD    BENTHIC POD-162        NA           
#> # ℹ 8,860 more rows
#> # ℹ 18 more variables: status <chr>, battery_estimated_life <chr>,
#> #   owner_organization <chr>, financing_project <chr>,
#> #   built_in_acoustic_tag_id <chr>, ar_model <chr>, ar_serial_number <chr>,
#> #   ar_battery_estimated_life <chr>, ar_voltage_at_deploy <chr>,
#> #   ar_interrogate_code <chr>, ar_receive_frequency <chr>,
#> #   ar_reply_frequency <chr>, ar_ping_rate <chr>, …

# Get lost and broken acoustic receivers
get_acoustic_receivers(status = c("lost", "broken"))
#> # A tibble: 394 × 23
#>    receiver_id  manufacturer receiver_model receiver_serial_number modem_address
#>    <chr>        <chr>        <chr>          <chr>                  <chr>        
#>  1 HR2-461210   INNOVASEA    HR2-180K-100-… 461210                 NA           
#>  2 NexTrak-R1-… INNOVASEA    NexTrak-R1     800391                 NA           
#>  3 NexTrak-R1-… INNOVASEA    NexTrak-R1     800392                 NA           
#>  4 NexTrak-R1-… INNOVASEA    NexTrak-R1     800394                 NA           
#>  5 NexTrak-R1-… INNOVASEA    NexTrak-R1     800398                 NA           
#>  6 TBR700-0011… THELMA BIOT… TBR700         001195                 NA           
#>  7 TBR700-0011… THELMA BIOT… TBR700         001197                 NA           
#>  8 TBR700-0017… THELMA BIOT… TBR700         001768                 NA           
#>  9 TBR700-158   THELMA BIOT… NA             158                    NA           
#> 10 TBR700-558   THELMA BIOT… NA             558                    NA           
#> # ℹ 384 more rows
#> # ℹ 18 more variables: status <chr>, battery_estimated_life <chr>,
#> #   owner_organization <chr>, financing_project <chr>,
#> #   built_in_acoustic_tag_id <chr>, ar_model <chr>, ar_serial_number <chr>,
#> #   ar_battery_estimated_life <chr>, ar_voltage_at_deploy <chr>,
#> #   ar_interrogate_code <chr>, ar_receive_frequency <chr>,
#> #   ar_reply_frequency <chr>, ar_ping_rate <chr>, …

# Get a specific acoustic receiver
get_acoustic_receivers(receiver_id = "VR2W-124070")
#> # A tibble: 1 × 23
#>   receiver_id manufacturer receiver_model receiver_serial_number modem_address
#>   <chr>       <chr>        <chr>          <chr>                  <chr>        
#> 1 VR2W-124070 INNOVASEA    VR2W           124070                 NA           
#> # ℹ 18 more variables: status <chr>, battery_estimated_life <chr>,
#> #   owner_organization <chr>, financing_project <chr>,
#> #   built_in_acoustic_tag_id <chr>, ar_model <chr>, ar_serial_number <chr>,
#> #   ar_battery_estimated_life <chr>, ar_voltage_at_deploy <chr>,
#> #   ar_interrogate_code <chr>, ar_receive_frequency <chr>,
#> #   ar_reply_frequency <chr>, ar_ping_rate <chr>, ar_enable_code_address <chr>,
#> #   ar_release_code <chr>, ar_disable_code <chr>, ar_tilt_code <chr>, …
```
