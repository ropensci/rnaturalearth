#' Get natural earth world state (admin level 1) polygons
#'
#' returns state polygons (administrative level 1) for specified countries
#'
#' @param country a character vector of country names.

#' @param geounit a character vector of geounit names.

#' @param iso_a2 a character vector of iso_a2 country codes

#' @param spdf an optional alternative states map

#' @param returnclass 'sp' default or 'sf' for Simple Features
#'
#' @aliases ne_admin1
#'
#' @examples
#'
#' # comparing using country and geounit to filter
#' if (requireNamespace("rnaturalearthhires")) {
#'   spdf_france_country <- ne_states(country = "france")
#'   spdf_france_geounit <- ne_states(geounit = "france")
#'
#'   if (require(sp)) {
#'     plot(spdf_france_country)
#'     plot(spdf_france_geounit)
#'
#'     plot(ne_states(country = "united kingdom"))
#'     plot(ne_states(geounit = "england"))
#'   }
#' }
#'
#' @return \code{SpatialPolygonsDataFrame} or \code{sf}

#' @export
ne_states <- function(country = NULL,
                      geounit = NULL,
                      iso_a2 = NULL,
                      spdf = NULL,
                      returnclass = c("sp", "sf")) {
  returnclass <- match.arg(returnclass)

  # set map from one stored this adds potential to add or pass other potential
  # state maps, e.g. without lakes but no checking is done, may not be needed
  if (is.null(spdf)) {
    check_rnaturalearthhires()
    spdf <- rnaturalearthhires::states10
  }


  # states50 only has Australia  Brazil Canada United States of America so not
  # included

  # set default filter
  filter <- TRUE

  # filter by country name (admin field in ne)
  if (!is.null(country)) {
    # check if field in data, for passed data or if changed in future
    if (!("admin" %in% names(spdf))) {
      stop("No admin field in the data : ", names(spdf))
    }

    filter_country <- tolower(spdf$admin) %in% tolower(country)
    filter <- filter & filter_country

    if (sum(filter_country) == 0) {
      stop("No such country (", country, ") in the data")
    }
  }

  # filter by geounit
  if (!is.null(geounit)) {
    # BEWARE seeming natearth bug of extra n in geoNunit
    # todo report this bug to natural earth
    # $ admin     : Factor w/ 257 levels "Afghanistan",..: 14 1 1 1 1 1 1 1 1 1 ...
    # $ geonunit  : Factor w/ 284 levels "Afghanistan",..: 15 1 1 1 1 1 1 1 1 1 ...

    if (!("geonunit" %in% names(spdf))) {
      stop("No geonunit field in the data : ", names(spdf))
    }

    filter_geounit <- tolower(spdf$geonunit) %in% tolower(geounit)
    filter <- filter & filter_geounit

    if (sum(filter_geounit) == 0) {
      stop("No such geounit (", geounit, ") in the data")
    }
  }

  # filter by iso_a2
  if (!is.null(iso_a2)) {
    if (!("iso_a2" %in% names(spdf))) {
      stop("No iso_a2 field in the data : ", names(spdf))
    }

    filter_iso_a2 <- tolower(spdf$iso_a2) %in% tolower(iso_a2)
    filter <- filter & filter_iso_a2

    if (sum(filter_iso_a2) == 0) {
      stop("No such iso_a2 (", iso_a2, ") in the data")
    }
  }


  # convert to sf if chosen
  ne_as_sp(spdf[filter, ], returnclass)
}
