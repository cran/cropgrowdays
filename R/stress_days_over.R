##' The number of days that maximum temp is over a baseline value
##'
##' Calculate the number of days when the maximum temperature exceeds
##' a base line \code{stress_temp} during specified dates for a tibble
##' or data frame of daily weather data.  Alternatively, a number of
##' days before or after a specific date may be specified. The default
##' value of \code{stress_temp} is 30 degrees C.
##'
##' The number of days is returned but if there are any missing
##' values, then the sum is set to \code{NA} since the default
##' \code{na.rm} is \code{TRUE}. Note that if there are any missing
##' dates, then a warning is issued but the sum of non-missing values
##' is returned.
##'
##' If any values are missing, while the number of days over
##' \code{stress_temp} total may prove useful, it will not include all
##' the data and so may lead to biased underestimates. Hence,
##' depending on the time of year, it may be unlikely that this is a
##' good estimate but the appropriateness of the estimate will depend
##' on the exact circumstances of the missing data and so this
##' decision is left to the user.
##'
##' @param stress_temp A numeric value set to the temperature
##'   considered to be stressful if the maximum temperature exceeds
##'   (Default: 30)
##' @param na.rm Used for calculations (Default: FALSE)
##' @param ... options to be passed to \code{sum} calculation
##' @param var Variable to be extracted (Default: maxt)
##' @inheritParams weather_extract
##'
##' @return Numeric variable containing the number of days where the
##'   maximum temperature was above the specified stress temperature
##'   cutoff
##' @examples
##' ##  Selected calculations
##' library(tidyverse)
##' stress_days_over(boonah, enddate = crop$flower_date[4], ndays = 3,
##'                  monitor = TRUE)
##' stress_days_over(boonah, enddate = crop$harvest_date[4], ndays = 3,
##'                  monitor = TRUE)
##' stress_days_over(boonah, startdate = crop$flower_date[4],
##'                  enddate = crop$harvest_date[4], monitor = TRUE)
##'
##' ## Add selected stress days to crop tibble
##' crop2 <- crop %>%
##'   mutate(stressdays25_post_sow_7d =
##'           map_dbl(sowing_date, function(x)
##'             stress_days_over(boonah, startdate = x, ndays = 7,
##'                              stress_temp = 25)),
##'           stressdays_flower_harvest =
##'             map2_dbl(flower_date, harvest_date, function(x, y)
##'               stress_days_over(boonah, startdate = x, enddate = y)))
##' crop2
##' 
##' @seealso \code{\link{cumulative}}, \code{\link{daily_mean}},
##'   \code{\link{growing_degree_days}}, and
##'   \code{\link{weather_extract}}
##' @export
stress_days_over <- function(data, var = NULL, datevar = NULL, ndays = 5,
                             na.rm = FALSE, stress_temp = 30,
                             startdate = NULL, enddate = NULL,
                             monitor = FALSE, warn.consecutive = TRUE, ...)
{

  ## if variable name specified then convert to a string
  var_name <- deparse(substitute(var))
  var_name <- gsub('\\"','', var_name)  # remove quotes if string originally
  var_name <- gsub("\\''","", var_name) # remove quotes if string originally
  ## set as NULL or set as NULL

  ## will return 'maxt' if variable is named NULL but OK otherwise
  if (var_name != "NULL")
  {
    if (var_name %in% names(data))
      var_n <- c(1:dim(data)[2])[names(data) == var_name]
    else
      stop(paste0("Error: Variable ',", var_name, "' not found in data"))
  }
  
  if (var_name == "NULL" | missing(var))
  {
    if ("maxt" %in% names(data))
    {
      var_n <- c(1:dim(data)[2])[names(data) == "maxt"]
    } else {
      stop("Error: Default variable 'maxt' not found in data")
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
  return(sum(tmp_data > stress_temp, na.rm = na.rm, ...))
}
