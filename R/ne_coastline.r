#' Get natural earth world coastline
#'
#' returns world coastline at specified scale
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{10} or \code{'small'}, \code{'medium'}, \code{'large'}
#' @examples
#' sldf_coast <- ne_coastline()
#' 
#' if (require(sp)) {
#'   plot(sldf_coast)
#' }
#' @return A \code{SpatialLinesDataFrame} object.
#' @export
#' 
ne_coastline <- function(scale = 110) {
  
  
  # check for the data packages and try to install if not there
  if ( scale == 10 )
  {
    check_rnaturalearthhires()    
  } else
  {
    check_rnaturalearthdata()        
  }

  # check on permitted scales, convert names to numeric
  scale <- check_scale(scale)
  
  # choose which map based on scale
  # i could use paste to build up varname but this may be safer for now
  sldf <- NULL
  
  if ( scale==110 ) { 
    sldf <- rnaturalearthdata::coastline110    
    
  } else if ( scale==50 ) {
    sldf <- rnaturalearthdata::coastline50  
    
  } else if ( scale==10 ) {
    sldf <- rnaturalearthhires::coastline10  
  }   
  
  return(sldf)        

}