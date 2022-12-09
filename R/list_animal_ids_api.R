# library(etn)
# con <- connect_to_etn()
# write_dwc(
#   animal_project_code = "2014_demer")
#

library(httr)

# set access credentials --------------------------------------------------



Sys.setenv(userid = "pieter.huybrechts@inbo.be")
Sys.setenv(pwd = askpass::askpass())

# function to get credentials

#' Get the credentials from environement variables, or set them manually
#'
#' By default, it's not neccesairy to set any values in this function as it's
#' used in the background by other functions. However, if you wish to provide
#' your username and password on a per function basis, this function allows you
#' to do so.
#'
#' @param username ETN Data username, by default read from the environement, but
#'   you can set it manually too.
#' @param password ETN Data password, by default read from the environement, but
#'   you can set it manually too.
#'
#' @return A string as it is ingested by other functions that need
#'   authentification
#' @export
#'
#' @examples
get_credentials <-
  function(username = Sys.getenv("userid"),
           password = Sys.getenv("pwd")) {
    stringr::str_glue('list(username = "{username}", password = "{password}")')
  }

# try the opencpu API --------------------------------------------------------

# Dont Run, little draft to explore possibilities
while(FALSE){
api_domain <- "https://opencpu.lifewatch.be"
function_path <- "library/etn/R/list_animal_ids"
userid <- "pieter.huybrechts@inbo.be"


# pass credentials/function arguments as a string
response <-
  POST(file.path(api_domain,
       function_path),
       body = list(
         con = stringr::str_glue(
           "list(username='{userid}', password='{askpass::askpass()}')",
         )
       ))

content(response, as = "text")

extract_temp_key <- function(response){
  response %>%
    httr::content(as = "text") %>%
    stringr::str_extract("(?<=tmp\\/).{15}(?=\\/)")
}

temp_key <- extract_temp_key(response)

}
# retreive as json directly in a single call -----------------------------------


# as a function

list_animal_ids <- function(credentials = get_credentials()) {
  api_domain <- "https://opencpu.lifewatch.be"
  function_path <- "library/etn/R/list_animal_ids"

  response <-
    POST(stringr::str_glue(api_domain,function_path,"json",.sep = "/"),
         body = list(
           con = credentials
         ))
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
response <- httr::POST("https://cloud.opencpu.org/ocpu/library/stats/R/rnorm",
           body = list(n = 10,
                       mean = 5))

response %>%
  extract_temp_key() %>%
  get_val(api_domain = "https://cloud.opencpu.org/ocpu")

