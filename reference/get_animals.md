# Get animal data

Get data for animals, with options to filter results. Associated tag
information is available in columns starting with `tag` and
`acoustic_tag_id`. If multiple tags are associated with a single animal,
the information is comma-separated.

## Usage

``` r
get_animals(
  connection,
  animal_id = NULL,
  tag_serial_number = NULL,
  animal_project_code = NULL,
  scientific_name = NULL
)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- animal_id:

  Integer (vector). One or more animal identifiers.

- tag_serial_number:

  Character (vector). One or more tag serial numbers.

- animal_project_code:

  Character (vector). One or more animal project codes.
  Case-insensitive.

- scientific_name:

  Character (vector). One or more scientific names.

## Value

A tibble with animals data, sorted by `animal_project_code`,
`release_date_time` and `tag_serial_number`.

## See also

Other access functions:
[`get_acoustic_deployments()`](https://inbo.github.io/etn/reference/get_acoustic_deployments.md),
[`get_acoustic_detections()`](https://inbo.github.io/etn/reference/get_acoustic_detections.md),
[`get_acoustic_projects()`](https://inbo.github.io/etn/reference/get_acoustic_projects.md),
[`get_acoustic_receivers()`](https://inbo.github.io/etn/reference/get_acoustic_receivers.md),
[`get_animal_projects()`](https://inbo.github.io/etn/reference/get_animal_projects.md),
[`get_cpod_projects()`](https://inbo.github.io/etn/reference/get_cpod_projects.md),
[`get_tags()`](https://inbo.github.io/etn/reference/get_tags.md)

## Examples

``` r
# Get all animals
get_animals()
#> # A tibble: 30,683 × 66
#>    animal_id animal_project_code tag_serial_number tag_type tag_subtype
#>        <int> <chr>               <chr>             <chr>    <chr>      
#>  1      5923 2004_Gudena         1208              acoustic animal     
#>  2      5924 2004_Gudena         1209              acoustic animal     
#>  3      5915 2004_Gudena         7416              acoustic animal     
#>  4      5916 2004_Gudena         7417              acoustic animal     
#>  5      5917 2004_Gudena         7418              acoustic animal     
#>  6      5918 2004_Gudena         7419              acoustic animal     
#>  7      5919 2004_Gudena         7420              acoustic animal     
#>  8      5920 2004_Gudena         7421              acoustic animal     
#>  9      5921 2004_Gudena         7422              acoustic animal     
#> 10      5922 2004_Gudena         7423              acoustic animal     
#> # ℹ 30,673 more rows
#> # ℹ 61 more variables: acoustic_tag_id <chr>,
#> #   acoustic_tag_id_alternative <chr>, scientific_name <chr>,
#> #   common_name <chr>, aphia_id <int>, animal_label <chr>,
#> #   animal_nickname <chr>, tagger <chr>, capture_date_time <dttm>,
#> #   capture_location <chr>, capture_latitude <dbl>, capture_longitude <dbl>,
#> #   capture_method <chr>, capture_depth <chr>, …

# Get specific animals
get_animals(animal_id = 305) # Or string value "305"
#> # A tibble: 1 × 66
#>   animal_id animal_project_code tag_serial_number tag_type tag_subtype
#>       <int> <chr>               <chr>             <chr>    <chr>      
#> 1       305 2014_demer          1187450           acoustic animal     
#> # ℹ 61 more variables: acoustic_tag_id <chr>,
#> #   acoustic_tag_id_alternative <chr>, scientific_name <chr>,
#> #   common_name <chr>, aphia_id <int>, animal_label <chr>,
#> #   animal_nickname <chr>, tagger <chr>, capture_date_time <dttm>,
#> #   capture_location <chr>, capture_latitude <dbl>, capture_longitude <dbl>,
#> #   capture_method <chr>, capture_depth <chr>,
#> #   capture_temperature_change <chr>, release_date_time <dttm>, …
get_animals(animal_id = c(304, 305, 2827))
#> # A tibble: 3 × 66
#>   animal_id animal_project_code   tag_serial_number tag_type         tag_subtype
#>       <int> <chr>                 <chr>             <chr>            <chr>      
#> 1       304 2014_demer            1187449           acoustic         animal     
#> 2       305 2014_demer            1187450           acoustic         animal     
#> 3      2827 2015_phd_verhelst_cod 1271054,1271054   acoustic-archiv… animal,ani…
#> # ℹ 61 more variables: acoustic_tag_id <chr>,
#> #   acoustic_tag_id_alternative <chr>, scientific_name <chr>,
#> #   common_name <chr>, aphia_id <int>, animal_label <chr>,
#> #   animal_nickname <chr>, tagger <chr>, capture_date_time <dttm>,
#> #   capture_location <chr>, capture_latitude <dbl>, capture_longitude <dbl>,
#> #   capture_method <chr>, capture_depth <chr>,
#> #   capture_temperature_change <chr>, release_date_time <dttm>, …

