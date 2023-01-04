#' List all available animal ids
#'
#' @param credentials Login credentials to the ETN database, as created by
#'   `get_credentials()`
#' @return A vector of all unique `id_pk` present in `common.animal_release`.
#' @export
list_animal_ids_api <- function(credentials = get_credentials()) {
  api_domain <- "https://opencpu.lifewatch.be"
  function_path <- "library/etn/R/list_animal_ids"

  # POST the function request to the api_domain, request json as direct return
  response <-
    httr::POST(paste(api_domain, function_path, "json", sep = "/"),
      body = list(
        con = credentials
      )
    )
  # If request was not successful, generate a warning
  httr::warn_for_status(response, "submit request to API server")

  # Parse server response JSON to a vector
  response %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyVector = TRUE)
}
