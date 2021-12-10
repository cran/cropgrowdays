##' Sum of a weather variable between between two dates
##'
##' Calculates the sum or total of daily values between two dates from
##' a tibble or data frame of daily weather data. Alternatively, a
##' number of days before or after a specific date may be
##' specified. Typically this is used for solar radiation, evaporation
##' or rainfall since the total rainfall, radiation or evaporation
##' during a specified period may prove useful for modelling yield or
##' plant growth.
##'
##' The sum is returned but if there are any missing values, then the
##' sum is set to \code{NA} since the default \code{na.rm} is
##' \code{TRUE}. Note that if there are any missing dates, then a
##' warning is issued but the sum of non-missing values is returned.
##'
##' If any values are missing, while the calculated sum or total may
##' prove useful, it will not include all the data and so may lead to
##' biased underestimates. Hence, in these cases it may be unlikely
##' that the sum is a good estimate but the appropriateness of the
##' estimate will depend on the exact circumstances of the missing
##' data and so this decision is left to the user.
##'
##' @param na.rm Used for calculations (Default: FALSE)
##' @param ... options to be passed to \code{sum} calculation
##' @inheritParams weather_extract
##' 
##' @return Numeric variable containing the sum of all values of the
##'   weather variable \code{var} during the specified period.
##' 
##' @examples
##' ## Selected calculations
##' library(tidyverse)
##' cumulative(boonah, enddate = crop$flower_date[4], ndays = 3,
##'                     monitor = TRUE)
##' cumulative(boonah, enddate = crop$harvest_date[4], ndays = 3,
##'                     monitor = TRUE)
##' cumulative(boonah, startdate = crop$flower_date[4],
##'                     enddate = crop$harvest_date[4], monitor = TRUE)
##' cumulative(boonah, startdate = crop$flower_date[4],
##'                     enddate = crop$harvest_date[4])
##' cumulative(boonah, var = rain, startdate = crop$flower_date[4],
##'                     enddate = crop$harvest_date[4])
##' 
##' ## Add selected totals of weather variables in 'boonah' to 'crop'' tibble
##' ## using 'map2_dbl' from the 'purrr' package
##' ## Note: using equivalent 'furrr' functions can speed up calculations 
##' crop2 <- crop %>%
##'   mutate(totalrain_post_sow_7d =
##'           map_dbl(sowing_date, function(x)
##'             cumulative(boonah, var = rain, startdate = x, ndays = 7)),
##'           totalrad_flower_harvest =
##'             map2_dbl(flower_date, harvest_date, function(x, y)
##'               cumulative(boonah, var = radn, startdate = x, enddate = y)))
##' crop2
##' @seealso \code{\link{sum}}, \code{\link{daily_mean}},
##'   \code{\link{growing_degree_days}},
##'   \code{\link{stress_days_over}}, and
##'   \code{\link{weather_extract}}
##' @export
cumulative <- function(data, var = NULL, datevar = NULL, ndays = 5,
                             na.rm = FALSE, 
                             startdate = NULL, enddate = NULL,
                             monitor = FALSE, warn.consecutive = TRUE, ...)
{
  ## there may be a better way but this seems to work
  ## basically using column numbers to access data - I think
  ## the newer versions of tidyeval would help but not sure

  ## if variable name specified then convert to a string
  var_name <- deparse(substitute(var))
  var_name <- gsub('\\"','', var_name)  # remove quotes if string originally
  var_name <- gsub("\\''","", var_name) # remove quotes if string originally
  ## set as NULL or set as NULL

  ## will return 'radn' if variable is named NULL but OK otherwise
  if (var_name != "NULL")
  {
    if (var_name %in% names(data))
      var_n <- c(1:dim(data)[2])[names(data) == var_name]
    else
      stop(paste0("Error: Variable ',", var_name, "' not found in data"))
  }
  
  if (var_name == "NULL" | missing(var))
  {
    if ("radn" %in% names(data))
    {
      var_n <- c(1:dim(data)[2])[names(data) == "radn"]
    } else {
      stop("Error: Default variable 'radn' not found in data")
    }
  }

  if (is.null(datevar))
  {
  tmp_data <- data %>%
    weather_extract(var = all_of(var_n), datevar = NULL, ndays = ndays,
                    enddate = enddate, startdate = startdate,
                    return.dates = FALSE, monitor = monitor,
                    warn.consecutive = warn.consecutive)
  } else {
  tmp_data <- data %>%
    weather_extract(var = all_of(var_n), datevar = {{datevar}}, ndays = ndays,
                    enddate = enddate, startdate = startdate,
                    return.dates = FALSE, monitor = monitor,
                    warn.consecutive = warn.consecutive)    
  }
  ## return the no. of days above the base temperature in period
  return(sum(tmp_data, na.rm = na.rm, ...))
}
