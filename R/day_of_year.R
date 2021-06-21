##' Calculate day of year from a date
##'
##' \code{day_of_year} returns the day of the year as an integer. The
##' first day of the year is 1 January for the calendar year, 1 June
##' for the Australian financial year or can be specified as any day
##' of the year if desired.
##'
##' @param x A \code{date} used for calculation the day of the year.
##' @param type A character string specifying the type of
##'   year. \dQuote{calendar} is a calendar year starting on 1
##'   January, \dQuote{financial} an Australian financial year
##'   beginning on 1 June and \dQuote{other} is for a year starting on
##'   another date which is specified in \code{base}. Default:
##'   \dQuote{calendar}
##' @param return_year A logical indicating whether to return the year
##'   or not. Default: FALSE
##' @param base A \code{list} specifying the day and month of the
##'   first day to be used in calculations. The name of the day
##'   component must be named either \dQuote{day} or \dQuote{d}, and
##'   the month must be named either \dQuote{month} or \dQuote{m}.
##'
##' @return A numeric vector containing day of the year. If
##'   \code{return_year} is TRUE then a \code{\link{data.frame}} is
##'   returned containing two columns \code{day} and \code{year}. The
##'   first column \code{day} is always numeric but the class of the
##'   \code{year} column depends on \code{type}. For \code{type}
##'   \dQuote{calendar}, \dQuote{financial}, \dQuote{other} then
##'   \code{year} is numeric, character and the base date as a
##'   \code{\link{Date}}, respectively.
##'
##' @examples
##' library(lubridate)
##' ## Day of Calendar Year
##' day_of_year(ymd("2020-01-05"))
##' day_of_year(ymd("2021-01-05"))
##' day_of_year(ymd(c("2020-06-05"), "2021-06-05")) # 29 Feb in 2020 only
##' day_of_year(ymd("2020-12-31"))
##' day_of_year(ymd("2021-12-31"))
##' day_of_year(ymd("2020-12-31"), return_year = TRUE)
##' day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01")))
##' day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01")),
##'             return_year = TRUE)
##'
##' ## Day of Financial Year
##' day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01")),
##'             type = "financial")
##' day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01")),
##'             type = "financial", return_year = TRUE)
##'
##' ## Specify the year starts on 1 September
##' day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01")),
##'             type = "other", base = list(d = 1, m = 9))
##' day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01")),
##'             type = "other", base = list(d = 1, m = 9), return_year = TRUE)
##' 
##' @seealso \code{\link{date_from_day_year}} for converting day of
##'   year and year to a \code{\link{Date}} and
##'   \code{\link{day_of_harvest}} for calculating the day of harvest
##'   given a sowing date where the start of the year is the first day
##'   of the year which contains the sowing date
##' @export
day_of_year <- function(x, type = c("calendar", "financial", "other"),
                        return_year = FALSE, base = NULL)
{
  if(class(x) != "Date") stop("Error: 'x' must be of class Date")
  type <- match.arg(type)

  year_x <- lubridate::year(x)  
  if (type == "calendar") day_one <- lubridate::ymd(paste0(year_x, "-01-01"))
  if (type == "financial")
  {
    day_one <- lubridate::ymd(paste0(year_x, "-06-01"))
    year_x <- year_x - (x <  day_one)  # previous year if before 1 June
    day_one <- lubridate::ymd(paste0(year_x, "-06-01"))
  }
  if (type == "other")
  {
    if (!is.list(base))
      stop("Error: base must be a list containing day and month")
    if ("day" %in% names(base)) { base_day <- base[["day"]]
    } else {
      if ("d" %in% names(base)) {base_day <- base[["d"]]
      } else {
        stop("Error: day for first day must be provided in list 'base'")
      }
    }
    if ("month" %in% names(base)) { base_month <- base[["month"]]
    } else {
      if ("m" %in% names(base)) { base_month <- base[["m"]]
      } else {
        stop("Error: month for first day must be provided in list 'base'")
      }
    }
    day_one <- lubridate::ymd(paste0(year_x, "-", base_month, "-", base_day))
    year_x <- year_x - (x <  day_one)  # previous year if before base day
    day_one <- lubridate::ymd(paste0(year_x, "-", base_month, "-", base_day))
  }
  
  day_of_year <- as.numeric(x - day_one) + 1
  if (return_year)
  {
    if (type == "financial")
      return(data.frame(day = day_of_year,
                        fin_year = paste(year_x, year_x+1, sep = "/")))
    if (type == "calendar") return(data.frame(day = day_of_year,
                                              year = year_x))
        
    if (type == "other")
        return(data.frame(day = day_of_year, base = day_one))   
  } else {
    return(day_of_year)
  }
}

