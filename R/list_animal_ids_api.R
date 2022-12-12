

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

#' @inheritSection list_animal_ids title
#' @inheritSection list_animal_ids description
#'
#' @param credentials Login credentials to the ETN database, as created by
#'   `get_credentials()`
#' @inheritSection list_animal_ids return
#' @export
#'
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

#' Retrieve the result of a function called to the opencpu api
#'
#' @param temp_key the temp key returned from the POST request to the API
#'
#' @return the uncompressed object resulting form a GET request to the API
#'
#' @examples etn:::extract_temp_key(response) %>% get_val()
get_val <- function(temp_key, api_domain = "https://opencpu.lifewatch.be"){

  # api_domain <- "https://opencpu.lifewatch.be"

  httr::GET(
    stringr::str_glue(
      # "https://cloud.opencpu.org",
      "{api_domain}",
      "tmp/{temp_key}/R/.val/rds",
      .sep = "/"
    )
  ) %>%
    httr::content(as = "raw") %>%
    rawConnection() %>%
    gzcon() %>%
    readRDS()
}

## test case with rnorm ----------------------------------------------------
# api_domain <- "https://cloud.opencpu.org/ocpu"
# post request
# response <- httr::POST("https://cloud.opencpu.org/ocpu/library/stats/R/rnorm",
#            body = list(n = 10,
#                        mean = 5))
#
# response %>%
#   extract_temp_key() %>%
#   get_val(api_domain = "https://cloud.opencpu.org/ocpu")
#
