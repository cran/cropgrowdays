##' Retrieve SILO data for multiple sites from Qld DES longpaddock website
##'
##' Uses \code{\link{get_silodata}} to retrieve SILO (Scientific
##' Information for Land Owners) data for multiple sites. SILO
##' products are provided free of charge to the public for use under
##' the Creative Commons Attribution 4.0 license and appear to be
##' subject to fair use limits. Note that SILO may be unavailable
##' between 11am and 1pm (Brisbane time) each Wednesday and Thursday
##' to allow for essential system maintenance.
##'
##' @param latitude A numerical vector containing site latitudes for
##'   data retrieval
##' @param longitude A numerical vector containing site longitudes for
##'   data retrieval
##' @param Sitename A vector of strings containing site names or
##'   labels which provide an extra column in the dataset named
##'   \code{Sitename}
##' @inheritParams get_silodata
##' 
##' @return A \code{\link{tibble}} (dataframe) containing specified or
##'   default climate variables. If \dQuote{APSIM} format is specified
##'   then an extra column \code{date_met}, containing the date, is
##'   returned along with the usual \code{year} and day of year
##'   \code{day}. The \code{Sitename} variable contains the name of
##'   each site.
##'
##' @importFrom utils read.delim
##' @importFrom tibble tibble
##' @examples
##' \dontrun{
##' ## Example: Replace MY_EMAIL_ADDRESS with your email address below
##' two_sites  <-
##'   get_multi_silodata(latitude = c(-27.00, -28.00),
##'                      longitude = c(151.00, 152.00),
##'                      Sitename = c("Site_1", "Site_2"),
##'                      START = "20201101", FINISH = "20201105",
##'                      FORMAT = "allmort",
##'                      email = "MY_EMAIL_ADDRESS")
##' two_sites
##' }
##'
##' @seealso \code{\link{get_silodata}}
##' @export 
get_multi_silodata <-
  function(latitude,  longitude, Sitename, email,
           START = "20201101", FINISH = "20201231",
           FORMAT = "apsim", PASSWORD = "apitest",
           URL = "https://www.longpaddock.qld.gov.au/cgi-bin/silo/DataDrillDataset.php")
{
  if (length(latitude) != length(longitude))
    stop("Error: 'latitude' and 'longitude' must have the same number of elements")
  if (length(latitude) != length(Sitename))
    stop("Error: The number of Sitenames must conform to 'latitude' and 'longitude'")
  
  specs_df <- data.frame(lat = latitude, lon = longitude, Sitename = Sitename)

  get_sites <- function(x, extravars = c("Sitename")) 
  {
    extra_vars <- vector("list", length = length(extravars))
    names(extra_vars) <- extravars
    for (I in 1:length(extravars)) {extra_vars[[I]] <- x[extravars[I]]}
    get_silodata(email = "MY_EMAIL_ADDRESS", latitude = x["lat"],
                 longitude = x["lon"], extras = extra_vars,
                 START = START, FINISH = FINISH, FORMAT = FORMAT,
                 PASSWORD = PASSWORD, URL = URL)
  }
  all_data <- purrrlyr::by_row(specs_df, get_sites)
  purrr::reduce(all_data$.out, full_join)  # tidy up the data and returns
}
