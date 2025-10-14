##' Fetch Township objects from Geohub
##'
##' This function will connect to the Geohub api and return the
##' matching records from the Ontario Township
##' endpoint.  The geohub details page can be found here:
##'
##' \url{https://geohub.lio.gov.on.ca/datasets/lio::geographic-township-improved/about}
##'
##' This functions currently supports filters for OFFICIAL_NAME like
##' or OFFICIAL_NAME starts with.  Please note that the geohub
##' api is case sensitive and that the Township names are stored in
##' uppercase in GeoHub.  This function will automatically convert any filter
##' arguments to upper case before sending the request.
##'
##' @title Fetch Township Data from  Geohub
##'
##' @param name_like - a string to match against part of the official
##'   name field.  This can be a single string or character
##'   vector of strings.
##' @param name_starts_with - a string to match against the start of
##'   the official name field. This can be a single string or
##'   character vector of strings.
##'
##' @return a sf object containing the geometry or geometries of the
##'   matching provincal parts.
##' @export
##' @author R. Adam Cottrill
##'
##' @examples
##'
##' \donttest{
##' twnshp <- fetch_township(name_like='Saugeen')
##' unique(twnshp$OFFICIAL_NAME)
##'
##' twnshp <- fetch_township(name_like=c('Saugeen', 'Bruce'))
##' unique(twnshp$OFFICIAL_NAME)
##'
##' my_plot <- ggplot2::ggplot() +
##'  ggplot2::geom_sf(data = twnshp)
##' print(my_plot)
##' }
fetch_township <- function(name_like = NULL, name_starts_with = NULL) {
  if (!is.null(name_like)) {
    name_like <- like_expression("OFFICIAL_NAME", toupper(name_like))
  }

  if (!is.null(name_starts_with)) {
    name_starts_with <- starts_with_expression(
      "OFFICIAL_NAME",
      toupper(name_starts_with)
    )
  }

  query_string <- paste(
    name_like,
    name_starts_with,
    sep = "",
    collapse = "&"
  )

  query <- sprintf(
    "query?where=%s&outFields=*&f=geojson&outSR=4326",
    query_string
  )

  url <- paste0(
    geohub_domain(),
    "arcgis2/rest/services/LIO_OPEN_DATA/LIO_Open06/MapServer/1/",
    query
  )

  sf_object <- fetch_geojson_as_sf(url)
  return(sf_object)
}
