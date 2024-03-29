% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/day_of_year.R
\name{day_of_year}
\alias{day_of_year}
\title{Calculate day of year from a date}
\usage{
day_of_year(
  x,
  type = c("calendar", "financial", "other"),
  return_year = FALSE,
  base = NULL
)
}
\arguments{
\item{x}{A \code{date} used for calculation the day of the year.}

\item{type}{A character string specifying the type of
year. \dQuote{calendar} is a calendar year starting on 1
January, \dQuote{financial} an Australian financial year
beginning on 1 July and \dQuote{other} is for a year starting on
another date which is specified in \code{base}. Default:
\dQuote{calendar}}

\item{return_year}{A logical indicating whether to return the year
or not. Default: FALSE}

\item{base}{A \code{list} specifying the day and month of the
first day to be used in calculations. The name of the day
component must be named either \dQuote{day} or \dQuote{d}, and
the month must be named either \dQuote{month} or \dQuote{m}.}
}
\value{
A numeric vector containing day of the year. If
\code{return_year} is TRUE then a \code{\link{data.frame}} is
returned containing two columns \code{day} and \code{year}. The
first column \code{day} is always numeric but the class of the
\code{year} column depends on \code{type}. For \code{type}
\dQuote{calendar}, \dQuote{financial}, \dQuote{other} then
\code{year} is numeric, character and the base date as a
\code{\link{Date}}, respectively.
}
\description{
\code{day_of_year} returns the day of the year as an integer. The
first day of the year is 1 January for the calendar year, 1 July
for the Australian financial year or can be specified as any day
of the year if desired.
}
\examples{
library(lubridate)
## Day of Calendar Year
day_of_year(ymd("2020-01-05"))
day_of_year(ymd("2021-01-05"))
day_of_year(ymd(c("2020-06-05"), "2021-06-05")) # 29 Feb in 2020 only
day_of_year(ymd("2020-12-31"))
day_of_year(ymd("2021-12-31"))
day_of_year(ymd("2020-12-31"), return_year = TRUE)
day_of_year(ymd(c("2020-12-31", "2020-07-01", "2020-01-01")))
day_of_year(ymd(c("2020-12-31", "2020-07-01", "2020-01-01")),
            return_year = TRUE)

## Day of Financial Year
day_of_year(ymd(c("2020-12-31", "2020-07-01", "2020-01-01")),
            type = "financial")
day_of_year(ymd(c("2020-12-31", "2020-07-01", "2020-01-01")),
            type = "financial", return_year = TRUE)
day_of_year(x = ymd("2021-09-05"), type = "financial") # 67

## Specify the year starts on 1 September
day_of_year(ymd(c("2020-12-31", "2020-07-01", "2020-01-01")),
            type = "other", base = list(d = 1, m = 9))
day_of_year(ymd(c("2020-12-31", "2020-07-01", "2020-01-01")),
            type = "other", base = list(d = 1, m = 9), return_year = TRUE)

}
\seealso{
\code{\link{date_from_day_year}} for converting day of
year and year to a \code{\link{Date}} and
\code{\link{day_of_harvest}} for calculating the day of harvest
given a sowing date where the start of the year is the first day
of the year which contains the sowing date
}
