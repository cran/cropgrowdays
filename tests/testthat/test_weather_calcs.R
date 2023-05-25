## tests for 'cumulative' -----------------------------------------
expect_equal(cumulative(boonah, enddate = crop$flower_date[4], ndays = 3), 33.5)
expect_equal(cumulative(boonah, enddate = crop$harvest_date[4], ndays = 3), 36.7)
expect_equal(cumulative(boonah, startdate = crop$flower_date[4],
           enddate = crop$harvest_date[4]), 325.1)
expect_equal(cumulative(boonah, var = rain, startdate = crop$flower_date[4],
                    enddate = crop$harvest_date[4]), 22.8)

## Add selected totals to crop tibble
crop2b <- crop |>
  dplyr::mutate(totalrain_post_sow_7d =
          purrr::map_dbl(sowing_date, function(x)
           cumulative(boonah, var = rain, startdate = x, ndays = 7)),
          totalrad_flower_harvest =
           purrr::map2_dbl(flower_date, harvest_date, function(x, y)
            cumulative(boonah, var = radn, startdate = x, enddate = y)))
crop2b_result <- tibble::tibble(sowing_date = ymd(c("2019-08-25",
  "2019-09-20", "2019-12-18", "2020-01-15", "2020-02-15",
  "2020-03-10", "2020-03-20", "2019-10-25", "2019-11-20",
  "2019-11-21")), flower_date = ymd("2019-10-14", "2019-11-09",
  "2020-02-06", "2020-03-06", "2020-04-06", "2020-04-29",
  "2020-05-09", "2019-12-14", "2020-01-09", "2020-01-10"),
  harvest_date = ymd("2019-11-03", "2019-11-29", "2020-02-26",
  "2020-03-26", "2020-04-26", "2020-05-19", "2020-05-29",
  "2020-01-03", "2020-01-29", "2020-01-30"),
  totalrain_post_sow_7d =
    c(10.5, 0.0, 0.0, 88.4, 20.7, 21.7, 0.0, 0.0, 0.0, 0.0),
  totalrad_flower_harvest = 
    c(481.1, 534.5, 346.2, 325.1, 349.3, 286.0, 233.8, 514.7, 401.5, 398.4))
expect_equal(crop2b, crop2b_result)

## tests for 'daily_mean' -----------------------------------------
expect_equal(daily_mean(boonah, enddate = crop$flower_date[4], ndays = 3), 11.16666667)
expect_equal(daily_mean(boonah, enddate = crop$harvest_date[4], ndays = 3), 12.233333333)
expect_equal(daily_mean(boonah, startdate = crop$flower_date[4],
                    enddate = crop$harvest_date[4]), 15.4809524)

## Add selected daily means to crop tibble
crop2a <- crop |>
  dplyr::mutate(mean_maxtemp_post_sow_7d =
          purrr::map_dbl(sowing_date, function(x)
            daily_mean(boonah, var = maxt, startdate = x, ndays = 7)),
          mean_rad_flower_harvest =
            purrr::map2_dbl(flower_date, harvest_date, function(x, y)
            daily_mean(boonah, var = radn, startdate = x, enddate = y)))
crop2a_result <- tibble::tibble(sowing_date = ymd(c("2019-08-25",
  "2019-09-20", "2019-12-18", "2020-01-15", "2020-02-15",
  "2020-03-10", "2020-03-20", "2019-10-25", "2019-11-20",
  "2019-11-21")), flower_date = ymd("2019-10-14", "2019-11-09",
  "2020-02-06", "2020-03-06", "2020-04-06", "2020-04-29",
  "2020-05-09", "2019-12-14", "2020-01-09", "2020-01-10"),
  harvest_date = ymd("2019-11-03", "2019-11-29", "2020-02-26",
  "2020-03-26", "2020-04-26", "2020-05-19", "2020-05-29",
  "2020-01-03", "2020-01-29", "2020-01-30"),
  mean_maxtemp_post_sow_7d = c(24.20000000, 28.31428571, 34.02857143,
                               32.00000000, 33.17142857, 26.42857143,
                               29.77142857, 30.41428571, 34.75714286,
                               33.97142857),
  mean_rad_flower_harvest = c(22.90952381, 25.45238095, 16.48571429,
                              15.48095238, 16.63333333, 13.61904762,
                              11.13333333, 24.50952381, 19.11904762,
                              18.97142857))
