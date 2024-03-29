% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/day_of_year.R
\name{date_from_day_year}
\alias{date_from_day_year}
\title{Calculate a date from the day of the year and the year}
\usage{
date_from_day_year(
  day,
  year,
  type = c("calendar", "financial", "other"),
  base = NULL
)
}
\arguments{
\item{day}{Day as an \code{numeric} (integer) used for calculation
the date}

\item{year}{Year as an \code{integer} (integer) used for
calculation the date}

\item{type}{A character string specifying the type of
year. \dQuote{calendar} is a calendar year starting on 1
January, \dQuote{financial} an Australian financial year
beginning on 1 July and \dQuote{other} is for a year starting on
another date which is specified in \code{base}. Default:
\dQuote{calendar}}

\item{base}{A \code{list} specifying the day and month of the
first day to be used in calculations. The name of the day
component must be named either \dQuote{day} or \dQuote{d}, and
the month must be named either \dQuote{month} or \dQuote{m}.}
}
\value{
A date of class \code{\link{Date}} calculated from
the day of the year and the year
}
\description{
\code{date_from_day_of_year} returns the date using the day of the
year and a year for a calendar or financial year. The first day of
the year is 1 January for the calendar year, 1 July for the
Australian financial year or can be specified. Alternatively, the
first day of the year can be any day of the year if desired.
}
\examples{
library(lubridate)
date_from_day_year(day = 366, year = 2020)
date_from_day_year(21,2021)
date_from_day_year(day = c(21, 24, 30), year = rep(2021, 3))
date_from_day_year(21,2021, type = "financial")
date_from_day_year(21,2021, type = "other", base = list(d=1, m=9))
}
