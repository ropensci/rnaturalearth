#' Get natural earth world country polygons
#'
#' returns world country polygons at a specified scale, or points of
#' tiny_countries
#'
#' @inherit ne_download
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
#' @aliases ne_admin0
#'
#' @examples
#' world <- ne_countries()
#' africa <- ne_countries(continent = "africa")
#' france <- ne_countries(country = "france")
#'
#' plot(world$geometry)
#' plot(africa$geometry)
#' plot(france$geometry)
#'
#' # get as SpatVector
#' world <- ne_countries(returnclass = "sv")
#' terra::plot(world)
#'
#' tiny_countries <- ne_countries(type = "tiny_countries", scale = 50)
#' plot(tiny_countries)
#'
#' @export
ne_countries <- function(
  scale = 110L,
  type = "countries",
  continent = NULL,
  country = NULL,
  geounit = NULL,
  sovereignty = NULL,
  returnclass = c("sf", "sv")
) {
  returnclass <- match.arg(returnclass)
  if (returnclass == "sp") {
    deprecate_sp("ne_download(returnclass = 'sp')")
  }
  spat_object <- get_data(scale = scale, type = type)

  # some large scale NE data still have old uppercase fieldnames, this to
  # correct
  names(spat_object) <- tolower(names(spat_object))

  # set default filter
  filter <- TRUE

  # filter by continent
  if (!is.null(continent)) {
    filter <- tolower(spat_object[["continent"]]) %in% tolower(continent)

    if (sum(filter) == 0L) {
      cli::cli_abort("No such continent ({.val {continent}}) in the data.")
    }
  }

  # filter by country name (admin field in ne) todo I might be able to add the
  # name field from ne in here too
  if (!is.null(country)) {
    filter_country <- tolower(spat_object[["admin"]]) %in% tolower(country)
    filter <- filter & filter_country

    if (sum(filter_country) == 0L) {
      cli::cli_abort("No such country ({.val {country}}) in the data.")
    }
  }

  # filter by geounit
  if (!is.null(geounit)) {
    filter_geounit <- tolower(spat_object[["geounit"]]) %in% tolower(geounit)
    filter <- filter & filter_geounit

    if (sum(filter_geounit) == 0L) {
      cli::cli_abort("No such geounit ({.val {geounit}}) in the data.")
    }
  }

  # filter by sovereignty (BEWARE its called sovereignt in ne)
  if (!is.null(sovereignty)) {
    filter_sovereignty <- tolower(spat_object[["sovereignt"]]) %in%
      tolower(sovereignty)
    filter <- filter & filter_sovereignty

    if (sum(filter_sovereignty) == 0L) {
      cli::cli_abort("No such sovereignty ({.val {sovereignty}}) in the data")
    }
  }

  # Convert to the desired class
  convert_spatial_class(spat_object[filter, ], returnclass)
}