expect_equal(crop2a, crop2a_result)

## tests for 'growing_degree_days' -----------------------------------------
## answer only as not sure how to test what is printed, which might change anyway
expect_equal(growing_degree_days(boonah, enddate = crop$flower_date[4], ndays = 3,
                    varmax = maxt, varmin = mint), 61.1)
expect_equal(growing_degree_days(boonah, enddate = crop$harvest_date[4], ndays = 3,
                    varmax = maxt, varmin = mint), 51.8)
expect_equal(growing_degree_days(boonah, startdate = crop$flower_date[4], varmax = maxt,
                                 varmin = mint, enddate = crop$harvest_date[4]), 359.05)
## Add selected growing degree days to crop tibble and compare expected
crop2 <- crop |>
  dplyr::mutate(gddays8_post_sow_7d =
          purrr::map_dbl(sowing_date, function(x)
            growing_degree_days(boonah, startdate = x, ndays = 7, base_temp = 8)),
          gddays_flower_harvest =
            purrr::map2_dbl(flower_date, harvest_date, function(x, y)
            growing_degree_days(boonah, startdate = x, enddate = y)))
crop2_result <- tibble::tibble(sowing_date = ymd(c("2019-08-25",
  "2019-09-20", "2019-12-18", "2020-01-15", "2020-02-15",
  "2020-03-10", "2020-03-20", "2019-10-25", "2019-11-20",
  "2019-11-21")), flower_date = ymd("2019-10-14", "2019-11-09",
  "2020-02-06", "2020-03-06", "2020-04-06", "2020-04-29",
  "2020-05-09", "2019-12-14", "2020-01-09", "2020-01-10"),
  harvest_date = ymd("2019-11-03", "2019-11-29", "2020-02-26",
  "2020-03-26", "2020-04-26", "2020-05-19", "2020-05-29",
  "2020-01-03", "2020-01-29", "2020-01-30"), gddays8_post_sow_7d =
  c(55.45, 82.90, 111.45, 120.60, 123.60, 92.50, 101.05, 92.25,
  109.15, 110.20), gddays_flower_harvest = c(333.80, 376.60, 412.75,
  359.05, 322.65, 254.7, 239.25, 400.15, 430.05, 431.90))
expect_equal(crop2, crop2_result)

## tests for 'stress_days_over' -----------------------------------------
expect_equal(stress_days_over(boonah, enddate = crop$flower_date[4], ndays = 3), 2)
expect_equal(stress_days_over(boonah, enddate = crop$harvest_date[4], ndays = 3), 0)
expect_equal(stress_days_over(boonah, startdate = crop$flower_date[4],
                 enddate = crop$harvest_date[4]), 4)
expect_equal(stress_days_over(boonah, startdate = crop$flower_date[4],
                 enddate = crop$harvest_date[4], stress_temp = 27.5), 12)

## Add selected stress days to crop tibble
crop2s <- crop |>
  dplyr::mutate(stressdays25_post_sow_7d =
          purrr::map_dbl(sowing_date, function(x)
            stress_days_over(boonah, startdate = x, ndays = 7,
                                stress_temp = 25)),
          stressdays_flower_harvest =
            purrr::map2_dbl(flower_date, harvest_date, function(x, y)
            stress_days_over(boonah, startdate = x, enddate = y)))
crop2s_result <- tibble::tibble(sowing_date = ymd(c("2019-08-25",
  "2019-09-20", "2019-12-18", "2020-01-15", "2020-02-15",
  "2020-03-10", "2020-03-20", "2019-10-25", "2019-11-20",
  "2019-11-21")), flower_date = ymd("2019-10-14", "2019-11-09",
  "2020-02-06", "2020-03-06", "2020-04-06", "2020-04-29",
  "2020-05-09", "2019-12-14", "2020-01-09", "2020-01-10"),
  harvest_date = ymd("2019-11-03", "2019-11-29", "2020-02-26",
  "2020-03-26", "2020-04-26", "2020-05-19", "2020-05-29",
  "2020-01-03", "2020-01-29", "2020-01-30"),
  stressdays25_post_sow_7d = c(3, 7, 7, 7, 7, 7, 6, 7, 7, 7),
  stressdays_flower_harvest = c(10, 20, 11, 4, 5, 1, 0, 20, 16, 16))
