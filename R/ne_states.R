#' Get natural earth world state (admin level 1) polygons
#'
#' returns state polygons (administrative level 1) for specified countries
#'
#' @inherit ne_download
#'
#' @param country a character vector of country names.
#' @param geounit a character vector of geounit names.
#' @param iso_a2 a character vector of iso_a2 country codes
#' @param spat_object an optional alternative states map
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
#'   plot(spdf_france_country)
#'   plot(spdf_france_geounit)
#'
#'   plot(ne_states(country = "united kingdom"))
#'   plot(ne_states(geounit = "england"))
#' }
#'
#' @export
ne_states <- function(
  country = NULL,
  geounit = NULL,
  iso_a2 = NULL,
  spat_object = NULL,
  returnclass = c("sf", "sv")
) {
  returnclass <- match.arg(returnclass)

  if (returnclass == "sp") {
    deprecate_sp("ne_download(returnclass = 'sp')")
  }
  # set map from one stored this adds potential to add or pass other potential
  # state maps, e.g. without lakes but no checking is done, may not be needed
  if (is.null(spat_object)) {
    check_rnaturalearthhires()
    spat_object <- rnaturalearthhires::states10
  }

  # states50 only has Australia  Brazil Canada United States of America so not
  # included

  # set default filter
  filter <- TRUE

  # filter by country name (admin field in ne)
  if (!is.null(country)) {
    # check if field in data, for passed data or if changed in future
    if (!("admin" %in% names(spat_object))) {
      cli::cli_abort("No admin field in the data : {.val {names(spat_object)}}")
    }

    filter_country <- tolower(spat_object[["admin"]]) %in% tolower(country)
    filter <- filter & filter_country

    if (sum(filter_country) == 0L) {
      cli::cli_abort("No such country ({.val {country}}) in the data.")
    }
  }

  # filter by geounit
  if (!is.null(geounit)) {
    if (!("geonunit" %in% names(spat_object))) {
      cli::cli_abort(
        "No geonunit field in the data : {names(spat_object)}"
      )
    }

    filter_geounit <- tolower(spat_object[["geonunit"]]) %in% tolower(geounit)
    filter <- filter & filter_geounit

    if (sum(filter_geounit) == 0L) {
      cli::cli_abort("No such geounit ({.val {geounit}}) in the data.")
    }
  }

  # filter by iso_a2
  if (!is.null(iso_a2)) {
    if (!("iso_a2" %in% names(spat_object))) {
      cli::cli_abort(
        "No {.var iso_a2} field in the data : {names(spat_object)}."
      )
    }

    filter_iso_a2 <- tolower(spat_object[["iso_a2"]]) %in% tolower(iso_a2)
    filter <- filter & filter_iso_a2

    if (sum(filter_iso_a2) == 0L) {
      cli::cli_abort("No such iso_a2 ({.val {iso_a2}}) in the data.")
    }
  }

  # Convert to the desired class
  convert_spatial_class(spat_object[filter, ], returnclass)
}
