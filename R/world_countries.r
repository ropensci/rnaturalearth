#' Get world country polygons
#'
#' returns world country polygons at a specified resolution
#'
#' @param resolution resoloution of the map to return, either \code{110} or \code{50}.
#' @param continent A character vector of continent names. Countries within these will be returned.
#' @examples
#' spdf_countries <- world_countries()
#' 
#' if (require(sp)) {
#'   plot(spdf_countries)
#' }
#' @return A \code{SpatialPolygonsDataFrame} object.
#' @export
#' 
world_countries <- function(resolution = 110,
                            continent = NULL) {
  
  countries110

}