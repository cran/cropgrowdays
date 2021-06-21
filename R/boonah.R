##' SILO weather data extracted for Boonah SE Queensland
##'
##' A dataset containing daily weather data in APSIM format for Boonah
##' at -27.9927 S, 152.6906 E for the period 1 Jan 2019 to 31 May
##' 2020.
##'
##' These data were obtained using
##'
##' \code{boonah <-
##'      get_silodata(latitude = "-27.9927", longitude = "152.6906",
##'                email = "MY_EMAIL_ADDRESS", START = "20190101", FINISH = "20200531")}
##' 
##' where \dQuote{MY_EMAIL_ADDRESS} was replaced with an appropriate
##' address.
##'
##' @format A data frame with 517 rows and 10 variables:
##' \describe{
##' \item{year}{Year}
##'  \item{day}{Day}
##'  \item{radn}{Radiation (MJ/m^2)}
##'  \item{maxt}{Max Temperature (degrees C)}
##'  \item{mint}{Min Temperature (degrees C)}
##'  \item{rain}{Rainfall (mm)}
##'  \item{evap}{Evaporation (mm)}
##'  \item{vp}{Vapour Pressure (hPa)}
##'  \item{code}{Source Code is a six digit string describing the
##'    source of the meteorological data where each digit is either 0,
##'    an actual observation; 1, an actual observation from a
##'    composite station; 2, a value interpolated from daily
##'    observations; 3, a value interpolated from daily observations
##'    using the anomaly interpolation method for CLIMARC data; 6, a
##'    synthetic pan value; or 7, an interpolated long term average}
##' \item{date_met}{The date on which daily weather was collected}
##' }
##' @source Meteorological SILO data obtained from the Longpaddock Qld Government
##'    web site \url{https://www.longpaddock.qld.gov.au} for Boonah
##'    -27.9927 S, 152.6906 E for the period 1 Jan 2019 to 31 May 2020.
"boonah"
