#' Get natural earth world country polygons
#'
#' returns world country polygons at a specified scale, or points of
#' tiny_countries
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{10}
#' or \code{'small'}, \code{'medium'}, \code{'large'}
#'
#' @param type country type, one of 'countries', 'map_units', 'sovereignty',
#' 'tiny_countries'
#'
#' @param continent a character vector of continent names to get countries from.
#'
#' @param country a character vector of country names.
#'
#' @param geounit a character vector of geounit names.
#'
#' @param sovereignty a character vector of sovereignty names.
#'
#' @param returnclass 'sp' default or 'sf' for Simple Features
#'
#' @aliases ne_admin0
#'
#' @examples
#' spdf_world <- ne_countries()
#' spdf_africa <- ne_countries(continent = "africa")
#' spdf_france <- ne_countries(country = "france")
#'
#' if (require(sp)) {
#'   plot(spdf_world)
#'   plot(spdf_africa)
#'   plot(spdf_france)
#' }
#'
#' # get as sf
#' if (require(sf)) {
#'   sf_world <- ne_countries(returnclass = "sf")
#'   plot(sf_world)
#' }
#'
#' if (require(rnaturalearthdata) & require(sp)) {
#'   spdf_tiny_countries <- ne_countries(type = "tiny_countries", scale = 50)
#'   plot(spdf_tiny_countries)
#' }
#'
#' @return \code{SpatialPolygonsDataFrame},\code{SpatialPointsDataFrame} or
#' \code{sf}
#'
#' @export
ne_countries <- function(scale = 110,
                         type = "countries",
                         continent = NULL,
                         country = NULL,
                         geounit = NULL,
                         sovereignty = NULL,
                         returnclass = c("sp", "sf")) {
  returnclass <- match.arg(returnclass)

  if (returnclass == "sp") {
    deprecate_sp("ne_download(returnclass = 'sp')")
  }

  spdf <- get_data(scale = scale, type = type)

  # some large scale NE data still have old uppercase fieldnames, this to
  # correct
  names(spdf) <- tolower(names(spdf))

  # set default filter
  filter <- TRUE

  # filter by continent
  if (!is.null(continent)) {
    filter <- tolower(spdf$continent) %in% tolower(continent)

    if (sum(filter) == 0) {
      stop("No such continent (", continent, ") in the data")
    }
  }

  # filter by country name (admin field in ne) todo I might be able to add the
  # name field from ne in here too
  if (!is.null(country)) {
    filter_country <- tolower(spdf$admin) %in% tolower(country)
    filter <- filter & filter_country

    if (sum(filter_country) == 0) {
      stop("No such country (", country, ") in the data")
    }
  }

  # filter by geounit
  if (!is.null(geounit)) {
    filter_geounit <- tolower(spdf$geounit) %in% tolower(geounit)
    filter <- filter & filter_geounit

    if (sum(filter_geounit) == 0) {
      stop("No such geounit (", geounit, ") in the data")
    }
  }

  # filter by sovereignty (BEWARE its called sovereignt in ne)
  if (!is.null(sovereignty)) {
    filter_sovereignty <- tolower(spdf$sovereignt) %in% tolower(sovereignty)
    filter <- filter & filter_sovereignty

    if (sum(filter_sovereignty) == 0) {
      stop("No such sovereignty (", sovereignty, ") in the data")
    }
  }

  # todo I could add other optional filters e.g. iso_a3

  # convert to sp if chosen
  ne_as_sp(spdf[filter, ], returnclass)
}
