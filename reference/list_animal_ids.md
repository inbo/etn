# List all available animal ids

List all available animal ids

## Usage

``` r
list_animal_ids(connection)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

## Value

A vector of all unique `id_pk` present in `common.animal_release`.
