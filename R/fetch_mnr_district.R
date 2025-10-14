##' Fetch MNR District objects from Geohub
##'
##' This function will connect to the Geohub api and return the
##' matching records from the MNR Disticts endpoint.  The geohub
##' details page can be found here:
##' \url{https://geohub.lio.gov.on.ca/datasets/lio::mnr-district/about}
##'
##' This function currently supports filters for DISTRICT_NAME like or
##' DISTRICT_NAME starts with.  Please note that the geohub api is
##' case sensitive and that the MNR districts are in 'title
##' case'. This means that "Aurora" will match the 'Aurora District',
##' but 'AURORA' and 'aurora' will not.
##'
##' @title Fetch MNR Districts from Geohub
##'
##' @param name_like - a string to match against part of the district
##'   name field.  This can be a single string or character
##'   vector of strings.
##' @param name_starts_with - a string to match against the start of
##'   the district name field. This can be a single string or
##'   character vector of strings.
##' @return a sf object containing the geometry or geometries of the
##'   provided fisheries management zone(s).
##' @export
##' @author R. Adam Cottrill
##'
##' @examples
##'
##' \donttest{
##' dist <- fetch_mnr_district(name_like='Aurora')
##' unique(dist$DISTRICT_NAME)
##'
##' dist <- fetch_mnr_district(name_like=c('Aurora', 'Owen Sound'))
##' unique(dist$DISTRICT_NAME)
##'
##' my_plot <- ggplot2::ggplot() +
##'  ggplot2::geom_sf(data = dist)
##' print(my_plot)
##' }
##'
fetch_mnr_district <- function(name_like = NULL, name_starts_with = NULL) {
  if (!is.null(name_like)) {
    name_like <- like_expression("DISTRICT_NAME", name_like)
  }

  if (!is.null(name_starts_with)) {
    name_starts_with <- starts_with_expression(
      "DISTRICT_NAME",
      name_starts_with
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
    "arcgis2/rest/services/LIO_OPEN_DATA/LIO_Open03/MapServer/6/",
    query
  )

  sf_object <- fetch_geojson_as_sf(url)
  return(sf_object)
}
