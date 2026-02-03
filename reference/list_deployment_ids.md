# List all available receiver ids

List all available receiver ids

## Usage

``` r
list_deployment_ids(connection)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

## Value

A vector of all unique `id_pk` present in `acoustic.deployments`.
