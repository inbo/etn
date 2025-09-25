#' Conductor Helper: point the way to API or SQL helper
#'
#' Helper that conducts it's parent function to either use a helper to query the
#' api, or a helper to query a local database connection using SQL.
#'
#' This function will change the behaviour of etn based on the  value of the
#' `api` argument of it's functions. When `api == TRUE` it'll use the
#' function_identity, the name of the parent function that calls this helper to
#' create the api call via `forward_to_api()`. If `api == FALSE` it'll get the
#' correct function from the namespace of `etnservice` so it can query a local
#' database connection. The package was constructed this way to ensure
#' etnservice which creates the API via OpenCPU, and local queries to etn always
#' result in the same output as the api. This also ensures the actual queries
#' only need to be maintained in a single place. See examples to see in
#' practise.
#'
#' @param api Logical, Should the API be used?
#' @param ignored_arguments Character vector of arguments not to pass to the API
#'   or SQL helper
#' @param ... options on how to fetch the response. Forwarded to
#'   `forward_to_api()`
#'
#' @return parsed R object as resulting from the API
#'
#' @family helper functions
#' @noRd
#' @examplesIf "ETN" %in% odbc::odbcListDataSources()$name
#' # When API is FALSE, this package forwards function calls directly to
#' # etnservice
#'
#' # These two calls are identical. They run the same code (locally). Both will
#' # only work when there is a local connection to the etn database.
#' etnservice::list_acoustic_tag_ids()
#' list_acoustic_tag_ids(api = FALSE)
#'
conduct_parent_to_helpers <- function(api,
                                      ignored_arguments = NULL,
                                      ...) {
  # Check arguments
  assertthat::assert_that(assertthat::is.flag(api))
  assertthat::assert_that(is.character(ignored_arguments) |
                            is.null(ignored_arguments))

  # Lock in the name of the parent function
  function_identity <-
    get_parent_fn_name(depth = 2)

  # Get the argument values from the parent function
  arguments_to_pass <-
    return_parent_arguments(depth = 2)[
      !names(return_parent_arguments(depth = 2)) %in% c(
        "api",
        "connection",
        ignored_arguments,
        "function_identity"
      )
    ]

  if (api) {
    # Forward arguments to API via helper.
    out <- do.call(
      forward_to_api,
      list(function_identity = function_identity,
           payload = arguments_to_pass,
           ...)
    )
  } else {
    # Check if the local version of etnservice matches the one deployed on
    # OpenCPU.
    if (!etnservice_version_matches()) {
      deployed_version <- get_etnservice_version(api = TRUE)

      rlang::check_installed(
        "etnservice",
        version = deployed_version,
        # Ensure the exact version is installed, and not an even more recent
        # version (In case OpenCPU is lagging on the Github released version).
        compare = "==",
        reason =
          paste(
            "\nThere is a newer version of etnservice available",
            "please update",
            "to avoid differences between local and API queries."
          )
      )
    }

    out <- do.call(utils::getFromNamespace(function_identity, ns = "etnservice"),
                   args = append(arguments_to_pass,
                                 list(credentials = get_credentials()),
                                 after = 0)
    )
  }

  return(out)
}
