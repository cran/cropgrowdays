% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/growing_degree_days.R
\name{growing_degree_days}
\alias{growing_degree_days}
\title{Degree days as the sum of capped average daily temperature above a baseline value}
\usage{
growing_degree_days(
  data,
  varmax = NULL,
  varmin = NULL,
  datevar = NULL,
  maxt_cap = 30,
  base_temp = 5,
  na.rm = FALSE,
  ndays = 5,
  startdate = NULL,
  enddate = NULL,
  monitor = FALSE,
  warn.consecutive = TRUE
)
}
\arguments{
\item{data}{Tibble or dataframe of daily weather data}

\item{varmax}{Name of variable containing max temp (default
'maxt')}

\item{varmin}{Name of variable containing min temp (default
'mint')}

\item{datevar}{Date variable specifying day (Default: date_met)}

\item{maxt_cap}{A numeric value set to the temperature considered
to be the maximum necessary for plant growth. Maximum temperature is
capped at this value for calculating average daily temp (Default: 30)}

\item{base_temp}{A numeric value set to the temperature considered
to be the minimum necessary for plant growth (Default: 5)}

\item{na.rm}{Used for calculations (Default: FALSE)}

\item{ndays}{Number of days after/before the start or end date,
respectively. Ignored of both the start and end dates are
specified (Default: 5)}

\item{startdate}{Start date of data to be extracted}

\item{enddate}{Final date of data to be extracted}

\item{monitor}{For debugging. Prints data and dates. (Default:
FALSE)}

\item{warn.consecutive}{A logical indicating whether to check that
dates are consecutive, that none are missing and provide a warning if
not (Default:TRUE)}
}
\value{
Numeric variable containing the sum of degree days during
the period
}
\description{
Calculate the sum of of degree days (average temperature - base
temperature \code{base_temp} for each day) during specified dates
for a tibble or data frame of daily weather data. Alternatively, a
number of days before or after a specific date may be
specified. Note that the maximum temperature is capped at
\code{maxt_cap} when calculating the average temperature.
}
\details{
The value returned is the sum of of degree days \eqn{GDD = \sum_i
(Tmax_i + Tmin_i) / 2 - Tbase} during specified dates for a tibble
or data frame of daily weather data. The maximum temperature Tmax
is capped at \code{maxt_cap} degrees when calculating average temp
(see \url{https://farmwest.com/climate/calculator-information/gdd/} or
McMaster, GS, & Wilhelm, WW (1997)). Baskerville, G &
Emin, P (1969) provide variations on this method.

The sum of degree days is returned but if there are any missing
values, then the value returned will be \code{NA} since the
default \code{na.rm} is \code{TRUE}. Note that if there are any
missing dates, then a warning is issued but the sum of non-missing
values is returned.

If any values are missing, while the sum of degree days may prove
useful, it will not include all the data and so will lead to
biased underestimates. Hence, in these cases it is unlikely that
the value returned is a good estimate but the appropriateness of
the estimate will depend on the exact circumstances of the missing
data and so this decision is left to the user.
}
\examples{
## Selected calculations
## library(tidyverse)  # only purrr used here for crop2 example
library(dplyr)
library(purrr)
growing_degree_days(boonah, enddate = crop$flower_date[4], ndays = 3,
                    varmax = maxt, varmin = mint,
                    monitor = TRUE)
growing_degree_days(boonah, enddate = crop$harvest_date[4], ndays = 3,
                    varmax = maxt, varmin = mint,
                    monitor = TRUE)
growing_degree_days(boonah, startdate = crop$flower_date[4],
                    varmax = maxt, varmin = mint,
                    enddate = crop$harvest_date[4], monitor = TRUE)

## Add selected growing degree days at 'boonah' to 'crop' tibble
## using 'map2_dbl' from the 'purrr' package
## Note: using equivalent 'furrr' functions can speed up calculations 
crop2 <- crop |>
  mutate(gddays8_post_sow_7d =
          purrr::map_dbl(sowing_date, function(x)
            growing_degree_days(boonah, startdate = x, ndays = 7,
                                base_temp = 8)),
          gddays_flower_harvest =
            purrr::map2_dbl(flower_date, harvest_date, function(x, y)
              growing_degree_days(boonah, startdate = x, enddate = y)))
crop2

}
\references{
\itemize{
\item Baskerville, G., & Emin, P. (1969). Rapid Estimation
of Heat Accumulation from Maximum and Minimum
Temperatures. Ecology, 50(3), 514-517. \doi{10.2307/1933912}
\item McMaster, G. S., & Wilhelm, W. W. (1997). Growing degree-days:
One equation, two interpretations. Agricultural and Forest
Meteorology, 87(4), 291–300. \doi{10.1016/S0168-1923(97)00027-0}
\item Anon. (2021). GDD. Farmwest. Retrieved June 15, 2021, from
\url{https://farmwest.com/climate/calculator-information/gdd/}
}
}
\seealso{
\code{\link{cumulative}}, \code{\link{daily_mean}},
\code{\link{stress_days_over}}, and
\code{\link{weather_extract}}
}
