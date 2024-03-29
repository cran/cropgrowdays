% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/two_sites.R
\docType{data}
\name{two_sites}
\alias{two_sites}
\title{SILO weather data extracted for two arbitrary sites}
\format{
A data frame with 10 rows and 11 variables:
\describe{
\item{year}{Year}
\item{day}{Day}
\item{radn}{Radiation (MJ/m^2)}
\item{maxt}{Max Temperature (degrees C)}
\item{mint}{Min Temperature (degrees C)}
\item{rain}{Rainfall (mm)}
\item{evap}{Evaporation (mm)}
\item{vp}{Vapour Pressure (hPa)}
\item{code}{Source Code is a six digit string describing the
source of the meteorological data where each digit is either 0, an
actual observation; 1, an actual observation from a composite
station; 2, a value interpolated from daily observations; 3, a
value interpolated from daily observations using the anomaly
interpolation method for CLIMARC data; 6, a synthetic pan
value; or 7, an interpolated long term average}
\item{date_met}{The date on which daily weather was collected}
\item{Sitename}{Sites labelled \dQuote{Site_1} and \dQuote{Site_2}}
}
}
\source{
Meteorological SILO data obtained from the Longpaddock Qld
Government web site \url{https://www.longpaddock.qld.gov.au} for
two sites for the period 1 to 5 Nov 2020
}
\usage{
two_sites
}
\description{
A dataset containing daily weather data in APSIM format for
Site_1: at -27 S, 151 E and Site_2: -28 S, 152 E for the period 1
to 5 Nov 2020
}
\details{
The data were obtained with

\code{two_sites  <- get_multi_silodata(latitude = c(-27.00, -28.00),
   longitude = c(151.00, 152.00), Sitename = c("Site_1", "Site_2"),
   START = "20201101", FINISH = "20201105", email = "MY_EMAIL_ADDRESS")}

where \dQuote{MY_EMAIL_ADDRESS} was relaced with an appropriate
address.
}
\keyword{datasets}
