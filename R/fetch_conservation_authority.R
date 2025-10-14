##' Fetch Conservation Authority objects from Geohub
##'
##' This function will connect to the Geohub api and return the
##' matching records from the Conservation Authority
##' endpoint.  The geohub details page can be found here:
##' \url{https://geohub.lio.gov.on.ca/datasets/lio::conservation-authority-administrative-area/about}
##'
##' This function currently supports filters for COMMON_NAME like or
##' COMMON_NAME starts with.  Please note that the geohub api is
##' case sensitive and that the Conservation Authority names are in 'title
##' case'. This means that "Saugeen" will match the 'Saugeen Conservation',
##' but 'SAUGEEN' and 'saugeen' will not.
##'
##' @title Fetch Conservation Authority data from Geohub
##'
##' @param name_like - a string to match against part of the common
##'   name field.  This can be a single string or character
##'   vector of strings.
##' @param name_starts_with - a string to match against the start of
##'   the common name field. This can be a single string or
##'   character vector of strings.
##'
##' @return a sf object containing the geometry or geometries of the
##'   matching Conservation Authority object(s)
##' @export
##' @author R. Adam Cottrill
##'
##' @examples
##'
##' \donttest{
##' ca <- fetch_conservation_authority(name_like='Saugeen')
##' unique(ca$COMMON_NAME)
##'
##' ca <- fetch_conservation_authority(name_like=c('Saugeen', 'Maitland'))
##' unique(ca$COMMON_NAME)
##'
##' my_plot <- ggplot2::ggplot() +
##'  ggplot2::geom_sf(data = ca, ggplot2::aes(fill=COMMON_NAME))
##' print(my_plot)
##' }
##'
fetch_conservation_authority <- function(
    name_like = NULL,
    name_starts_with = NULL) {
  if (!is.null(name_like)) {
    name_like <- like_expression("COMMON_NAME", name_like)
  }

  if (!is.null(name_starts_with)) {
    name_starts_with <- starts_with_expression(
      "COMMON_NAME",
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
    "arcgis2/rest/services/LIO_OPEN_DATA/LIO_Open03/MapServer/11/",
    query
  )

  sf_object <- fetch_geojson_as_sf(url)
  return(sf_object)
}
