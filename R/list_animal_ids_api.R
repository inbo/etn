#' List all available animal ids
#'
#' @param credentials Login credentials to the ETN database, as created by
#'   `get_credentials()`
#' @return A vector of all unique `id_pk` present in `common.animal_release`.
#' @export
list_animal_ids_api <- function(credentials = get_credentials()) {
  endpoint <- "https://opencpu.lifewatch.be/library/etn/R/list_animal_ids"
  # POST the function request to the api_domain, request json as direct return
  response <-
    httr::POST(paste(endpoint, "json", sep = "/"),
      body = list(
        con = credentials
      )
    )
  # If request was not successful, generate a warning
  httr::warn_for_status(response, "submit request to API server")
  # Check if the response has the expected content type
  check_content_type(response,"application/json")
  # Parse server response JSON to a vector
  response %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyVector = TRUE)
}