##' Calculate a date from the day of the year and the year
##'
##' \code{date_from_day_of_year} returns the date using the day of the
##' year and a year for a calendar or financial year. The first day of
##' the year is 1 January for the calendar year, 1 June for the
##' Australian financial year or can be specified. Alternatively, the
##' first day of the year can be any day of the year if desired.
##'
##' @param day Day as an \code{numeric} (integer) used for calculation
##'   the date
##' @param year Year as an \code{integer} (integer) used for
##'   calculation the date
##' @inheritParams day_of_year
##'
##' @return A date of class \code{\link{Date}} calculated from
##'   the day of the year and the year
##'
##' @examples
##' library(lubridate)
##' date_from_day_year(day = 366, year = 2020)
##' date_from_day_year(21,2021)
##' date_from_day_year(day = c(21, 24, 30), year = rep(2021, 3))
##' date_from_day_year(21,2021, type = "financial")
##' date_from_day_year(21,2021, type = "other", base = list(d=1, m=9))
##' @export
date_from_day_year <- function(day, year,
                               type = c("calendar", "financial", "other"),
                               base = NULL)
{
  ## check that day and year have same length
  if (length(day) != length(year))
    stop("Error: 'day' and 'year' must have the same length")
  ## check day is integer between 1 and 366 and year is valid integer
  if (!all(day %in% 1:366))
    stop("Error: 'day' must be an integer between 1 and 366")
  if (all(ceiling(year) != floor(year)))   # see ?round
    stop("Error: 'year' must be an integer")
  
  ## set up base date(s) and return date
  type <- match.arg(type)
  if (type == "calendar") return(as.Date(day - 1, paste0(year, "-01-01")))
  if (type == "financial") return(as.Date(day - 1, paste0(year, "-06-01")))
  if (type == "other")
  {
    if (!is.list(base))
      stop("Error: base must be a list containing day and month")
    if ("day" %in% names(base)) { base_day <- base[["day"]]
    } else {
      if ("d" %in% names(base)) {base_day <- base[["d"]]
      } else {
        stop("Error: day for first day must be provided in list 'base'")
      }
    }
    if ("month" %in% names(base)) { base_month <- base[["month"]]
    } else {
      if ("m" %in% names(base)) { base_month <- base[["m"]]
      } else {
        stop("Error: month for first day must be provided in list 'base'")
      }
    }
    return(as.Date(day - 1, paste0(year, "-", base_month, "-", base_day)))
  }
}

