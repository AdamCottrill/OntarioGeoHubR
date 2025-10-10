##' Build the api query string
##'
##' This function accepts two argulements - a string which representes
##' the field name and a string, or vector of strings that will be
##' used to construct the api query string.  Single fields will result
##' in a query string of the form "<FLD>=<ARG>", multiple arguments
##' will produce a string of the form "<FLD>+IN+(ARG1, ARG2,...)".
##' Some arguments may need to be wrapped in quotes in the final
##' string, 'quotes=TRUE' with ensure that is the case.
##' @title Build API query string
##' @param fld - the name of the field to be queried
##' @param arg - the value(s) to passed arg_to_query_string.R
##' @param quotes - boolean - should the values be wrapped in quotes?
##' @return query string
##' @author R. Adam Cottrill
arg_to_query_string <- function(fld, arg, quotes = TRUE) {
  if (length(arg) > 1) {
    if (quotes) {
      arg_string <- paste("'", arg, "'", sep = "", collapse = ",")
    } else {
      arg_string <- paste(arg, collapse = ",")
    }
    query_string <- sprintf("%s+IN+(%s)", fld, arg_string)
  } else {
    if (quotes) {
      query_string <- sprintf("%s='%s'", fld, arg)
    } else {
      query_string <- sprintf("%s=%s", fld, arg)
    }
  }
  return(query_string)
}
