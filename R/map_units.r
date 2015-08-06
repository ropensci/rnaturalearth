#' world map_unit polygons from Natural Earth 
#'
#' map_unit polygons at scales 1:110m (small), 1:50m (medium), 1:10m (large).   
#' There are more map_units than countries e.g. United Kingdom is split into England, Scotland, Wales and Northern Ireland.
#' 
#' @format A \code{SpatialPolygonsDataFrame}
#' @slot data A data frame with attributes 
#' @name map_units
#' @aliases map_units110 map_units50 map_units10
NULL


#' @source \url{http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_map_units.zip}
#' @rdname map_units
"map_units110"


#' @source \url{http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_map_units.zip}
#' @rdname map_units
"map_units50"


#' @source \url{http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_map_units.zip}
#' @rdname map_units
"map_units10"