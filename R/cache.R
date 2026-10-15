etn_cache <- function(...) {
  # Create the cache object if it doesn't exist yet, this way we only create it
  # upon the first function that needs it.
  if(!exists("cache")) {
    cache <-
      cachem::cache_mem(
        max_age = getOption("etn.cache_mage_seconds"),
        max_size = getOption("etn.cache_msize_bytes"),
        ...
      )
  }
  # Return the cache.
  cache
}

get_cache <- function(key){
  etn_cache()$get(key)
}

set_cache <- function(key, value){
  etn_cache()$set(key, value)
}
