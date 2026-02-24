# Connect to the ETN database

This function is **\[deprecated\]** since etn version 3.0.0. Its use is
no longer supported or needed. All connections to the ETN database are
now handled automatically when you use a function. If your credentials
are not stored in the system environment, you will be prompted to enter
them.

## Usage

``` r
connect_to_etn(...)
```

## Arguments

- ...:

  Any arguments passed to this function are ignored.

## Value

This function is no longer in use, and returns `NULL` invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
# This will result in a deprecation warning!
my_connection <- connect_to_etn()
} # }
```
