##' Request a geojson resource from geohub
##'
##' This functions sends a request to the provide url and attempts to
##' covert the geojson repsonse into a sf (simple feature) object. If
##' the response is not successful, an error is thrown.  This funciton
##' is not expected to be used directly by user, but is called by most
##' of other functions in the OntarioGeohubR package.
##' @title Request a resource from geohub
##' @param url - the url (including query parameters) to the requested
##'   geohub resource.
##' @return sf (simple feature) object
##' @export
##' @author R. Adam Cottrill
fetch_geojson_as_sf <- function(url) {
  encoded_url <- utils::URLencode(url)
  response <- httr::GET(encoded_url)
  if (httr::http_status(response)$category == "Success") {
    # Parse the JSON content
    geojson_string <- httr::content(response, "text", encoding = "UTF-8")
    sf_object <- geojsonsf::geojson_sf(geojson_string)
  } else {
    stop("API request failed: ", httr::http_status(response)$reason)
  }
  sf_object
}
