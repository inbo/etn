#' Write EML
#'
#' @param imis_url URL to the IMIS page of the dataset.
#' @param metadata_provider List with metadata provider information.
#' @param directory Path to local directory to write file(s) to.
#' If `NULL`, then a list of data frames is returned instead, which can be
#' useful for extending/adapting the Darwin Core mapping before writing with
#' [readr::write_csv()].
#'
#' @returns
#' @export
#'
#' @examples
#' studies <- list(
#'   list(
#'     project_id <- "2015_PHD_VERHELST_COD",
#'     imis_url <- "https://www.vliz.be/en/imis?dasid=6581&doiid=435"
#'   ),
#'   list(
#'     project_id <- "2015_PHD_VERHELST_EEL",
#'     imis_url <- "https://www.vliz.be/en/imis?dasid=5850&doiid=434"
#'   )
#' )
#' metadata_provider <- person(
#'   given = "Peter",
#'   family = "Desmet",
#'   email = "peter.desmet@inbo.be",
#'   comment = c(ORCID = "0000-0002-8442-8025")
#' )
#' purrr::walk(
#'   studies, ~ write_eml(
#'   .x$imis_url,
#'   metadata_provider,
#'   directory = here::here("data", "processed", .x$project_id))
#' )

write_eml <- function(imis_url, metadata_provider, directory = NULL) {
  # Read and clean EML
  eml <- EML::read_eml(paste0(imis_url, "&show=eml"))

  ## Set update frequency` to `Not planned`
  eml$dataset$maintenance$maintenanceUpdateFrequency <- "Not planned"

  # Clean resource contacts and resource creators
  eml$dataset$creator <- purrr::map(eml$dataset$creator, clean_contact)
  eml$dataset$contact <- clean_contact(eml$dataset$contact)

  # Set metadata provider
  eml$dataset$metadataProvider <- EML::set_responsibleParty(
    givenName = metadata_provider$given,
    surName = metadata_provider$family,
    electronicMailAddress = metadata_provider$email,
    userId = if (!is.null(metadata_provider$comment[["ORCID"]])) {
      list(directory = "https://orcid.org/", metadata_provider$comment[["ORCID"]])
    } else {
      NULL
    }
  )

  #Remove description taxonomic coverage
  tax_coverage <- eml$dataset$coverage$taxonomicCoverage
  number_of_species <- length(tax_coverage)
  clean_coverage <- function(tax_coverage) {
    tax_coverage <- tax_coverage[names(tax_coverage) != "id"]
    tax_coverage <- tax_coverage[names(tax_coverage) != "generalTaxonomicCoverage"]
    return(tax_coverage)
  }

  if (number_of_species == 1) {
    eml$dataset$coverage$taxonomicCoverage$id <- NULL
    eml$dataset$coverage$taxonomicCoverage$generalTaxonomicCoverage <- NULL
  } else {
    eml$dataset$coverage$taxonomicCoverage <- purrr::map(tax_coverage, clean_coverage)
  }

  # Clean keywords
  eml$dataset$keywordSet <- purrr::map(eml$dataset$keywordSet, ~ {
    if (!"keywordThesaurus" %in% names(.)) {
      . <- c(., keywordThesaurus = "N/A")
    }
    .
  })

  # Remove associated parties
  eml$dataset$associatedParty <- NULL

  # Clean resource citation identifier
  identifier_raw <- eml$additionalMetadata$metadata$gbif$citation$identifier
  identifier <- sub("dx.", "", identifier_raw)
  eml$additionalMetadata$metadata$gbif$citation$identifier <- identifier

  # Get abstract and additional paragraphs
  abstract <- eml$dataset$abstract$para
  additional_info <- eml$dataset$additionalInfo$para

  # Split `additional_info` in paragraphs
  paragraphs <- unlist(strsplit(additional_info, "<p>|</p>|\n", perl = TRUE))
  paragraphs <- paragraphs[!paragraphs %in% c("", "<![CDATA[", "<br/>", "]]>")]
  paragraphs <- unlist(strsplit(paragraphs, " Data were exported from", perl = TRUE))

  # Add abstract to paragraphs
  paragraphs <- c(abstract, paragraphs) %>%
    # Add <p></p> tags to each paragraph
    purrr::map_chr(~ paste0("<p>", ., "</p>")) %>%
    # Remove <![CDATA[ ]]> wrappers (not needed anymore in EML 2.2.0)
    stringr::str_remove_all("<!\\[CDATA\\[|\\]\\]>") %>%
    # remove unsupported html tags
    stringr::str_remove_all("<i>|</i>|<br/>")

  # Extract publication year
  citation <- eml$additionalMetadata$metadata$gbif$citation$citation
  pattern <- "\\(\\d{4}\\)"
  year <- stringr::str_extract(citation, pattern) %>%
    stringr::str_remove_all("\\(|\\)")

  # Extract first author
  first_author <- stringr::str_split_1(citation, ",")[1]

  # Write new paragraph
  new_paragraph <- paste0("<p>Data have been standardized to Darwin Core using the <a href=\"https://inbo.github.io/etn/\">etn</a> package and are downsampled to the first detection per hour. The original data are managed in the European Tracking Network data platform (<a href=\"https://lifewatch.be/etn/\">https://lifewatch.be/etn/</a>) and are available in ", first_author, " et al. (", year, ", <a href=\"", identifier, "\">", identifier, "</a>).</p>")

  # Update last paragraph
  paragraphs[length(paragraphs)] <- new_paragraph

  # Add collapsed paragraphs to EML
  eml$dataset$abstract$para <- paste0(paragraphs, collapse = "")

  # Delete `additionalInfo`
  eml$dataset$additionalInfo <- NULL

  # Return object or write files
  if (is.null(directory)) {
    list(
      eml = eml
    )
  } else {
    eml_path <- file.path(directory, "eml.xml")
    message(glue::glue(
      "Writing data to:",
      eml_path,
      .sep = "\n"
    ))
    if (!dir.exists(directory)) {
      dir.create(directory, recursive = TRUE)
    }
    EML::write_eml(eml, eml_path, na = "")
  }
}
