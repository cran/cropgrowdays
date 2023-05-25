library(dplyr)
library(purrr)
library(testthat)
library(lubridate)
library(cropgrowdays)

test_check("cropgrowdays")

## Notes on this file: test/testthat.R

## above generated automatically and seem to work very nicely
## ess-r-devtools-test-package   C-c C-w C-t, C-c C-w t
##   Interface for `devtools::test()'.
## ESS seems to run tests just fine as long as they are in
## tests/testthat/
##
## See  either https://r-pkgs.org/tests.html or
##https://debruine.github.io/tutorials/your-first-r-package-with-unit-tests.html
## Need to put test files in ./tests/testthat directory not ./tests
## Now just need to write the tests correctly ;-) !! EXCEPT seems to have
##  trouble finding 'purrr' even though it is part of tidyverse
