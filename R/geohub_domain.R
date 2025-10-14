#' Internal func to get the domain for the GEOHUB api's
#'
#' This function is intended to be used by all of the functions that
#' call an api endpoint exposed by GEOHUB.  Each of the apis are
#' likely to have slightly different urls, but a common domain. If the
#' api domain changes in the future, (ie - the domain name changes or
#' the #' version changes) we just need to update the value returned
#' by this function.
#'
#' To use a local version of GEOHUB api's during development of this
#' r-package, set the local environment variable GEOHUB_DOMAIN to the
#' complete base url (including the trailing slash) where the local
#' version of GEOHUB is running before calling any glfishr
#' functions. For example:
#'
#'     >  Sys.setenv(GEOHUB_DOMAIN="http://127.0.0.1:8000/")
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#'
#' @return string
#'
geohub_domain <- function() {
  domain <- Sys.getenv("GEOHUB_DOMAIN")
  if (domain == "") {
    domain <- "https://ws.lioservices.lrc.gov.on.ca/"
  }
  if (!grepl("^https?://.*/$", domain)) {
    msg <- sprintf(
      "GEOHUB_DOMAIN:'%s' is not a valid domain. API calls will not work.",
      domain
    )
    stop(msg)
  }
  return(domain)
}
