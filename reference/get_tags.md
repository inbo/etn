# Get tag data

Get data for tags, with options to filter results. Note that there can
be multiple records (`acoustic_tag_id`) per tag device
(`tag_serial_number`).

## Usage

``` r
get_tags(
  connection,
  tag_type = NULL,
  tag_subtype = NULL,
  tag_serial_number = NULL,
  acoustic_tag_id = NULL
)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- tag_type:

  Character (vector). `acoustic` or `archival`. Some tags are both, find
  those with `acoustic-archival`.

- tag_subtype:

  Character (vector). `animal`, `built-in`, `range` or `sentinel`.

- tag_serial_number:

  Character (vector). One or more tag serial numbers.

- acoustic_tag_id:

  Character (vector). One or more acoustic tag identifiers, i.e.
  identifiers found in
  [`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md).

## Value

A tibble with tags data, sorted by `tag_serial_number`. See also [field
definitions](https://inbo.github.io/etn/articles/etn_fields.html).
Values for `owner_organization` and `owner_pi` will only be visible if
you are member of the group.

## Examples

``` r
# Get all tags
get_tags()
#> # A tibble: 62,713 × 54
#>    tag_serial_number tag_type tag_subtype sensor_type acoustic_tag_id
#>    <chr>             <chr>    <chr>       <chr>       <chr>          
#>  1 0A4E2699          acoustic animal      NA          OPI-2699       
#>  2 0A4F2700          acoustic animal      NA          OPI-2700       
#>  3 0A4G2701          acoustic animal      NA          OPI-2701       
#>  4 0A4H2702          acoustic animal      NA          OPI-2702       
#>  5 0A4J2704          acoustic animal      NA          OPI-2704       
#>  6 0A6E              acoustic animal      NA          R64K-2381      
#>  7 0A6F              acoustic animal      NA          R64K-2382      
#>  8 0A6G              acoustic animal      NA          R64K-2383      
#>  9 0A6H              acoustic animal      NA          R64K-2384      
#> 10 0A6I              acoustic animal      NA          R64K-2385      
#> # ℹ 62,703 more rows
#> # ℹ 49 more variables: acoustic_tag_id_alternative <chr>, manufacturer <chr>,
#> #   model <chr>, frequency <chr>, status <chr>, activation_date <dttm>,
#> #   battery_estimated_life <chr>, battery_estimated_end_date <dttm>,
#> #   length <dbl>, diameter <dbl>, weight <dbl>, floating <lgl>,
#> #   archive_memory <chr>, sensor_slope <dbl>, sensor_intercept <dbl>,
#> #   sensor_range <chr>, sensor_range_min <dbl>, sensor_range_max <dbl>, …

# Get archival tags, including acoustic-archival
get_tags(tag_type = c("archival", "acoustic-archival"))
#> # A tibble: 16,003 × 54
#>    tag_serial_number tag_type          tag_subtype sensor_type acoustic_tag_id
#>    <chr>             <chr>             <chr>       <chr>       <chr>          
#>  1 0AE6              acoustic-archival animal      P           OPS-4207       
#>  2 0AE7              acoustic-archival animal      P           OPS-4208       
#>  3 0B4S              acoustic-archival animal      A           Ops-4552       
#>  4 0B4S              acoustic-archival animal      P           Ops-4553       
#>  5 0B4T              acoustic-archival animal      A           Ops-4554       
#>  6 0B4T              acoustic-archival animal      P           Ops-4555       
#>  7 0B4U              acoustic-archival animal      A           Ops-4556       
#>  8 0B4U              acoustic-archival animal      P           Ops-4557       
#>  9 0B4V              acoustic-archival animal      A           Ops-4558       
#> 10 0B4V              acoustic-archival animal      P           Ops-4559       
#> # ℹ 15,993 more rows
#> # ℹ 49 more variables: acoustic_tag_id_alternative <chr>, manufacturer <chr>,
#> #   model <chr>, frequency <chr>, status <chr>, activation_date <dttm>,
#> #   battery_estimated_life <chr>, battery_estimated_end_date <dttm>,
#> #   length <dbl>, diameter <dbl>, weight <dbl>, floating <lgl>,
#> #   archive_memory <chr>, sensor_slope <dbl>, sensor_intercept <dbl>,
#> #   sensor_range <chr>, sensor_range_min <dbl>, sensor_range_max <dbl>, …

# Get tags of specific subtype
get_tags(tag_subtype = c("built-in", "range"))
#> # A tibble: 2,927 × 54
#>    tag_serial_number tag_type          tag_subtype sensor_type acoustic_tag_id
#>    <chr>             <chr>             <chr>       <chr>       <chr>          
#>  1 04HD              acoustic-archival range       P           S64K-9795      
#>  2 04HD              acoustic-archival range       A           S64K-9796      
#>  3 04HE              acoustic-archival range       P           S64K-9797      
#>  4 04HE              acoustic-archival range       A           S64K-9798      
#>  5 04HF              acoustic-archival range       P           S64K-9799      
#>  6 04HF              acoustic-archival range       A           S64K-9800      
#>  7 04HH              acoustic-archival range       P           S64K-9803      
#>  8 04HH              acoustic-archival range       A           S64K-9804      
#>  9 04HI              acoustic-archival range       P           S64K-9805      
#> 10 04HI              acoustic-archival range       A           S64K-9806      
#> # ℹ 2,917 more rows
#> # ℹ 49 more variables: acoustic_tag_id_alternative <chr>, manufacturer <chr>,
#> #   model <chr>, frequency <chr>, status <chr>, activation_date <dttm>,
#> #   battery_estimated_life <chr>, battery_estimated_end_date <dttm>,
#> #   length <dbl>, diameter <dbl>, weight <dbl>, floating <lgl>,
#> #   archive_memory <chr>, sensor_slope <dbl>, sensor_intercept <dbl>,
#> #   sensor_range <chr>, sensor_range_min <dbl>, sensor_range_max <dbl>, …

# Get specific tags (note that these can return multiple records)
get_tags(tag_serial_number = "1187450")
#> # A tibble: 1 × 54
#>   tag_serial_number tag_type tag_subtype sensor_type acoustic_tag_id
#>   <chr>             <chr>    <chr>       <chr>       <chr>          
#> 1 1187450           acoustic animal      NA          A69-1601-16130 
#> # ℹ 49 more variables: acoustic_tag_id_alternative <chr>, manufacturer <chr>,
#> #   model <chr>, frequency <chr>, status <chr>, activation_date <dttm>,
#> #   battery_estimated_life <chr>, battery_estimated_end_date <dttm>,
#> #   length <dbl>, diameter <dbl>, weight <dbl>, floating <lgl>,
#> #   archive_memory <chr>, sensor_slope <dbl>, sensor_intercept <dbl>,
#> #   sensor_range <chr>, sensor_range_min <dbl>, sensor_range_max <dbl>,
#> #   sensor_resolution <dbl>, sensor_unit <chr>, sensor_accuracy <dbl>, …
get_tags(acoustic_tag_id = "A69-1601-16130")
#> # A tibble: 1 × 54
#>   tag_serial_number tag_type tag_subtype sensor_type acoustic_tag_id
#>   <chr>             <chr>    <chr>       <chr>       <chr>          
#> 1 1187450           acoustic animal      NA          A69-1601-16130 
#> # ℹ 49 more variables: acoustic_tag_id_alternative <chr>, manufacturer <chr>,
#> #   model <chr>, frequency <chr>, status <chr>, activation_date <dttm>,
#> #   battery_estimated_life <chr>, battery_estimated_end_date <dttm>,
#> #   length <dbl>, diameter <dbl>, weight <dbl>, floating <lgl>,
#> #   archive_memory <chr>, sensor_slope <dbl>, sensor_intercept <dbl>,
#> #   sensor_range <chr>, sensor_range_min <dbl>, sensor_range_max <dbl>,
#> #   sensor_resolution <dbl>, sensor_unit <chr>, sensor_accuracy <dbl>, …
get_tags(acoustic_tag_id = c("A69-1601-16129", "A69-1601-16130"))
#> # A tibble: 2 × 54
#>   tag_serial_number tag_type tag_subtype sensor_type acoustic_tag_id
#>   <chr>             <chr>    <chr>       <chr>       <chr>          
#> 1 1187449           acoustic animal      NA          A69-1601-16129 
#> 2 1187450           acoustic animal      NA          A69-1601-16130 
#> # ℹ 49 more variables: acoustic_tag_id_alternative <chr>, manufacturer <chr>,
#> #   model <chr>, frequency <chr>, status <chr>, activation_date <dttm>,
#> #   battery_estimated_life <chr>, battery_estimated_end_date <dttm>,
#> #   length <dbl>, diameter <dbl>, weight <dbl>, floating <lgl>,
#> #   archive_memory <chr>, sensor_slope <dbl>, sensor_intercept <dbl>,
#> #   sensor_range <chr>, sensor_range_min <dbl>, sensor_range_max <dbl>,
#> #   sensor_resolution <dbl>, sensor_unit <chr>, sensor_accuracy <dbl>, …
```
