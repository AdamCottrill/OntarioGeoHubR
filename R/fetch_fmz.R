##' Fetch fmz objects from Geohub
##'
##' This function will connect to the Geohub api and return the
##' matching records from the Ontario Fisheries Management Zone
##' endpoint.  The geohub details page can be fount here:
##' https://geohub.lio.gov.on.ca/datasets/lio::fisheries-management-zone/about
##'
##' This function current supports filters for fisheries management
##' zone id - this can be a single integer, or a vector of integers
##' (e.g. c(4,5,6)).  Only values between 1 and 20 are allowed.
##'.
##' @title Fetch Fisheries Management Zones from Geohub
##'
##' @param fmz_number - a number or vector of numbers corresponding the
##'   Fisheries Management Zone numbers to retrieve from geohub.
##'
##' @return a sf obect containing the geometry or geometries of the
##'   provided fisheries management zone(s).
##' @author R. Adam Cottrill
fetch_fmz <- function(fmz_number) {
  if (!is.numeric(fmz_number)) {
    stop("Error: The argument 'fmz_number' must be a numeric value or vector.")
  }

  if (!all(fmz_number >= 1 & fmz_number <= 20)) {
    msg <- paste0(
      "Error: All elements of 'fmz_number' must be numeric values",
      " between 1 and 20"
    )
    stop(msg)
  }

  query_string <- arg_to_query_string(
    "FISHERIES_MANAGEMENT_ZONE_ID",
    fmz_number,
    FALSE
  )

  query <- sprintf(
    "query?where=%s&outFields=*&f=geojson",
    query_string
  )

  url <- paste0(
    "https://ws.lioservices.lrc.gov.on.ca/arcgis2/rest/services/",
    "LIO_OPEN_DATA/LIO_Open07/MapServer/14/",
    query
  )
  sf_object <- fetch_geojson_as_sf(url)
  return(sf_object)
}
