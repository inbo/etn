#' Conductor Helper: point the way to API or SQL helper
#'
#' Helper that conducts it's parent function to either use a helper to query the
#' api, or a helper to query a local database connection using SQL.
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
    out <- do.call(
      forward_to_api,
      list(function_identity = function_identity,
           payload = arguments_to_pass,
           ...)
    )
  } else {
    out <- do.call(utils::getFromNamespace(function_identity, ns = "etnservice"),
                   args = append(arguments_to_pass,
                                 list(credentials = get_credentials()),
                                 after = 0)
    )
  }

  return(out)
}
