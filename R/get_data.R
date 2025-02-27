#' Get data from within the package
#'
#' returns world country polygons at a specified scale, used by ne_countries()
#'
#' @inherit ne_download
#'
#' @param type country type, one of 'countries', 'map_units', 'sovereignty',
#' 'tiny_countries'
#'
#' @return A \code{sf} object.
get_data <- function(
  scale = 110L,
  type = c(
    "countries",
    "map_units",
    "sovereignty",
    "tiny_countries"
  )
) {
  # check on permitted scale arg, convert names to numeric
  scale <- check_scale(scale)
  # check permitted type arg
  type <- match.arg(type)

  # tiny_countries not available at scale 10
  if (type == "tiny_countries" && scale == 10L) {
    stop("tiny_countries are not available at scale 10, use scale 50 or 110")
  }

  # check for the data packages and try to install if not there
  # avoid this check for one example dataset in this package (i.e. countries110)

  if (scale == 10L) {
    check_rnaturalearthhires()
  } else if (!(scale == 110L && type == "countries")) {
    check_rnaturalearthdata()
  }

  # choose which map based on type and scale (stored in different packages)

  if (scale == 110L && type == "countries") {
    sf_object <- getExportedValue("rnaturalearth", paste0(type, scale))
  } else if (scale == 110L || scale == 50L) {
    sf_object <- getExportedValue("rnaturalearthdata", paste0(type, scale))
  } else if (scale == 10L) {
    sf_object <- getExportedValue("rnaturalearthhires", paste0(type, scale))
  }

  return(sf_object)
}
