## tests for 'day_of_year' -----------------------------------------
expect_equal(day_of_year(ymd("2020-01-05")), 5)
expect_equal(day_of_year(ymd("2021-01-05")), 5)
expect_equal(day_of_year(ymd(c("2020-06-05"), "2021-06-05")),
             c(157, 156))                 # 29 Feb in 2020 only
expect_equal(day_of_year(ymd("2020-12-31")), 366)
expect_equal(day_of_year(ymd("2021-12-31")), 365)
expect_equal(day_of_year(ymd("2020-12-31"), return_year = TRUE),
             data.frame(day = 366, year = 2020))
expect_equal(day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01"))),
             c(366, 153, 1))
expect_equal(day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01")),
                         return_year = TRUE),
             data.frame(day = c(366, 153, 1), year = rep(2020, 3)))

## Day of Financial Year
expect_equal(day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01")),
                         type = "financial"), c(214, 1, 215))
expect_equal(day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01")),
                        type = "fin", return_year = TRUE),
                data.frame(day = c(214, 1, 215),
                     fin_year = c("2020/2021", "2020/2021", "2019/2020")))
            
## Specify the year starts on 1 September
expect_equal(day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01")),
            type = "other", base = list(d = 1, m = 9)), c(122, 275, 123))
expect_identical(day_of_year(ymd(c("2020-12-31", "2020-06-01", "2020-01-01")),
                             type = "other", base = list(d = 1, m = 9),
                             return_year = TRUE),
                 data.frame(day = c(122, 275, 123),
                    base = ymd(c("2020-09-01", "2019-09-01", "2019-09-01"))))

## tests for 'date_from_day_year' -----------------------------------------
expect_identical(date_from_day_year(day = 366, year = 2020), ymd("2020-12-31"))
expect_identical(date_from_day_year(21,2021), ymd("2021-01-21"))
expect_identical(date_from_day_year(21,2021, type = "financial"), ymd("2021-06-21"))
expect_identical(date_from_day_year(21,2021, type = "other", base = list(d=1, m=9)),
                 ymd("2021-09-21"))
## multiple days
expect_identical(date_from_day_year(day = c(21, 24, 30), year = rep(2021, 3)),
                 ymd(c("2021-01-21", "2021-01-24", "2021-01-30")))


## tests for 'day_of_harvest' -----------------------------------------
expect_equal(day_of_harvest(x = ymd("2020-06-15"), sowing = ymd("2020-06-01")), 167) 
expect_equal(day_of_harvest(x = ymd("2021-06-15"), sowing = ymd("2021-06-01")), 166)
expect_equal(day_of_harvest(x = ymd("2021-06-15"), sowing = ymd("2020-06-01")), 532)
expect_equal(day_of_harvest(x = ymd("2021-02-05"), sowing = ymd("2021-01-28")), 36)
expect_equal(day_of_harvest(x = ymd("2021-02-05"), sowing = ymd("2021-01-28"),
                            type = "financial"), 250)
expect_equal(day_of_harvest(x = ymd("2021-02-05"), sowing = ymd("2021-01-28"),
                            type = "other", base = list(m = 9, day = 1)), 158)

## test number of days
expect_equal(number_of_days(x = ymd("2021-01-05"), start = ymd("2020-12-28")), 8)