# Get animals from specific animal project(s)
get_animals(animal_project_code = "2014_demer")
#> # A tibble: 16 × 66
#>    animal_id animal_project_code tag_serial_number tag_type tag_subtype
#>        <int> <chr>               <chr>             <chr>    <chr>      
#>  1       304 2014_demer          1187449           acoustic animal     
#>  2       384 2014_demer          1157781           acoustic animal     
#>  3       385 2014_demer          1157782           acoustic animal     
#>  4       386 2014_demer          1157783           acoustic animal     
#>  5       305 2014_demer          1187450           acoustic animal     
#>  6       383 2014_demer          1157780           acoustic animal     
#>  7       369 2014_demer          1171781           acoustic animal     
#>  8       370 2014_demer          1171782           acoustic animal     
#>  9       365 2014_demer          1171775           acoustic animal     
#> 10       366 2014_demer          1171776           acoustic animal     
#> 11       368 2014_demer          1171780           acoustic animal     
#> 12       382 2014_demer          1157779           acoustic animal     
#> 13       371 2014_demer          1171783           acoustic animal     
#> 14       372 2014_demer          1171784           acoustic animal     
#> 15       367 2014_demer          1171777           acoustic animal     
#> 16       306 2014_demer          1187468           acoustic animal     
#> # ℹ 61 more variables: acoustic_tag_id <chr>,
#> #   acoustic_tag_id_alternative <chr>, scientific_name <chr>,
#> #   common_name <chr>, aphia_id <int>, animal_label <chr>,
#> #   animal_nickname <chr>, tagger <chr>, capture_date_time <dttm>,
#> #   capture_location <chr>, capture_latitude <dbl>, capture_longitude <dbl>,
#> #   capture_method <chr>, capture_depth <chr>,
#> #   capture_temperature_change <chr>, release_date_time <dttm>, …
get_animals(animal_project_code = c("2014_demer", "2015_dijle"))
#> # A tibble: 42 × 66
#>    animal_id animal_project_code tag_serial_number tag_type tag_subtype
#>        <int> <chr>               <chr>             <chr>    <chr>      
#>  1       304 2014_demer          1187449           acoustic animal     
#>  2       384 2014_demer          1157781           acoustic animal     
#>  3       385 2014_demer          1157782           acoustic animal     
#>  4       386 2014_demer          1157783           acoustic animal     
#>  5       305 2014_demer          1187450           acoustic animal     
#>  6       383 2014_demer          1157780           acoustic animal     
#>  7       369 2014_demer          1171781           acoustic animal     
#>  8       370 2014_demer          1171782           acoustic animal     
#>  9       365 2014_demer          1171775           acoustic animal     
#> 10       366 2014_demer          1171776           acoustic animal     
#> # ℹ 32 more rows
#> # ℹ 61 more variables: acoustic_tag_id <chr>,
#> #   acoustic_tag_id_alternative <chr>, scientific_name <chr>,
#> #   common_name <chr>, aphia_id <int>, animal_label <chr>,
#> #   animal_nickname <chr>, tagger <chr>, capture_date_time <dttm>,
#> #   capture_location <chr>, capture_latitude <dbl>, capture_longitude <dbl>,
#> #   capture_method <chr>, capture_depth <chr>, …

# Get animals associated with a specific tag_serial_number
get_animals(tag_serial_number = "1187450")
#> # A tibble: 1 × 66
#>   animal_id animal_project_code tag_serial_number tag_type tag_subtype
#>       <int> <chr>               <chr>             <chr>    <chr>      
#> 1       305 2014_demer          1187450           acoustic animal     
#> # ℹ 61 more variables: acoustic_tag_id <chr>,
#> #   acoustic_tag_id_alternative <chr>, scientific_name <chr>,
#> #   common_name <chr>, aphia_id <int>, animal_label <chr>,
#> #   animal_nickname <chr>, tagger <chr>, capture_date_time <dttm>,
#> #   capture_location <chr>, capture_latitude <dbl>, capture_longitude <dbl>,
#> #   capture_method <chr>, capture_depth <chr>,
#> #   capture_temperature_change <chr>, release_date_time <dttm>, …

# Get animals of specific species (across all projects)
get_animals(scientific_name = c("Rutilus rutilus", "Silurus glanis"))
#> # A tibble: 358 × 66
#>    animal_id animal_project_code tag_serial_number tag_type tag_subtype
#>        <int> <chr>               <chr>             <chr>    <chr>      
#>  1       304 2014_demer          1187449           acoustic animal     
#>  2       384 2014_demer          1157781           acoustic animal     
#>  3       385 2014_demer          1157782           acoustic animal     
#>  4       386 2014_demer          1157783           acoustic animal     
#>  5       305 2014_demer          1187450           acoustic animal     
#>  6       369 2014_demer          1171781           acoustic animal     
#>  7       370 2014_demer          1171782           acoustic animal     
#>  8       365 2014_demer          1171775           acoustic animal     
#>  9       366 2014_demer          1171776           acoustic animal     
#> 10       368 2014_demer          1171780           acoustic animal     
#> # ℹ 348 more rows
#> # ℹ 61 more variables: acoustic_tag_id <chr>,
#> #   acoustic_tag_id_alternative <chr>, scientific_name <chr>,
#> #   common_name <chr>, aphia_id <int>, animal_label <chr>,
#> #   animal_nickname <chr>, tagger <chr>, capture_date_time <dttm>,
#> #   capture_location <chr>, capture_latitude <dbl>, capture_longitude <dbl>,
#> #   capture_method <chr>, capture_depth <chr>, …

# Get animals of a specific species from a specific project
get_animals(animal_project_code = "2014_demer", scientific_name = "Rutilus rutilus")
#> # A tibble: 2 × 66
#>   animal_id animal_project_code tag_serial_number tag_type tag_subtype
#>       <int> <chr>               <chr>             <chr>    <chr>      
#> 1       304 2014_demer          1187449           acoustic animal     
#> 2       305 2014_demer          1187450           acoustic animal     
#> # ℹ 61 more variables: acoustic_tag_id <chr>,
#> #   acoustic_tag_id_alternative <chr>, scientific_name <chr>,
#> #   common_name <chr>, aphia_id <int>, animal_label <chr>,
#> #   animal_nickname <chr>, tagger <chr>, capture_date_time <dttm>,
#> #   capture_location <chr>, capture_latitude <dbl>, capture_longitude <dbl>,
#> #   capture_method <chr>, capture_depth <chr>,
#> #   capture_temperature_change <chr>, release_date_time <dttm>, …
```
