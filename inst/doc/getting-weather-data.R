## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#:"
)

## ----cran-installation, eval = FALSE------------------------------------------
# install.packages("cropgrowdays")

## ----gl-installation, eval = FALSE--------------------------------------------
# ## if you don't have 'remotes' installed, automatically install it
# if (!require("remotes")) {
#   install.packages("remotes", repos = "http://cran.rstudio.com/")
#   library("remotes")
# }
# install_gitlab("petebaker/cropgrowdays", build_vignettes = TRUE)

## ----setup--------------------------------------------------------------------
suppressMessages(library(lubridate))
library(cropgrowdays)

## ----get-data, eval=FALSE-----------------------------------------------------
# boonah <-
#    get_silodata(latitude = "-27.9927", longitude = "152.6906",
#                 email = "MY_EMAIL_ADDRESS", START = "20190101", FINISH = "20200531")

## ----boonah-data--------------------------------------------------------------
## weather data object
print(boonah, n=5)

## ----get-data2, eval=FALSE----------------------------------------------------
# two_sites  <- get_multi_silodata(latitude = c(-27.00, -28.00),
#                      longitude = c(151.00, 152.00),
#                      Sitename = c("Site_1", "Site_2"),
#                      START = "20201101", FINISH = "20201105",
#                      email = "MY_EMAIL_ADDRESS")

## -----------------------------------------------------------------------------
two_sites