expect_equal(crop2s, crop2s_result)

## tests for 'weather_extract' -----------------------------------------
expect_equal(boonah |>
  weather_extract(rain, date = date_met, startdate = ymd("2019-08-16"),
                  enddate = ymd("2019-08-21"), return.dates = FALSE),
  tibble::tibble(rain = rep(0, 6)))
##expect_equal(boonah |>
##  weather_extract(rain, startdate = ymd("2019-08-16"),
##                  enddate = ymd("2019-08-21"), return.dates = FALSE),
##  tibble::tibble(rain = rep(0, 6)))
expect_equal(boonah |>
  weather_extract(rain, startdate = ymd("2019-08-16"),
                  enddate = ymd("2019-08-21"), return.dates = TRUE),
  tibble::tibble(date_met = c(as_date(ymd("2019-08-16"):ymd("2019-08-21"))),
         rain = rep(0, 6)))
expect_equal(boonah |>
  weather_extract(maxt, date = date_met, startdate = ymd("2019-08-16"),
                  ndays = 3, return.dates = FALSE),
  tibble::tibble(maxt = c(26, 28, 25.7)))
expect_equal(boonah |>
  weather_extract(mint, date = date_met, enddate = ymd("2019-08-16"),
                  ndays = 1, return.dates = FALSE), tibble::tibble(mint = 5.3)) 
expect_equal(boonah |>
  weather_extract(c(rain, maxt, day), startdate = ymd("2019-08-16"),
                  enddate = ymd("2019-08-21"), return.dates = TRUE),
  tibble::tibble(date_met = c(as_date(ymd("2019-08-16"):ymd("2019-08-21"))),
         rain = rep(0, 6), maxt = c(26, 28, 25.7, 26.8, 23.1, 26.3),
         day = c(228:233)))

## created small data set that has a missing day to test 'weather_extract' ---------
boonah2 <-
  filter(boonah,
         date_met <= ymd("2019-08-21") & date_met >= ymd("2019-08-16")) |>
  filter(date_met != ymd("2019-08-18"))
## check returned tibble but supress warning
expect_equal(boonah2 |>
  weather_extract(rain, startdate = ymd("2019-08-16"),
                  enddate = ymd("2019-08-21"), return.dates = TRUE,
                  warn.consecutive = FALSE),
  tibble::tibble(date_met = c(as_date(ymd(c("2019-08-16","2019-08-17"))),
                                as_date(ymd("2019-08-19"):ymd("2019-08-21"))),
         rain = rep(0, 5)))
## check warnings re consecutive days
expected_warning_1 <- "Not all dates are present between 2019-08-16 and 2019-08-21\n            Calculations may result in incorrect values!\n"
expect_warning(boonah2 |>
  weather_extract(rain, startdate = ymd("2019-08-16"),
                  enddate = ymd("2019-08-21"), return.dates = TRUE),
  regexp = expected_warning_1)

## check in cumulative
expect_equal(cumulative(boonah2, var = rain,  startdate = ymd("2019-08-16"),
                        enddate = ymd("2019-08-21"), warn.consecutive = FALSE), 0)
## can not get this to work
## expected_warning_2 <- "In weather_extract\\(\\., var = all_of\\(var_n\\), datevar = NULL, ndays = ndays,  :\n  Warning: Not all dates are present between 2019-08-06 and 2019-08-21\n            Calculations may result in incorrect values!\n"
## and expected_warning_1 and ..._3 look the same to me but they aren't
## because pasted and \n added to actual warning messages
## identical(expected_warning_1, expected_warning_3) # FALSE
expected_warning_3 <- "Not all dates are present between 2019-08-06 and 2019-08-21\n            Calculations may result in incorrect values!\n"
expect_warning(cumulative(boonah2, var = rain,  startdate = ymd("2019-08-6"),
                          enddate = ymd("2019-08-21")), regexp = expected_warning_3)
