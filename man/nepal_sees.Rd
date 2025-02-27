% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nepal_sees.R
\docType{data}
\name{nepal_sees}
\alias{nepal_sees}
\title{SEES Typhoid data}
\format{
\subsection{\code{nepal_sees}}{

A \code{\link[base:data.frame]{base::data.frame()}} with 904 rows and 8 columns:
\describe{
\item{Country}{Country name}
\item{person_id}{ID identifying a study participant}
\item{sample_id}{ID identifying sample taken}
\item{bldculres}{Pathogen participant tested positive for; Typhoid or
paratyphoid}
\item{antigen_iso}{The antigen/antibody combination included in the assay}
\item{studyvisit}{Categorical estimated time frame for when sample was
taken; 28 days, 3_months, 6_months, 12_months, baseline, or 18_months}
\item{dayssincefeveronset}{Continuous measurement showing how exact days
since symptom onset}
\item{result}{Continuous variable describing ELISA result}
}
}
}
\source{
reference study: \url{https://doi.org/10.1016/S2666-5247(22)00114-8}
}
\usage{
nepal_sees
}
\description{
A subset of data from the SEES project highlighting Typhoid longitudinal
data from Nepal.
}
\keyword{datasets}
