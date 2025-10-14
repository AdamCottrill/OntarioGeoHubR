##' Fetch Provincial Park objects from Geohub
##'
##' This function will connect to the Geohub api and return the
##' matching records from the Ontario Provincial Park
##' endpoint.  The geohub details page can be found here:
##'
##' \url{https://geohub.lio.gov.on.ca/datasets/lio::provincial-park-regulated/about}
##'
##'
##' This function current supports filters for COMMON_SHORT_NAME like
##' or COMMON_SHORT_NAME starts with.  Please note that the geohub
##' api is case sensitive and that the Provincial Parks are stored in
##' uppercase.  This function will automatically convert any filter
##' arguments to upper case before sending the request.
##'
##' @title Fetch Provincial Park Data from  Geohub
##'
##' @param name_like - a string to match against part of the common short
##'   name field.  This can be a single string or character
##'   vector of strings.
##' @param name_starts_with - a string to match against the start of
##'   the common short name field. This can be a single string or
##'   character vector of strings.
##' @return a sf object containing the geometry or geometries of the
##'   matching provincal park(s).
##' @export
##' @author R. Adam Cottrill
##'
##' @examples
##'
##' \donttest{
##' ppark <- fetch_provincial_park(name_like='Algonquin')
##' unique(ppark$COMMON_SHORT_NAME)
##'
##' ppark <- fetch_provincial_park(name_like=c('Algonquin', 'Inverhuron'))
##' unique(ppark$COMMON_SHORT_NAME)
##'
##' my_plot <- ggplot2::ggplot() +
##'  ggplot2::geom_sf(data = ppark, ggplot2::aes(fill=COMMON_SHORT_NAME))
##' print(my_plot)
##' }
##'
fetch_provincial_park <- function(name_like = NULL, name_starts_with = NULL) {
  if (!is.null(name_like)) {
    name_like <- like_expression("COMMON_SHORT_NAME", toupper(name_like))
  }

  if (!is.null(name_starts_with)) {
    name_starts_with <- starts_with_expression(
      "COMMON_SHORT_NAME",
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
    "arcgis2/rest/services/LIO_OPEN_DATA/LIO_Open03/MapServer/4/",
    query
  )

  sf_object <- fetch_geojson_as_sf(url)
  return(sf_object)
}
