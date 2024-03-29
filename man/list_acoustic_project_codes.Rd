% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/list_acoustic_project_codes.R
\name{list_acoustic_project_codes}
\alias{list_acoustic_project_codes}
\title{List all available acoustic project codes}
\usage{
list_acoustic_project_codes(connection = con)
}
\arguments{
\item{connection}{A connection to the ETN database. Defaults to \code{con}.}
}
\value{
A vector of all unique \code{project_code} of \code{type = "acoustic"} in
\code{project.sql}.
}
\description{
List all available acoustic project codes
}
