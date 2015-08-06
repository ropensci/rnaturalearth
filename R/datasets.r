#' world country polygons from Natural Earth 
#'
#' at scales 1:110m (small), 1:50m (medium), 1:10m (large)
#'
#' @format A \code{SpatialPolygonsDataFrame}
#' @slot data A data frame with country attributes 
#' @aliases countries110 countries50 countries10
#' @name countries
NULL

#' @source \url{http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip}
#' @rdname countries
"countries110"

#' @source \url{http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip}
#' @rdname countries
"countries50"

#' @source \url{http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip}
#' @rdname countries
"countries10"

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

#' world sovereignty polygons from Natural Earth 
#'
#' sovereignty polygons at scales 1:110m (small), 1:50m (medium), 1:10m (large).   
#' There are fewer sovereign states than countries e.g. the Falkland Islands are included with the United Kingdom.
#' 
#' @format A \code{SpatialPolygonsDataFrame}
#' @slot data A data frame with attributes 
#' @aliases sovereignty110 sovereignty50 sovereignty10
#' @name sovereignty
NULL

#' @source \url{http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_sovereignty.zip}
#' @rdname sovereignty
"sovereignty110"

#' @source \url{http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_sovereignty.zip}
#' @rdname sovereignty
"sovereignty50"

#' @source \url{http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_sovereignty.zip}
#' @rdname sovereignty
"sovereignty10"


#' state (admin level 1) polygons from Natural Earth 
#' 
#' For all world countries at 1:10m (high) resolution, for Australia, Brazil, Canada and USA, from Natural Earth at 1:50m (medium) resolution
#'
#' @format A \code{SpatialPolygonsDataFrame}
#' @slot data A data frame with attributes 
#' @aliases states50 states10
#' @name states
NULL

#' @source \url{http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states.zip}
#' @rdname states
"states10"

#' @source \url{http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_1_states.zip}
#' @rdname states
"states50"


#' world coastlines from Natural Earth 
#' 
#' coastline lines at scales 1:110m (small), 1:50m (medium), 1:10m (large).
#'
#' @format A \code{SpatialLinesDataFrame}
#' @aliases coastlines110 coastlines50 coastlines10
#' @name coastlines
NULL


#' @source \url{http//www.naturalearthdata.com/download/110m/physical/ne_110m_coastline.zip}
#' @rdname coastlines
"coastline110"

#' @source \url{http//www.naturalearthdata.com/download/50m/physical/ne_50m_coastline.zip}
#' @rdname coastlines
"coastline50"

#' @source \url{http//www.naturalearthdata.com/download/10m/physical/ne_10m_coastline.zip}
#' @rdname coastlines
"coastline10"

