# list_animal_ids() warns for depreciation of connection

    Code
      animal_ids <- list_animal_ids(connection = "any_object")
    Warning <lifecycle_warning_deprecated>
      The `connection` argument of `list_animal_ids()` is deprecated as of etn v3.0.0.
      i Please set `api = FALSE` to use local database, otherwise the API will be used
      i The deprecated feature was likely used in the etn package.
        Please report the issue at <https://github.com/inbo/etn/issues>.

