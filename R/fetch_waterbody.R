##' Build waterbody name contains
##'
##' A helper function used by fetch_waterbody that will take a string
##' and return the api query string that will match any waterbodies
##' where the unofficial name, offical name, equivalent french name, and
##' official alternative name contain the string.
##'
##' @title  Build waterbody name starts with
##' @param name_like - string to match part of waterbody name fields to
##' @return partial api query string
##' @author R. Adam Cottrill
build_name_like <- function(name_like) {
  name_like <- paste0(
    sprintf("UNOFFICIAL_NAME+LIKE+'%%%s%%'", name_like),
    sprintf("+OR+EQUIVALENT_FRENCH_NAME+LIKE+'%%%s%%'", name_like),
    sprintf("+OR+OFFICIAL_ALTERNATE_NAME+LIKE+'%%%s%%'", name_like),
    sprintf("+OR+OFFICIAL_NAME+LIKE+'%%%s%%'", name_like)
  )
}


##' Build waterbody name starts with
##'
##' A helper function used by fetch_waterbody that will take a string
##' and return the api query string that will match the start of the
##' unofficial name, offical name, equivalent french name, and
##' official alternative name.
##'
##'
##' @title Build waterbody name starts with
##' @param name_starts_with - string to match the start of waterbody
##'   name fields to
##'
##' @return partial api query string
##' @author R. Adam Cottrill
build_name_starts_with <- function(name_starts_with) {
  name_starts_with <- paste0(
    sprintf("UNOFFICIAL_NAME+LIKE+'%%%s'", name_starts_with),
    sprintf("+OR+EQUIVALENT_FRENCH_NAME+LIKE+'%%%s'", name_starts_with),
    sprintf("+OR+OFFICIAL_ALTERNATE_NAME+LIKE+'%%%s'", name_starts_with),
    sprintf("+OR+OFFICIAL_NAME+LIKE+'%%%s'", name_starts_with)
  )
}
##' Build waterbody name ends with
##'
##' A helper function used by fetch_waterbody that will take a string
##' and return the api query string that will match the end of the
##' unofficial name, offical name, equivalent french name, and
##' official alternative name.
##'
##'
##' @title  Build waterbody name ends with
##' @param name_ends_with - string to match the end of waterbody name fields to
##'
##' @return partial api query string
##' @author R. Adam Cottrill
build_name_ends_with <- function(name_ends_with) {
  name_ends_with <- paste0(
    sprintf("UNOFFICIAL_NAME+LIKE+'%s%%'", name_ends_with),
    sprintf("+OR+EQUIVALENT_FRENCH_NAME+LIKE+'%s%%'", name_ends_with),
    sprintf("+OR+OFFICIAL_ALTERNATE_NAME+LIKE+'%s%%'", name_ends_with),
    sprintf("+OR+OFFICIAL_NAME+LIKE+'%s%%'", name_ends_with)
  )
}


##' Fetch waterbody objects from Geohub
##'
##' This function will connect to the Geohub api and return the
##' matching records from the Ontario waterbody location identifier
##' endpoint.  The geohub details page can be fount here:
##' https://geohub.lio.gov.on.ca/datasets/lio::ontario-waterbody-location-identifier/about
##'
##' This function current supports filters for waterbody body
##' identifiers, as well as partial string matches (names contains,
##' name starts with, and name ends with).  The string matches are
##' case sensitive, so 'Huron' will not match "Inverhuron".
##'
##' @title Fetch waterbody objects from Geohub
##' @param wbylid - a single waterbody id or a vector of waterbody
##'   ids.
##' @param name_like - a sting to match against part of the waterbody
##'   name fields.
##' @param name_starts_with - a sting to match against the start of
##'   the waterbody name fields.
##' @param name_ends_with - a sting to match against the start of the
##'   waterbody name fields.
##' @return sf (simple feature) object
##' @author R. Adam Cottrill
fetch_waterbody <- function(
  wbylid = NULL,
  name_like = NULL,
  name_starts_with = NULL,
  name_ends_with = NULL
) {
  # name like:
  if (!is.null(name_like)) {
    name_like <- build_name_like(name_like)
  }

  if (!is.null(name_starts_with)) {
    name_starts_with <- build_name_starts_with(name_starts_with)
  }

  if (!is.null(name_ends_with)) {
    name_ends_with <- build_name_ends_with(name_ends_with)
  }

  if (!is.null(wbylid)) {
    if (!all(grepl("\\d{2}\\-\\d{4}\\-\\d{5}", wbylid))) {
      msg <- paste0(
        "At least one of the provided values do not appear ",
        "to be a valid waterbody identifier."
      )
      stop(
        msg
      )
    }
    wbylid <- arg_to_query_string("WATERBODY_IDENT", wbylid)
  }

  query_string <- paste(
    wbylid,
    name_like,
    name_starts_with,
    name_ends_with,
    sep = "",
    collapse = "&"
  )

  query <- sprintf(
    "query?where=%s&outFields=*&f=geojson&outSR=4326",
    query_string
  )
  url <- paste0(
    "https://ws.lioservices.lrc.gov.on.ca/arcgis2/rest/services/",
    "LIO_OPEN_DATA/LIO_Open08/MapServer/17/",
    query
  )
  sf_object <- fetch_geojson_as_sf(url)
  return(sf_object)
}
