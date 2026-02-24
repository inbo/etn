# Transform ETN data to Darwin Core

Transforms and downloads data from a European Tracking Network **animal
project** to [Darwin Core](https://dwc.tdwg.org/). The resulting CSV
file(s) can be uploaded to an [IPT](https://www.gbif.org/ipt) for
publication to OBIS and/or GBIF. A `meta.xml` or `eml.xml` file are not
created.

## Usage

``` r
write_dwc(
  connection,
  animal_project_code,
  directory = ".",
  rights_holder = NULL,
  license = "CC-BY"
)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

- animal_project_code:

  Animal project code.

- directory:

  Path to local directory to write file(s) to. If `NULL`, then a list of
  data frames is returned instead, which can be useful for
  extending/adapting the Darwin Core mapping before writing with
  [`readr::write_csv()`](https://readr.tidyverse.org/reference/write_delim.html).
  If the directory does not exist, it will be created.

- rights_holder:

  Acronym of the organization owning or managing the rights over the
  data.

- license:

  Identifier of the license under which the data will be published.

  - [`CC-BY`](https://creativecommons.org/licenses/by/4.0/legalcode)
    (default).

  - [`CC0`](https://creativecommons.org/publicdomain/zero/1.0/legalcode).

## Value

CSV file(s) written to disk or list of data frames when
`directory = NULL`.

## Transformation details

Data are transformed into an [Occurrence
core](https://rs.gbif.org/core/dwc_occurrence_2022-02-02.xml). This
**follows recommendations** discussed and created by Peter Desmet, Jonas
Mortelmans, Jonathan Pye, John Wieczorek and others. See the [SQL
file(s)](https://github.com/inbo/etn/tree/main/inst/sql) used by this
function for details.

Key features of the Darwin Core transformation:

- Deployments (animal+tag associations) are parent events, with capture,
  surgery, release, recapture (human observations) and acoustic
  detections (machine observations) as child events. No information
  about the parent event is provided other than its ID, meaning that
  data can be expressed in an Occurrence Core with one row per
  observation and `parentEventID` shared by all occurrences in a
  deployment.

- The release event often contains metadata about the animal (sex,
  lifestage, comments) and deployment as a whole.

- Acoustic detections are downsampled to the **first detection per
  hour**, to reduce the size of high-frequency data. Duplicate
  detections (same animal, tag and timestamp) are excluded. It is
  possible for a deployment to contain no detections, e.g. if the tag
  malfunctioned right after deployment.

## Examples

``` r
if (FALSE) { # \dontrun{
# Return a list of data.frames in Darwin Core format.
write_dwc(animal_project_code = "2010_phd_reubens", directory = NULL)
# Download files to disk
write_dwc("2014_demer", directory = ".")
} # }
```
