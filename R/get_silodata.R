##' Retrieve weather data from Queensland Government DES longpaddock website
##'
##' SILO (Scientific Information for Land Owners) is a database of
##' Australian climate data from 1889 (current to yesterday). It
##' provides data sets for a range of climate variables. SILO is
##' hosted by the Science and Technology Division of the Queensland
##' Government's Department of Environment and Science (DES). For more
##' information please see
##' \url{https://www.longpaddock.qld.gov.au/silo/about}. A number of
##' data formats are available via the \code{FORMAT} option, but we
##' have mainly used the \dQuote{apsim} format. Other formats may be
##' retrieved but these are largely untested. Please lodge an issue if
##' there are problems. For details, please see
##' \url{https://www.longpaddock.qld.gov.au/silo/about/file-formats-and-samples/}.
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
##'   originally constructed to obtain \code{apsim} format, other
##'   formats are now available but not as tested.  \code{rainman} is
##'   not included since it returns six separate files. See
##'   \url{https://www.longpaddock.qld.gov.au/silo/about/file-formats-and-samples/}
##'   Default: \dQuote{apsim}
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
##' ## Example 3: Replace MY_EMAIL_ADDRESS below with yours - adds extra column
##' ##            Latitude and Longitude are numeric.
##' ##            Retreives all Morton hydrological evapotranspirations
##' boonah_data3 <-
##'   get_silodata(latitude = -27.9927, longitude = 152.6906,
##'                email = "MY_EMAIL_ADDRESS", FORMAT  =  "allmort",
##'                START = "20190101", FINISH = "20190115",
##'                extras = list(Sitename = "Boonah"))
##' ## Example 4: Replace MY_EMAIL_ADDRESS below with yours - adds extra column
##' ##            Latitude and Longitude are numeric. Retreives two months of
##' ##            total rainfall and evaporation and means for max/min
##' ##            temperatures, solar radiation and vapour pressure
##' boonah_data4 <-
##'   get_silodata(latitude = -27.9927, longitude = 152.6906,
##'                email = "drpetebaker@gmail.com", FORMAT = "monthly",
##'                START = "20190101", FINISH = "20190228",
##'                extras = list(Sitename = "Boonah"))
##'}
##' 
##' @seealso \code{\link{get_multi_silodata}}
##' @export 
get_silodata <-
  function(latitude,  longitude, email,
           START = "20201101", FINISH = "20201231",
           FORMAT = c("apsim", "fao56", "standard", "allmort", "ascepm",
                      "evap_span", "span", "all2016", "alldata",
                      "p51", "rainonly", "monthly", "cenw"),
           PASSWORD = "apitest", extras = NULL,
           URL = "https://www.longpaddock.qld.gov.au/cgi-bin/silo/DataDrillDataset.php") {
  ## process FORMAT
  ## NB: rainman formats are not included since returns multiple files
  formats <- c("apsim", "fao56", "standard", "allmort", "ascepm",
                      "evap_span", "span", "all2016", "alldata",
                      "p51", "rainonly", "monthly", "cenw")
  FORMAT <- match.arg(FORMAT) # choose and check
  first_col_name <- c("year", rep("Date",8), "  date", "Year", "Yr.Mth", "*TMax")
  names(first_col_name) <- formats

  ## process params for web query
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
  if (FORMAT != "rainonly"){
    STSPLIT <- paste0("\n",  first_col_name[FORMAT])
    tmpdata <- strsplit(as.character(tmpdata), STSPLIT) # split after URL details
    ##  tmpdata <- strsplit(as.character(tmpdata), "\nyear") # split after URL details
    tmpdata <- as.character(tmpdata[[1]][2])
    tmpdata <- (strsplit(tmpdata, "\n")[[1]])[-2]
    tmpdata <- gsub("\\s+"," ",tmpdata) # replace multiple white space with " "
    if(FORMAT == "p51" | FORMAT == "cenw") {
      tmpdata[1] <- paste0("date", tmpdata[1])
      tmpdata <- read.delim(textConnection(trimws(tmpdata)), sep = " ")
    } else {
      tmpdata <- read.delim(textConnection(tmpdata), sep = " ")
    }
  } else {
    tmpdata <- read.delim(textConnection(tmpdata), sep = "")
    names(tmpdata) <- c("Year", "mth", "day", "day2", "Rain")
    tmpdata$Date <- as.Date(with(tmpdata, paste(Year, mth, day,
                                 sep = "-")), format = "%Y-%m-%d")
  }
  
  if(FORMAT == "cenw") {
    names(tmpdata)[1] <- "Tmax"
    tmpdata$Date <- as.Date(tmpdata$Date, format = "%d/%m/%Y")
  }

  ## process column 1 by restoring column name and converting to date
  ## if appropriate
  if(FORMAT != "p51" & FORMAT != "cenw")
      names(tmpdata)[1] <- first_col_name[FORMAT]
  if(names(tmpdata)[1] == "Date" | names(tmpdata)[1] == "date")
    tmpdata[,1] <- as.Date(as.character(tmpdata[,1]), format = "%Y%m%d")
    
  ## tidy up the data if APSIM format retrieved, otherwise return as is --
  if (FORMAT == "apsim"){
    ## names(tmpdata)[1] <- "year"
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
  
  tibble::tibble(tmpdata)
}
