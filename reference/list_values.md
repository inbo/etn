# List all unique values from a data.frame column

Get a vector with all unique values found in a given column of a
data.frame. Concatenated values (`A,B`) in the column can be returned as
single values (`A` and `B`).

## Usage

``` r
list_values(.data, column, split = ",")
```

## Arguments

- .data:

  Data frame. Data.frame to select column from.

- column:

  Character or integer. Quoted or unqoted column name or column
  position.

- split:

  Character (vector). Character or regular expression(s) passed to
  [`strsplit()`](https://rdrr.io/r/base/strsplit.html) to split column
  values before returning unique values. Defaults to `,`.

## Value

A vector of the same type as the given column.

## See also

Other list functions:
[`list_acoustic_project_codes()`](https://inbo.github.io/etn/reference/list_acoustic_project_codes.md),
[`list_acoustic_tag_ids()`](https://inbo.github.io/etn/reference/list_acoustic_tag_ids.md),
[`list_animal_ids()`](https://inbo.github.io/etn/reference/list_animal_ids.md),
[`list_animal_project_codes()`](https://inbo.github.io/etn/reference/list_animal_project_codes.md),
[`list_cpod_project_codes()`](https://inbo.github.io/etn/reference/list_cpod_project_codes.md),
[`list_deployment_ids()`](https://inbo.github.io/etn/reference/list_deployment_ids.md),
[`list_receiver_ids()`](https://inbo.github.io/etn/reference/list_receiver_ids.md),
[`list_scientific_names()`](https://inbo.github.io/etn/reference/list_scientific_names.md),
[`list_station_names()`](https://inbo.github.io/etn/reference/list_station_names.md),
[`list_tag_serial_numbers()`](https://inbo.github.io/etn/reference/list_tag_serial_numbers.md)

## Examples

``` r
# List unique scientific_name from a dataframe containing animal information
df <- get_animals(animal_project_code = "2014_demer")
list_values(df, "scientific_name")
#> 4 unique scientific_name values
#> [1] "Rutilus rutilus"    "Silurus glanis"     "Squalius cephalus" 
#> [4] "Petromyzon marinus"

# Or using pipe and unquoted column name
df |> list_values(scientific_name)
#> 4 unique scientific_name values
#> [1] "Rutilus rutilus"    "Silurus glanis"     "Squalius cephalus" 
#> [4] "Petromyzon marinus"

# Or using column position
df |> list_values(8)
#> 1 unique scientific_name values
#> # A tibble: 4 × 1
#>   scientific_name   
#>   <chr>             
#> 1 Rutilus rutilus   
#> 2 Silurus glanis    
#> 3 Squalius cephalus 
#> 4 Petromyzon marinus

# tag_serial_number can contain comma-separated values
df <- get_animals(animal_id = 5841)
df$tag_serial_number
#> [1] "1280688,1280688"

# list_values() will split those and return unique values
list_values(df, tag_serial_number)
#> 1 unique tag_serial_number values
#> [1] "1280688"

# Another expression can be defined to split values (here ".")
list_values(df, tag_serial_number, split = "\\.")
#> 1 unique tag_serial_number values
#> [1] "1280688,1280688"
```
