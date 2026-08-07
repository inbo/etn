edito <- rstac::stac("https://api.dive.edito.eu/data")

items <- edito |>
  rstac::stac_search(
    collections = "animal_tracking_datasets",

    # xmin, ymin, xmax, ymax in longitude/latitude
    bbox = c(2, 49, 8, 54),

    # ISO 8601 time interval
    datetime = "2024-01-01T00:00:00Z/2025-12-31T23:59:59Z",

    limit = 100
  ) |>
  rstac::get_request()

# try starting from a set collection endpoint:

"api.dive.edito.eu/data/collections/animal_tracking_datasets" |>
  rstac::stac()

## try finding the etn catalog

rstac::stac(
  "https://api.dive.edito.eu/data/catalogs/projects/european_tracking_network/"
) |>
  rstac::get_request()

## now place a query to these

rstac::stac(
  "https://api.dive.edito.eu/data/catalogs/projects/european_tracking_network/"
) |>
  rstac::stac_search()


# two part query

## first get all item ids that are etn items:

### via httr2
"https://api.dive.edito.eu/data/search?q=projects%2Feuropean_tracking_network" |>
  httr2::request() |>
  httr2::req_perform() |>
  httr2::resp_body_json(check_type = FALSE)

### can i do this via stac?
"https://api.dive.edito.eu/data/search?q=projects%2Feuropean_tracking_network" |>
  rstac::stac() |>
  rstac::get_request() |>
  length()

#### as a static catalog?
"https://api.dive.edito.eu/data/search?q=projects%2Feuropean_tracking_network" |>
  rstac::read_stac() |>
  rstac::links(rel == "next") |>
  purrr::map(rstac::link_open)

# with rstac::items_matched() we can see the total number of items matched in our query
# Force to a tibble with rstac::items_as_tibble()

## Filtering on a species
"https://api.dive.edito.eu/data/search?q=projects%2Feuropean_tracking_network" |>
  # read as a static catalog
  rstac::read_stac() |>
  # Here we would have to fetch all items first, via pagination, before filtering
  rstac::items_filter("Chondrichthyes" %in% properties$taxa) |>
  # Downloading the parquet file: you'll have to filter it down again as the
  # catalog filter only selects the files that pass the query, but doesn't
  # actually filter records within a query.
  rstac::assets_url(asset_name = "data") |>
  arrow::read_parquet()

## pagination
"https://api.dive.edito.eu/data/search?q=projects%2Feuropean_tracking_network" |>
  # read as a static catalog
  rstac::read_stac() |>
  rstac::links(rel == "next") |>
  purrr::pluck(1) |>
  rstac::link_open()

get_etn_items <- function(
  catalog_url = "https://api.dive.edito.eu/data/search?q=projects%2Feuropean_tracking_network"
) {
  etn_url <- catalog_url
  # init objects for loop
  next_page_url <- etn_url
  items_tbl <- list()
  repeat {
    items <- rstac::read_stac(next_page_url)
    items_tbl <- append(items_tbl, list(rstac::items_as_tibble(items)))

    next_page_links <- items |>
      rstac::links(rel == "next")
    # Stop if this was the last page
    if (length(next_page_links) < 1) {
      break
    }

    # Extract the url of the next page
    next_page_url <-
      next_page_links |>
      purrr::chuck(1) |>
      # if not found, return NULL
      purrr::pluck("href", .default = NA)
  }
  # Combine results
  purrr::list_rbind(items_tbl)
}
