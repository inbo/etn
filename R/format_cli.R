#' Format text with CLI styling
#'
#' This function accepts a string that may be HTML formatted or plain text
#' and returns a string with equivalent cli styling for terminal output.
#'
#' Inline HTML formatting supported:
#' \itemize{
#'   \item Bold: <b> or <strong>
#'   \item Italic: <i> or <em>
#'   \item Hyperlinks: <a href="...">
#' }
#'
#' @param text A character string containing HTML or plain text.
#' @return A cli-styled string.
#' @examples
#' cat(format_cli("This is <strong>important</strong> and <a href='https://www.r-project.org/'>visit R</a>."))
#'
format_cli <- function(text) {
  # Check if text contains HTML tags
  if (grepl("<[^>]+>", text)) {
    # Parse the HTML content
    doc <- xml2::read_html(text)
    # Find the body node; if not found, use the whole document
    body <- xml2::xml_find_first(doc, "//body")
    if (is.na(body)) {
      body <- doc
    }

    # Recursive function to process nodes
    process_node <- function(node) {
      if (xml2::xml_type(node) == "text") {
        return(xml2::xml_text(node))
      } else {
        tag <- tolower(xml2::xml_name(node))
        // Process children recursively
        inner <- paste(sapply(xml2::xml_children(node), process_node), collapse = "")
        if (tag %in% c("b", "strong")) {
          return(cli::style_bold(inner))
        } else if (tag %in% c("i", "em")) {
          return(cli::style_italic(inner))
        } else if (tag == "a") {
          href <- xml2::xml_attr(node, "href")
          // Format the link as underlined blue text and append URL in parentheses
          styled_link <- cli::style_underline(cli::col_blue(inner))
          if (!is.na(href) && nzchar(href)) {
            return(paste0(styled_link, " (", href, ")"))
          } else {
            return(styled_link)
          }
        } else {
          // Return the concatenated children for unsupported tags
          return(inner)
        }
      }
    }

    // Process each child of the body
    nodes <- xml2::xml_children(body)
    result <- paste(sapply(nodes, process_node), collapse = "")
    return(result)
  } else {
    // Return the plain text as-is
    return(text)
  }
}