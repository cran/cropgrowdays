## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#:"
)

## ----cran-installation, eval = FALSE------------------------------------------
#  install.packages("cropgrowdays")

## ----gl-installation, eval = FALSE--------------------------------------------
#  ## if you don't have 'remotes' installed, automatically install it
#  if (!require("remotes")) {
#    install.packages("remotes", repos = "http://cran.rstudio.com/")
#    library("remotes")
#  }
#  install_gitlab("petebaker/cropgrowdays", build_vignettes = TRUE)

## ----setup--------------------------------------------------------------------
suppressMessages(library(tidyverse))
suppressMessages(library(lubridate))
library(cropgrowdays)

## ----boonah-data--------------------------------------------------------------
## weather data object
print(boonah, n=5)

## ---- crop-dataframe----------------------------------------------------------
## crop data object
print(crop, n=5)

## ----gdd----------------------------------------------------------------------
## Growing Degree Days between two dates
crop$flower_date[4]     # flowering date for 4th field or farm in 'crop'
crop$harvest_date[4]    # harvest date for 4th field or farm in 'crop'
growing_degree_days(boonah, startdate = crop$flower_date[4],
                         enddate = crop$harvest_date[4]) #, monitor = TRUE)

## ----stress_days--------------------------------------------------------------
## Stress days  between two dates
stress_days_over(boonah, startdate = crop$flower_date[4],
                 enddate = crop$harvest_date[4]) # , monitor = TRUE)

## ----cumulative---------------------------------------------------------------
## cumulative rainfall between two dates (flowering and harvest)
cumulative(boonah, var = rain, startdate = crop$flower_date[4],
           enddate = crop$harvest_date[4])

## ----daily_mean---------------------------------------------------------------
## daily mean radiation for the three days ending on crop$flower_date[4]
crop$flower_date[4] # a particular flowering date
daily_mean(boonah, enddate = crop$flower_date[4], ndays = 3,
           monitor = TRUE)

## ----weather1-----------------------------------------------------------------
## Extract daily rainfall & maximum temperature data using %>% pipe operator
boonah %>%
  weather_extract(c(rain, maxt), date = date_met, startdate = ymd("2019-08-16"),
                  enddate = ymd("2019-08-21"))

## ---- add2crop-gdd------------------------------------------------------------
## Growing degree and stress days
crop2 <- crop %>%
  mutate(gddays_post_sow_7d =
           map_dbl(sowing_date, function(x)
             growing_degree_days(boonah, startdate = x, ndays = 7)),
         stressdays_flower_harvest =
           map2_dbl(flower_date, harvest_date, function(x, y)
             stress_days_over(boonah, startdate = x, enddate = y)))
print(crop2, n=5)

## ---- add2crop-totrain--------------------------------------------------------
## Totals and daily means
crop3 <- crop %>%
  mutate(totalrain_post_sow_7d =
           map_dbl(sowing_date, function(x)
             cumulative(boonah, var = rain, startdate = x, ndays = 7)),
         meanrad_flower_harvest =
           map2_dbl(flower_date, harvest_date, function(x, y)
             daily_mean(boonah, var = radn, startdate = x, enddate = y)))
print(crop3, n=5)

## ---- eval=FALSE, add2crop-totrain-furrr--------------------------------------
#  ptm <- proc.time() # Start the clock!
#  ## set number of 'furrr' workers
#  library(furrr)
#  plan(multisession, workers = 2)
#  ## Totals and daily means
#  crop3 <- crop %>%
#    mutate(totalrain_post_sow_7d =
#             future_map_dbl(sowing_date, function(x)
#               cumulative(boonah, var = rain, startdate = x, ndays = 7)),
#           meanrad_flower_harvest =
#             future_map2_dbl(flower_date, harvest_date, function(x, y)
#               daily_mean(boonah, var = radn, startdate = x, enddate = y)))
#  print(crop3, n=5)
#  proc.time() - ptm # Stop the clock!

## ---- day-of-year-------------------------------------------------------------
##  Day of Calendar Year
day_of_year(ymd(c("2020-12-31", "2020-07-01", "2020-01-01")))
day_of_year(ymd(c("2020-12-31", "2020-07-01", "2020-01-01")), return_year = TRUE)

## Day of Financial Year
day_of_year(ymd(c("2020-12-31", "2020-07-01", "2020-01-01")), type = "financial")
day_of_year(ymd(c("2020-12-31", "2020-07-01", "2020-01-01")), type = "fin",
            return_year = TRUE)

## ---- date-from-day-----------------------------------------------------------
## Convert day of year to a date
date_from_day_year(21,2021)
date_from_day_year(21,2021, type = "fina")

## ---- day-of-harvest----------------------------------------------------------
## Day of harvest using the first day of the year of sowing as the base day
day_of_year(ymd("2021-01-05"))
day_of_harvest(x = ymd("2021-01-05"), sowing = ymd("2020-12-20"))  # > 366

