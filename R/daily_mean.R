##' Mean of daily weather variable values between two dates
##'
##' Calculates the average of daily values of the variable between two
##' dates from a tibble or data frame of daily weather
##' data. Alternatively, a number of days before or after a specific
##' date may be specified. Typically this would be used for
##' temperature, rainfall or solar radiation.
##'
##' The mean is returned but if there are any missing values, then the
##' mean is set to \code{NA} since the default \code{na.rm} is
##' \code{TRUE}. Note that if there are any missing dates, then a
##' warning is issued but the mean of non-missing values is returned.
##'
##' If any values are missing, while the calculated mean may prove
##' useful, it will not include all the data and so may lead to biased
##' estimates. Hence, in these cases, the appropriateness of the
##' estimate will depend on the exact circumstances of the missing
##' data and so this decision is left to the user.
##'
##' @param na.rm Used for calculations (Default: FALSE)
##' @param ... options to be passed to \code{mean} calculation
##' @inheritParams weather_extract
##' 
##' @return Numeric variable containing the daily mean of the weather
##'   variable \code{var} during the specified period.
##' 
##' @examples
##' ##  Selected calculations
##' library(tidyverse)
##' daily_mean(boonah, enddate = crop$flower_date[4], ndays = 3,
##'                     monitor = TRUE)
##' daily_mean(boonah, enddate = crop$harvest_date[4], ndays = 3,
##'                     monitor = TRUE)
##' daily_mean(boonah, startdate = crop$flower_date[4],
##'                     enddate = crop$harvest_date[4], monitor = TRUE)
##' 
##' ## Add selected daily means of weather variables in 'boonah' to 'crop'
##' ## tibble using 'map2_dbl' from the 'purrr' package
##' ## Note: using equivalent 'furrr' functions can speed up calculations 
##' crop2 <- crop %>%
##'   mutate(mean_maxtemp_post_sow_7d =
##'           map_dbl(sowing_date, function(x)
##'             daily_mean(boonah, var = maxt, startdate = x, ndays = 7)),
##'           mean_rad_flower_harvest =
##'             map2_dbl(flower_date, harvest_date, function(x, y)
##'               daily_mean(boonah, var = radn, startdate = x, enddate = y)))
##' crop2
##'
##' @seealso \code{\link{mean}}, \code{\link{cumulative}},
##'   \code{\link{growing_degree_days}},
##'   \code{\link{stress_days_over}}, and
##'   \code{\link{weather_extract}}
##' @export
daily_mean <- function(data, var = NULL, datevar = NULL, ndays = 5,
                             na.rm = FALSE, 
                             startdate = NULL, enddate = NULL,
                             monitor = FALSE, warn.consecutive = TRUE, ...)
{

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
                    warn.consecutive = TRUE)
  } else {
  tmp_data <- data %>%
    weather_extract(var = all_of(var_n), datevar = {{datevar}}, ndays = ndays,
                    enddate = enddate, startdate = startdate,
                    return.dates = FALSE, monitor = monitor,
                    warn.consecutive = warn.consecutive)    
  }

  ## return the daily mean of 'var' in the period
  return(mean(tmp_data[[1]], na.rm = na.rm, ...))
}
