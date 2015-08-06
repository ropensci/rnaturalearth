#' world country polygons from Natural Earth at 1:110m (small) resolution
#'
#' boundaries of world countries and associated attribute data
#'
#' @slot data A data frame with country attributes 
#'
#' @format A \code{SpatialPolygonsDataFrame} with 177 elements
#' @docType data
#' @keywords dataset
#' @source \url{http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip}
#'
#' @usage data(countries110)
"countries110"

#' world country polygons from Natural Earth at 1:50m (medium) resolution
#'
#' boundaries of world countries and associated attribute data
#'
#' @slot data A data frame with country attributes 
#'
#' @format A \code{SpatialPolygonsDataFrame} with	241 elements
#' @docType data
#' @keywords dataset
#' @source \url{http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip}
#'
#' @usage data(countries50)
"countries50"

#' world map_unit polygons from Natural Earth at 1:110m (small) resolution
#'
#' there are more map_units than countries e.g. French Guiana is separate from France
#'
#' @slot data A data frame with attributes 
#'
#' @format A \code{SpatialPolygonsDataFrame} with 183 elements
#' @docType data
#' @keywords dataset
#' @source \url{http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_map_units.zip}
#'
#' @usage data(map_units110)
"map_units110"

#' world sovereignty polygons from Natural Earth at 1:110m (small) resolution
#'
#' there are fewer sovereign states than countries e.g. the Falkland Islands are included with the United Kingdom
#'
#' @slot data A data frame with attributes 
#'
#' @format A \code{SpatialPolygonsDataFrame} with 171 elements
#' @docType data
#' @keywords dataset
#' @source \url{http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_sovereignty.zip}
#'
#' @usage data(sovereignty110)
"sovereignty110"


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

