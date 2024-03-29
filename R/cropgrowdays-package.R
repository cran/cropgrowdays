##' Cropgrowdays: Agrometeorological calculations for crops
##'
##' Weather related calculations for crops are provided for a
##' specified period including growing degree days, cumulative weather
##' variables, the number of stress days over a baseline temperature
##' and mean daily weather. Additionally, a function is provided to
##' download historical Australian weather data from the Queensland
##' Government DES longpaddock website.
##'
##' @section Agrometeorological calculation functions:
##'
##' This package provides the calculation functions
##' \code{\link{cumulative}}, \code{\link{growing_degree_days}},
##' \code{\link{stress_days_over}} and \code{\link{daily_mean}}. These
##' functions employ \code{\link{weather_extract}} which can be used
##' to extract column(s) or variable(s) between two specified dates
##' which can also be employed directly.
##'
##' @section Day of year calculations:
##'
##' Day of year can be calculated from a \code{date} using
##' \code{\link{day_of_year}} and the calculation reversed using
##' \code{\link{date_from_day_year}}. Since a crop may be harvested in
##' a different year than it is sown, then the harvest day of year in
##' which it is sown may be more appropriate and can be obtained with
##' \code{\link{day_of_harvest}}.
##' 
##' @section Downloading SILO data:
##'
##' The function \code{\link{get_silodata}} and is available to
##' retrieve SILO weather data for one location from Queensland
##' Government DES longpaddock website
##' <https://www.longpaddock.qld.gov.au/>. Use
##' \code{\link{get_multi_silodata}} to retrieve multiple locations.
##'
##' @docType package
##' @import lubridate
##' @import dplyr
##' @keywords internal
##' 
"_PACKAGE"

