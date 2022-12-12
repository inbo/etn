

# library(httr)

# set access credentials --------------------------------------------------



# Sys.setenv(userid = "pieter.huybrechts@inbo.be")
# Sys.setenv(pwd = askpass::askpass())




# try the opencpu API --------------------------------------------------------

# # Dont Run, little draft to explore possibilities
# while(FALSE){
# api_domain <- "https://opencpu.lifewatch.be"
# function_path <- "library/etn/R/list_animal_ids"
# userid <- "pieter.huybrechts@inbo.be"
#
#
# # pass credentials/function arguments as a string
# response <-
#   POST(file.path(api_domain,
#        function_path),
#        body = list(
#          con = stringr::str_glue(
#            "list(username='{userid}', password='{askpass::askpass()}')",
#          )
#        ))
#
# content(response, as = "text")
#
# extract_temp_key <- function(response){
#   response %>%
#     httr::content(as = "text") %>%
#     stringr::str_extract("(?<=tmp\\/).{15}(?=\\/)")
# }
#
# temp_key <- extract_temp_key(response)
#
# }
# retreive as json directly in a single call -----------------------------------


# as a function

#' List all available animal ids
#' @inherit list_animal_ids
#'
#' @param credentials Login credentials to the ETN database, as created by
#'   `get_credentials()`
#' @export
list_animal_ids_api <- function(credentials = get_credentials()) {
  api_domain <- "https://opencpu.lifewatch.be"
  function_path <- "library/etn/R/list_animal_ids"

  # POST the function request to the api_domain, request json as direct return
  response <-
    httr::POST(stringr::str_glue(api_domain,function_path,"json",.sep = "/"),
         body = list(
           con = credentials
         ))
  # If request was not succesful, generate a warning
  httr::warn_for_status(response, "submit request to API server")

  # Parse server response JSON to a vector
  response %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyVector = TRUE)
}

# two step alternative, POST then GET result ------------------------------

# NOTE this approach allows for compression and is not dependent on parsing the
# JSON response, which might be benefitial when we are retreiving larger objects

# get evaluated object as a function




