#' Get data from within the package
#'
#' returns world country polygons at a specified scale, used by ne_countries()
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{10}, \code{'small'}, \code{'medium'}, \code{'large'}
#' @param type country type, one of 'countries', 'map_units', 'sovereignty', 'tiny_countries'
# @examples
# spdf_world <- get_data(scale = 110, type = 'countries')
#' @return A \code{SpatialPolygonsDataFrame} object.
# don't export this
# @export
#' 
get_data <- function(scale = 110,
                     type = c('countries', 'map_units', 'sovereignty', 'tiny_countries') ) {

  # check on permitted scale arg, convert names to numeric
  scale <- check_scale(scale)
  
  # check permitted type arg
  type <- match.arg(type) 
  
  # tiny_countries not available at scale 10
  if ( type=='tiny_countries' && scale==10 )
    stop('tiny_countries are not available at scale 10, use scale 50 or 110')
  
  # check for the data packages and try to install if not there
  # avoid this check for one example dataset in this package (i.e. countries110)
  
  if ( scale == 10 )
  {
    check_rnaturalearthhires()    
  } else if ( !(scale == 110 && type == 'countries') )
  {
    check_rnaturalearthdata()        
  }
  
  # choose which map based on type and scale (stored in different packages)
  
  if ( scale == 110 && type == 'countries' ) {
    
    spdf <- getExportedValue("rnaturalearth", paste0(type,scale))
    
  } else if ( scale==110 || scale ==50 ) {
    
    spdf <- getExportedValue("rnaturalearthdata", paste0(type,scale))
    
  } else if ( scale==10 ) {
    
    spdf <- getExportedValue("rnaturalearthhires", paste0(type,scale))
    
  }


  return(spdf)
}