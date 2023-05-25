##' Degree days as the sum of capped average daily temperature above a baseline value
##'
##' Calculate the sum of of degree days (average temperature - base
##' temperature \code{base_temp} for each day) during specified dates
##' for a tibble or data frame of daily weather data. Alternatively, a
##' number of days before or after a specific date may be
##' specified. Note that the maximum temperature is capped at
##' \code{maxt_cap} when calculating the average temperature.
##'
##' The value returned is the sum of of degree days \eqn{GDD = \sum_i
##' (Tmax_i + Tmin_i) / 2 - Tbase} during specified dates for a tibble
##' or data frame of daily weather data. The maximum temperature Tmax
##' is capped at \code{maxt_cap} degrees when calculating average temp
##' (see <https://farmwest.com/climate/calculator-information/gdd/> or
##' McMaster, GS, & Wilhelm, WW (1997)). Baskerville, G &
##' Emin, P (1969) provide variations on this method.
##'
##' The sum of degree days is returned but if there are any missing
##' values, then the value returned will be \code{NA} since the
##' default \code{na.rm} is \code{TRUE}. Note that if there are any
##' missing dates, then a warning is issued but the sum of non-missing
##' values is returned.
##'
##' If any values are missing, while the sum of degree days may prove
##' useful, it will not include all the data and so will lead to
##' biased underestimates. Hence, in these cases it is unlikely that
##' the value returned is a good estimate but the appropriateness of
##' the estimate will depend on the exact circumstances of the missing
##' data and so this decision is left to the user.
##'
##' @param varmax Name of variable containing max temp (default
##'   'maxt')
##' @param varmin Name of variable containing min temp (default
##'   'mint')
##' @param maxt_cap A numeric value set to the temperature considered
##'   to be the maximum necessary for plant growth. Maximum temperature is
##'  capped at this value for calculating average daily temp (Default: 30)
##' @param base_temp A numeric value set to the temperature considered
##'   to be the minimum necessary for plant growth (Default: 5)
##' @param na.rm Used for calculations (Default: FALSE)
##' @inheritParams weather_extract
##' 
##' @return Numeric variable containing the sum of degree days during
##'   the period
##'
##' @references
##' - Baskerville, G., & Emin, P. (1969). Rapid Estimation
##'   of Heat Accumulation from Maximum and Minimum
##'   Temperatures. Ecology, 50(3), 514-517. \doi{10.2307/1933912}
##' - McMaster, G. S., & Wilhelm, W. W. (1997). Growing degree-days:
##'   One equation, two interpretations. Agricultural and Forest
##'   Meteorology, 87(4), 291–300. \doi{10.1016/S0168-1923(97)00027-0}
##' - Anon. (2021). GDD. Farmwest. Retrieved June 15, 2021, from
##'   <https://farmwest.com/climate/calculator-information/gdd/>
##' 
##' @examples
##' ## Selected calculations
##' ## library(tidyverse)  # only purrr used here for crop2 example
##' library(dplyr)
##' library(purrr)
##' growing_degree_days(boonah, enddate = crop$flower_date[4], ndays = 3,
##'                     varmax = maxt, varmin = mint,
##'                     monitor = TRUE)
##' growing_degree_days(boonah, enddate = crop$harvest_date[4], ndays = 3,
##'                     varmax = maxt, varmin = mint,
##'                     monitor = TRUE)
##' growing_degree_days(boonah, startdate = crop$flower_date[4],
##'                     varmax = maxt, varmin = mint,
##'                     enddate = crop$harvest_date[4], monitor = TRUE)
##'
##' ## Add selected growing degree days at 'boonah' to 'crop' tibble
##' ## using 'map2_dbl' from the 'purrr' package
##' ## Note: using equivalent 'furrr' functions can speed up calculations 
##' crop2 <- crop |>
##'   mutate(gddays8_post_sow_7d =
##'           purrr::map_dbl(sowing_date, function(x)
##'             growing_degree_days(boonah, startdate = x, ndays = 7,
##'                                 base_temp = 8)),
##'           gddays_flower_harvest =
##'             purrr::map2_dbl(flower_date, harvest_date, function(x, y)
##'               growing_degree_days(boonah, startdate = x, enddate = y)))
##' crop2
##' 
##' @seealso \code{\link{cumulative}}, \code{\link{daily_mean}},
##'   \code{\link{stress_days_over}}, and
##'   \code{\link{weather_extract}}
##' @export
growing_degree_days <- function(data, varmax = NULL, varmin = NULL,
                                datevar = NULL, maxt_cap = 30,
                                base_temp = 5, na.rm = FALSE, ndays = 5, 
                                startdate = NULL, enddate = NULL,
                                monitor = FALSE, warn.consecutive = TRUE)
{
  ## if variable name specified then convert to a string
  varmax_name <- deparse(substitute(varmax))
  varmax_name <- gsub('\\"','', varmax_name)  # remove quotes if present
  varmax_name <- gsub("\\''","", varmax_name) # remove quotes if string
  varmin_name <- deparse(substitute(varmin))
  varmin_name <- gsub('\\"','', varmin_name)  # remove quotes if present
  varmin_name <- gsub("\\''","", varmin_name) # remove quotes if string

  ## varmax will return 'maxt' if variable is named NULL but OK otherwise
  if (varmax_name != "NULL")
  {
    if (varmax_name %in% names(data))
      varmax_n <- c(1:dim(data)[2])[names(data) == varmax_name]
    else
      stop(paste0("Error: Variable ',", varmax_name, "' not found in data"))
  }
  
  if (varmax_name == "NULL" | missing(varmax))
  {
    if ("maxt" %in% names(data))
    {
      varmax_n <- c(1:dim(data)[2])[names(data) == "maxt"]
    } else {
      stop("Error: Default variable 'maxt' not found in data")
    }
  }

  ## varmin will return 'mint' if variable is named NULL but OK otherwise
  if (varmin_name != "NULL")
  {
    if (varmin_name %in% names(data))
      varmin_n <- c(1:dim(data)[2])[names(data) == varmin_name]
    else
      stop(paste0("Error: Variable ',", varmin_name, "' not found in data"))
  }
  
  if (varmin_name == "NULL" | missing(varmin))
  {
    if ("mint" %in% names(data))
    {
      varmin_n <- c(1:dim(data)[2])[names(data) == "mint"]
    } else {
      stop("Error: Default variable 'mint' not found in data")
    }
  }
  ## process depending on whether datevar is set or not
  ## NB: replaced varmax_n and varmin_n with all_of(...) to try and
  ##     counter depreciation problems which may happen with tidyverse
  if (is.null(datevar))
  {
  temp_max <- data |>
    weather_extract(var = all_of(varmax_n), datevar = NULL, ndays = ndays,
                    enddate = enddate, startdate = startdate,
                    monitor = monitor, return.dates = FALSE,
                    warn.consecutive = warn.consecutive)
  temp_min <- data |>
    weather_extract(var = all_of(varmin_n), datevar = NULL, ndays = ndays,
                    enddate = enddate, startdate = startdate,
                    monitor = monitor, return.dates = FALSE,
                    warn.consecutive = warn.consecutive)
  } else {
  temp_max <- data |>
    weather_extract(var = all_of(varmax_n), datevar = {{datevar}},
                    ndays = ndays, enddate = enddate, startdate = startdate,
                    return.dates = FALSE, monitor = monitor,
                    warn.consecutive = warn.consecutive)    
  temp_min <- data |>
    weather_extract(var = all_of(varmin_n), datevar = {{datevar}},
                    ndays = ndays, enddate = enddate, startdate = startdate,
                    return.dates = FALSE, monitor = monitor,
                    warn.consecutive = warn.consecutive)
  }

  ## was simple average but now allows for capping temp (maxt_cap)
  ## temp_av <- (temp_max + temp_min)/2
  temp_av <- (temp_max*(temp_max<maxt_cap) + maxt_cap*(temp_max>=maxt_cap) +
              temp_min)/2
  gddays <-  (temp_av - base_temp) * (temp_av > base_temp)    # min base_tmp
  if (monitor) {x_tmp <- cbind(temp_min, temp_max, temp_av, gddays)
    names(x_tmp) <- c('temp_min', 'temp_max', 'temp_av', 'gddays')
    print(x_tmp)
  }
  ## return the sum of rainfall in period
  ## return(sum(gddays, na.rm = na.rm)) # surely you should make it NA if one missing
  return(sum(gddays)) # surely make it NA if one missing
}