##' The day of harvest in the year of sowing
##'
##' \code{day_of_harvest} calculates day of year if harvest goes past
##' end of year (or not). For instance, if the sowing date is at the
##' end of the year, then the harvest date early in the next year (as
##' a day of year) will be be smaller than the sowing date (as a day
##' of the year). This function rectifies this situation by
##' calculating the harvest date as the day of year in the previous
##' year and so would be greater than 366 in this instance. Of course,
##' this is not necessary if the sowing and harvest dates are in the
##' same year.
##'
##' @param x A harvest \code{\link{Date}} used for calculation of the day of the year.
##' @param sowing A sowing \code{\link{Date}} used for calculation.
##' @inheritParams day_of_year
##' 
##' @return An \code{numeric} vector containing the day of harvest in
##'   the year of sowing which will differ from the day of harvest if
##'   the sowing date is in the previous year
##' 
##' @examples
##' library(lubridate)
##' day_of_harvest(x = ymd("2020-06-15"), sowing = ymd("2020-06-01"))
##' day_of_harvest(x = ymd("2021-06-15"), sowing = ymd("2021-06-01"))
##' day_of_harvest(x = ymd("2021-06-15"), sowing = ymd("2020-06-01"))
##' day_of_harvest(x = ymd("2021-02-05"), sowing = ymd("2021-01-28"))
##' day_of_harvest(x = ymd("2021-02-05"), sowing = ymd("2021-01-28"),
##'                type = "financial")
##' day_of_harvest(x = ymd("2021-02-05"), sowing = ymd("2021-01-28"),
##'                type = "other", base = list(m = 9, day = 1))
##' @export
day_of_harvest <- function(x, sowing,
                           type = c("calendar", "financial", "other"),
                           base = NULL)
{
  ## simple checks  
  if (class(x) != "Date") stop("Error: 'x' must be of class Date")
  if (class(sowing) != "Date") stop("Error: 'sowing' must be of class Date")
  if (x < sowing) stop("Error: 'x' must be later than 'sowing'")
  ## set up base date(s) and return date
  type <- match.arg(type)
  year_sowing <- lubridate::year(sowing)
  day_x <- day_of_year(x, type = type, base = base)

  ## add no. days in year if past end of year else return day of year
  ## NB: could rewrite as switch - much cleaner
  if (type == "calendar")
  {
    first_day_of_year <- as.Date(paste0(year_sowing, "-01-01"))
    first_day_next_year <- as.Date(paste0(year_sowing + 1, "-01-01"))
  }
  if (type == "financial")
  {
    first_day_of_year <- as.Date(paste0(year_sowing, "-06-01"))
    first_day_next_year <- as.Date(paste0(year_sowing + 1, "-06-01"))
  }
  if (type == "other")
  {
    if (!is.list(base))
      stop("Error: base must be a list containing day and month")
    if ("day" %in% names(base)) { base_day <- base[["day"]]
    } else {
      if ("d" %in% names(base)) {base_day <- base[["d"]]
      } else {
        stop("Error: day for first day must be provided in list 'base'")
      }
    }
    if ("month" %in% names(base)) { base_month <- base[["month"]]
    } else {
      if ("m" %in% names(base)) { base_month <- base[["m"]]
      } else {
        stop("Error: month for first day must be provided in list 'base'")
      }
    }
    first_day_of_year <-
      as.Date(paste0(year_sowing,  "-", base_month, "-", base_day))
    first_day_next_year <-
      as.Date(paste0(year_sowing + 1, "-", base_month, "-", base_day))
  }

  if (x >= first_day_next_year)
  {
    calc_day <- day_x + as.numeric(first_day_next_year - first_day_of_year)
  } else {
    calc_day <- day_x
  }
  calc_day
}

##' The number of days between two dates
##'
##' A convenience function which is simply \code{as.numeric(end_date -
##' start_date)}
##'
##' @param x The end date with class \code{\link{Date}}
##' @param start The start date with class \code{\link{Date}}
##'
##' @return A \code{\link[base]{numeric}} variable containing the number
##'   of days between the two dates
##' 
##' @examples
##' library(lubridate)
##' number_of_days(x = ymd("2021-01-05"), start = ymd("2020-12-28"))
##' @export
number_of_days <- function(x, start)
{
  ## simple checks  
  if (class(x) != "Date") stop("Error: 'x' must be of class Date")
  if (class(start) != "Date") stop("Error: 'start' must be of class Date")

  ## perhaps also need to check that not a date time class - not sure
  as.numeric(x - start)
}
