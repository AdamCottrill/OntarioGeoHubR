##' Build an 'like' query string
##'
##'
##' This is a helper function that accepts a field name and a value
##' and returns a formatted string of the form:
##' '<fld>+LIKE+"%%<value>%%"'.  This format is used by the ArcGis
##' rest api to return any matches were the field contains the value.
##' This function is not intended to be used directly by users, but is
##' use by most of the other functions in OntarioGeoHubR
##'
##' @title LIKE Query Expression
##' @param field_name - the name of the field to query against
##' @param arg - the value of the field to match
##' @return formatted string
##' @author R. Adam Cottrill
like_expression <- function(field_name, arg) {
  parts <- sprintf("%s+LIKE+'%%%s%%'", field_name, arg)
  return(paste(parts, collapse = "+OR+"))
}


##' Build a 'starts with query string'
##'
##' This is a helper function that accepts a field name and a value
##' and returns a formatted string of the form:
##' '<fld>+LIKE+"<value>%%"'.  This format is used by the ArcGis rest
##' api to return any matches were the field starts with the value.
##' This function is not intended to be used directly by users, but is
##' use by most of the other functions in OntarioGeoHubR
##'
##' @title STARTS_WITH Query Expreession
##' @param field_name - the name of the field to query against
##' @param arg - the value of the field to match
##' @return formatted string
##' @author R. Adam Cottrill
starts_with_expression <- function(field_name, arg) {
  parts <- sprintf("%s+LIKE+'%s%%'", field_name, arg)
  return(paste(parts, collapse = "+OR+"))
}
