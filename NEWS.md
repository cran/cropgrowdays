# cropgrowdays 0.2.0
  * 25 May 2023: finalised major changes and minor corrections for CRAN release
## New features
  * Added most SILO formats for retrieving `longpaddock` weather data
  * Replaced all `magrittr` pipes with `Base R` pipes
## Minor improvements and fixes
  * Removed `tidyverse` altogether from Imports, Suggests and also tests
  * Fixed broken URL to `bomrang`', replaced with archived package and
    referred to in-development `ozWeather` package
  * Emphasised using `furrr` package for parallel processing in README
    and vignette

# cropgrowdays 0.1.1.9003
  * 16 May 2023 development version
	* Removed `tidyverse` dependency (Imports) as advised by Hadley Wickham
    * Added most SILO formats and started on rm tidyverse dependencies
    * Replaced `magrittr` pipes with `Base R` pipes, so `%>%` with `|>` and
      updated all documentation, examples etc
    * Updated Suggests to include `tidyverse` and `furrr`
    * Added reference to `ozWeather` in the getting weather data
      vignette
    * Emphasised `furrr` package more in README and vignette

# cropgrowdays 0.1.1
  * 11 Dec 2021 Version 0.1.1 finalised
    * bugfix for day of year financial calculations
	* included parallel processing via `furrr` description in vignette

# cropgrowdays 0.1.0
  * 16 June 2021 Version 0.1.0 finalised but minor corrections
    required
  * 21 June 2021 Version 0.1.0 released on CRAN
