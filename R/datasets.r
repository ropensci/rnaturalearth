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


#' world state (admin level 1) polygons from Natural Earth at 1:10m (high) resolution
#'
#'
#' @slot data A data frame with state attributes 
#'
#' @format A \code{SpatialPolygonsDataFrame}
#' @docType data
#' @keywords dataset
#' @source \url{http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states.zip}
#'
#' @usage data(states10)
"states10"


#' state (admin level 1) polygons for Australia, Brazil, Canada and USA, from Natural Earth at 1:50m (medium) resolution
#'
#' @slot data A data frame with state attributes 
#'
#' @format A \code{SpatialPolygonsDataFrame}
#' @docType data
#' @keywords dataset
#' @source \url{http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_1_states.zip}
#'
#' @usage data(states50)
"states50"


#' world coastlines from Natural Earth at 1:110m (small) resolution
#'
#' @format A \code{SpatialLinesDataFrame}
#' @docType data
#' @keywords dataset
#' @source \url{http//www.naturalearthdata.com/download/110m/physical/ne_110m_coastline.zip}
#'
#' @usage data(coastline110)
"coastline110"

#' world coastlines from Natural Earth at 1:50m (medium) resolution
#'
#' @format A \code{SpatialLinesDataFrame}
#' @docType data
#' @keywords dataset
#' @source \url{http//www.naturalearthdata.com/download/50m/physical/ne_50m_coastline.zip}
#'
#' @usage data(coastline50)
"coastline50"

#' world coastlines from Natural Earth at 1:10m (large) resolution
#'
#' @format A \code{SpatialLinesDataFrame}
#' @docType data
#' @keywords dataset
#' @source \url{http//www.naturalearthdata.com/download/10m/physical/ne_10m_coastline.zip}
#'
#' @usage data(coastline10)
"coastline10"

