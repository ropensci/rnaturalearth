#' coerce return object to sp if option set
#'
#' @param x scale of map to return, one of \code{110}, \code{50}, \code{10} or
#' \code{'small'}, \code{'medium'}, \code{'large'}
#'
#' @param returnclass 'sp' default or 'sf' for Simple Features
#'
#' @return an sf or sp object
ne_as_sp <- function(x, returnclass = c("sp", "sf")) {
  returnclass <- match.arg(returnclass)

  if (returnclass == "sp") {
    if (inherits(x, "Spatial")) {
      return(x)
    } else {
      return(as_Spatial(x))
    }
  } else {
    if (inherits(x, "Spatial")) {
      return(sf::st_as_sf(x))
    } else {
      return(x)
    }
  }
}
