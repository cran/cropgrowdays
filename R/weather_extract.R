##' Extract one or more columns of weather data between two dates
##'
##' Extract column(s) from a tibble/data frame of daily weather data
##' between two specified dates. Either specify the start and end
##' dates or specify one of these dates and also the number of days
##' after or before, respectively.
##'
##' @param data Tibble or dataframe of daily weather data
##' @param var Variable(s) to be extracted (Default: radn). Several columns
##' may be specified using column names \code{c(variable1, variable2, ...)}
##' @param datevar Date variable specifying day (Default: date_met)
##' @param ndays Number of days after/before the start or end date,
##'   respectively. Ignored of both the start and end dates are
##'   specified (Default: 5)
##' @param startdate Start date of data to be extracted
##' @param enddate Final date of data to be extracted
##' @param monitor For debugging. Prints data and dates. (Default:
##'   FALSE)
##' @param return.dates A logical indicating whether to return the date
##'   column (Default: TRUE)
##' @param warn.consecutive A logical indicating whether to check that
##'   dates are consecutive, that none are missing and provide a warning if
##'   not (Default:TRUE)
##' 
##' @return A tibble (data frame) of extracted weather data
##'
##' @examples
##' library(tidyverse)
##' library(lubridate)
##' boonah %>%
##' weather_extract(rain, date = date_met, startdate = ymd("2019-08-16"),
##'                   enddate = ymd("2019-08-21"))
##' boonah %>%
##'   weather_extract(rain, startdate = ymd("2019-08-16"),
##'                   enddate = ymd("2019-08-21"))
##' boonah %>%
##'   weather_extract(maxt, date = date_met, startdate = ymd("2019-08-16"),
##'                   ndays = 3, return.dates = FALSE)
##' boonah %>%
##'   weather_extract(mint, enddate = ymd("2019-08-16"), ndays = 1)
##' ## extract multiple columns
##' boonah %>%
##'   weather_extract(c(year, day, mint, maxt), enddate = ymd("2019-08-16"),
##'                   ndays = 3)
##'
##' @seealso \code{\link[dplyr]{between}} \code{\link[dplyr]{filter}},
##'   \code{\link{cumulative}}, \code{\link{daily_mean}},
##'   \code{\link{growing_degree_days}}, and \code{\link{stress_days_over}}
##' @export
weather_extract <- function(data, var, datevar = NULL, ndays = 5,
                            startdate = NULL, enddate = NULL, monitor = FALSE,
                            return.dates = TRUE, warn.consecutive = TRUE)
{
  ## check start/end dates and compute values if necessary -----------
  if (is.null(startdate) & is.null(enddate))
    stop("Error: At least one of 'startdate' and 'enddate' must be specified")
  if (is.null(startdate) & !is.null(enddate)){
    end_date <- enddate[1]
    start_date <- (enddate - ndays + 1)[1]
  }
  if (!is.null(startdate) & is.null(enddate)){
    start_date <- startdate[1]
    end_date <- (start_date + ndays -1)[1]
  }
  if (!is.null(startdate) & !is.null(enddate)){
    start_date <- startdate[1]
    end_date <- enddate[1]
  }
  ## this will be clear from 'date_met'
  ## if (monitor) {cat("Start and end dates:\n"); print(c(start_date, end_date))}

  ## process 'datevar' and set default if necessary --------------------
  ## if variable name specified then convert to a string
  date_name <- deparse(substitute(datevar))
  date_name <- gsub('\\"','', date_name)  # remove quotes if string originally
  date_name <- gsub("\\''","", date_name) # remove quotes if string originally

  ## will return 'date_met' if variable is named NULL but OK otherwise
  if (date_name != "NULL")
  {
    if (date_name %in% names(data))
      var_date <- c(1:dim(data)[2])[names(data) == date_name]
    else
      stop(paste0("Error: Variable ',", date_name, "' not found in data"))
  }
  
  if (date_name == "NULL" | missing(datevar))
  {
    if ("date_met" %in% names(data))
    {
      var_date <- c(1:dim(data)[2])[names(data) == "date_met"]
    } else {
      stop("Error: Default variable 'date_met' not found in data")
    }
  }

  ## dates in selected data ---------------------------------------------
  data_dates  <-
    data %>%  dplyr::filter(dplyr::between(dplyr::select(data, all_of(var_date))[[1]],
                                           start_date[1], end_date[1])) %>%
      dplyr::select(all_of(var_date))

  if (warn.consecutive & !identical(sort(data_dates[[1]]),
                                    as_date(c(start_date:end_date))))
    warning("Warning: Not all dates are present between ", as.character(start_date),
        " and ", as.character(end_date),
        "\n            Calculations may result in incorrect values!\n")
  
  ## extract data -----------------------------------------------------
    ##data %>%  dplyr::filter(select(data, var_date)[[1]] >= start_date[1] &
    ##                        select(data, var_date)[[1]] <= end_date[1]) %>%
  ext_data <- 
    data %>%  dplyr::filter(dplyr::between(dplyr::select(data, all_of(var_date))[[1]],
                                            start_date[1], end_date[1])) %>%
    dplyr::select({{ var }}) # note that var may be one or more columns
  
  if (monitor)
  {
    ## print(cbind(data_dates, ext_data))
    print(bind_cols(data_dates, ext_data))
  }

  if (return.dates)  #     return with or without dates
  {
    bind_cols(data_dates, ext_data)
  } else {
    ext_data
  }
    
}
