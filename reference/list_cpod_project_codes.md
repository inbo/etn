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

A vector of all unique `project_code` of `type = "cpod"` in
`project.sql`.

## Examples

``` r
list_cpod_project_codes()
#>  [1] "Apelafico_acoustics"  "Apelafico_underwater" "ARMS_MBON_Belgium"   
#>  [4] "CODEVCO"              "cpod-lifewatch"       "cpod-od-natuur"      
#>  [7] "Lifewatch_extra"      "Lifewatch_test"       "NOVANA"              
#> [10] "PAM-Borssele"         "PelFish"              "PhD_Parcerisas"      
#> [13] "PureWind"             "SEAWave"              "SMGMIT"              
#> [16] "STRAITS_PAM"          "VLIZ-MRC-AMUC-001"    "VLIZ-MRC-AMUC-002"   
#> [19] "WaveHub"             
```
