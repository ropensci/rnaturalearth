#' Get natural earth world coastline
#'
#' returns world coastline at specified scale
#'
#' @inherit ne_download
#'
#' @examples
#' if (requireNamespace("rnaturalearthdata")) {
#'   coast <- ne_coastline()
#'   plot(coast)
#' }
#'
#' @export
ne_coastline <- function(scale = 110,
                         returnclass = c("sf", "sv")) {
  returnclass <- match.arg(returnclass)

  if (returnclass == "sp") {
    deprecate_sp("ne_download(returnclass = 'sp')")
  }

  # check for the data packages and try to install if not there
  if (scale == 10) {
    check_rnaturalearthhires()
  } else {
    check_rnaturalearthdata()
  }

  # check on permitted scales, convert names to numeric
  scale <- check_scale(scale)

  # choose which map based on scale
  sldf <- NULL

  if (scale == 110) {
    sldf <- rnaturalearthdata::coastline110
  } else if (scale == 50) {
    sldf <- rnaturalearthdata::coastline50
  } else if (scale == 10) {
    sldf <- rnaturalearthhires::coastline10
  }

  # Convert to the desired class
  convert_spatial_class(sldf, returnclass)
}
