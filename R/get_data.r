#' Get data from within the package
#'
#' returns world country polygons at a specified scale, used by world_countries()
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{'small'}, \code{'medium'}
#' @param type country type, one of 'countries', 'map_units', 'sovereignty'
# @examples
# spdf_world <- get_data(scale = 110, type = 'countries')
#' @return A \code{SpatialPolygonsDataFrame} object.
# don't export this
# @export
#' 
get_data <- function(scale = 110,
                     type = 'countries') {


  # check on permitted scales, convert names to numeric
  scale <- check_scale(scale)
  
  #todo I may later be able to replace the below with this suggested by Hadley
  #but before I do that I want to sort which datasets are going to be in the package
  #e.g. some type,scale combinations are not available
  #getExportedValue("rnaturalearth", paste0(type,scale))
  
  
  # choose which map based on type and scale
  # i could use paste to build up varname but this may be safer
  # todo this may not be necessary if I allow filtering by geounit and sovereignt[y] fields instead
  spdf <- NULL
  if ( type=='countries' ) {
    if ( scale==110 ) { 
      spdf <- countries110    
      
    } else if ( scale==50 ) {
      spdf <- countries50  
      
    } else if ( scale==10 ) {
      spdf <- countries10  
    }       
  } else if ( type=='map_units' ) { 
    if ( scale==110 ) { 
      spdf <- map_units110    
      
    } else if ( scale==50 ) {
      spdf <- map_units50  
      
    } else if ( scale==10 ) {
      spdf <- map_units10  
    }         
  } else if ( type=='sovereignty' ) { 
    if ( scale==110 ) { 
      spdf <- sovereignty110    
      
    } else if ( scale==50 ) {
      spdf <- sovereignty50  
      
    } else if ( scale==10 ) {
      spdf <- sovereignty10  
    }
    else {
      
      stop("type needs to be one of 'countries', 'map_units', 'sovereignty' you have :",type,"\n")    
    }     
  }

  return(spdf)
}