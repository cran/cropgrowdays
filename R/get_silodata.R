##' Retrieve weather data from Queensland Government DES longpaddock website
##'
##' SILO (Scientific Information for Land Owners) is a database of
##' Australian climate data from 1889 (current to yesterday). It
##' provides data sets for a range of climate variables. SILO is
##' hosted by the Science and Technology Division of the Queensland
##' Government's Department of Environment and Science (DES). For more
##' information please see
##' \url{https://www.longpaddock.qld.gov.au/silo/about}. While several
##' file formats are available, we use the APSIM format. Other formats
##' may be produced although the function may need to be modified if
##' the arguments do not fully accommodate the specifications. Please
##' see
##' \url{https://www.longpaddock.qld.gov.au/silo/about/file-formats-and-samples/}
##' SILO products are provided free of charge to the public for use
##' under the Creative Commons Attribution 4.0 license and appear to
##' be subject to fair use limits. Note that SILO may be unavailable
##' between 11am and 1pm (Brisbane time) each Wednesday and Thursday
##' to allow for essential system maintenance.
##'
##' When \code{extra}is specified, then extra columns which could
##' for instance include the site name are added to
##' each row for later calculations. This can also be employed in a
##' loop using [for()] loops or a \code{tidyverse} approach, such
##' as [purrrlyr::by_row()] in order to manipulate data by site.
##' 
##' @param latitude A number or character string of the site latitude
##'   for data retrieval
##' @param longitude A number or character string of the site
##'   longitude for data retrieval
##' @param email A string containing your email which is required by
##'   DES in order to access the data
##' @param START Start date as a character string \dQuote{YYYYMMDD}
##'   with no spaces. Default: \dQuote{20201101}
##' @param FINISH Last date as a character string \dQuote{YYYYMMDD}
##'   with no spaces. Default: \dQuote{20201231}
##' @param FORMAT of data file required. While this function was
##'   originally constructed to obtain \code{APSIM} format, other
##'   formats are available. See
##'   \url{https://www.longpaddock.qld.gov.au/silo/about/file-formats-and-samples/}
##'   Default: \dQuote{APSIM}
##' @param PASSWORD Default: \dQuote{apitest}
##' @param extras A list containing variable names and values for
##'   extra columns. Note that the new variable(s) will have the same
##'   value. Default: \code{NULL}
##' @param URL is the URL for querying the website and probably will
##'   not need to be changed. Default:
##'   \dQuote{https://www.longpaddock.qld.gov.au/cgi-bin/silo/DataDrillDataset.php}
##' 
##' @return Data frame/tibble containing specified or default climate
##'   variables. If \dQuote{APSIM} format is specified then an extra
##'   column \code{date_met}, containing the date, is returned along
##'   with the usual \code{year} and day of year \code{day}.
##'
##' @importFrom magrittr %>%
##' @importFrom utils read.delim
##' @importFrom tibble tibble
##' @examples
##' \dontrun{
##' ## Example 1: Replace MY_EMAIL_ADDRESS with your email address below
##' ##            Latitude and Longitude character strings
##' boonah_data <-
##'   get_silodata(latitude = "-27.9927", longitude = "152.6906",
##'                email = "MY_EMAIL_ADDRESS",
##'                START = "20190101", FINISH = "20200531")
##' ## Example 2: Replace MY_EMAIL_ADDRESS below with yours - adds extra column
##' ##            Latitude and Longitude are numeric
##' boonah_data2 <-
##'   get_silodata(latitude = -27.9927, longitude = 152.6906,
##'                email = "MY_EMAIL_ADDRESS",
##'                START = "20190101", FINISH = "20200531",
##'                extras = list(Sitename = "Boonah"))
##'}
##' 
##' @seealso \code{\link{get_multi_silodata}}
##' @export 
get_silodata <-
  function(latitude,  longitude, email,
           START = "20201101", FINISH = "20201231",
           FORMAT = "APSIM", PASSWORD = "apitest", extras = NULL,
           URL = "https://www.longpaddock.qld.gov.au/cgi-bin/silo/DataDrillDataset.php")
{
  params  <-  list(
    lat = latitude,
    lon = longitude,
    start = START, 
    finish = FINISH,
    format = FORMAT,
    username = email,
    password = PASSWORD
  )

  if (!is.null(extras))
  {
    if (!is.list(extras)) stop("Error: 'extras' must be a list")
    if (!all(unlist(lapply(extras, function(x) length(x) == 1))))
      stop("Error: 'extras' each list component must contain only one value")
  }
  
  ## query url and retrieve data ---------------------------------------- 
  silo_query <- httr::GET(URL, query=params)
  silodata <- httr::content(silo_query, as="text")
  ## originally this but not clear how to remove reference to variable .
  ## silodata <- silodata %>%
  ##   substring(regexpr("\nyear",.)) %>%
  ##   readr::read_delim(delim = " ")
  ## silodata <- silodata[-1,]

  tmpdata <- silodata
  tmpdata <- strsplit(as.character(tmpdata), "\nyear") # split after URL
  tmpdata <- as.character(tmpdata[[1]][2])
  tmpdata <- (strsplit(tmpdata, "\n")[[1]])[-2]
  tmpdata <- gsub("\\s+"," ",tmpdata) # replace multiple white space with " "
  tmpdata <- read.delim(textConnection(tmpdata), sep = " ")

  ## tidy up the data if APSIM format retrieved, otherwise return as is --
  if (FORMAT == "APSIM"){
    names(tmpdata)[1] <- "year"
    ##silodata <- tmpdata
    ## add in a date column for calcs but strict CRAN checking won't like
    ## using simple year and day since appears to come from nowhere
    ##silodata <- dplyr::mutate(silodata,
    ##     date_met = as.Date(day - 1, paste0(year, "-01-01")))
    
    tmpdata$date_met <- as.Date(tmpdata[,"day"] - 1,
                            paste0(tmpdata[,"year"], "-01-01"))
  }

  ## check that new col names aren't in returned data set
  if (any(names(extras) %in% names(tmpdata))){
    cat("Column names in weather data:\n")
    print(names(tmpdata))
    cat("Extra column names:\n")
    print(names(extras))
    stop("Error: can't add extra columns that are already present in silo data")
  }
  
  ## if extras set then add columns to tmpdata
  if (!is.null(extras)){
    ## add extra columns (same for all values)
    N <- dim(tmpdata)[2] 
    for (I in c(1:length(extras))){
      tmpdata[, N+I]  <- extras[[I]]
      names(tmpdata)[N+I] <- names(extras)[I]
    }
  } ##else {
  ##  cat("Warning: 'extras' not set. Is this intentional?")
  ##}
  
  tibble(tmpdata)
}
