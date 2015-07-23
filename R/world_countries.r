#' Get world country polygons
#'
#' returns world country polygons at a specified scale
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{'small'}, \code{'medium'}
#' @param classification country classification, one of 'countries', 'map_units', 'sovereignty'
#' @param continent a character vector of continent names to get countries from.
#' @param country a character vector of country names. 
#' @examples
#' spdf_world <- world_countries()
#' spdf_africa <- world_countries(continent='africa')
#' spdf_france <- world_countries(country='france')
#' 
#' if (require(sp)) {
#'   plot(spdf_world)
#'   plot(spdf_africa)
#'   plot(spdf_france)   
#' }
#' @return A \code{SpatialPolygonsDataFrame} object.
#' @export
#' 
world_countries <- function(scale = 110,
                            classification = 'countries',
                            continent = NULL,
                            country = NULL) {
  
  # be defensive about scale & get to single format
  if ( scale==110 | scale=='110' | tolower(scale)=='small' ) {
    
    scale <- 110    
    
  } else if ( scale==50 | scale=='50' | tolower(scale)=='medium' ) {
    
    scale <- 50  
    
  } else {
    
    stop("scale needs to be set to one of 110, 50, 'small', 'medium' you have :",scale,"\n")
    
  }

  # choose which map based on classification and scale
  # i could use paste to build up varname but this may be safer
  spdf <- NULL
  if ( classification=='countries' ) {
    if ( scale==110 ) { 
      spdf <- countries110    
      
    } else if ( scale==50 ) {
      spdf <- countries50  
    }    
  } else if ( classification=='map_units' ) { 
    if ( scale==110 ) { 
      spdf <- map_units110    
      
    } else if ( scale==50 ) {
      spdf <- map_units50  
    }     
  } else if ( classification=='sovereignty' ) { 
    if ( scale==110 ) { 
      spdf <- sovereignty110    
    
    } else if ( scale==50 ) {
      spdf <- sovereignty50  
    } else {
      
      stop("classification needs to be one of 'countries', 'map_units', 'sovereignty' you have :",classification,"\n")    
    } 
  }

  
  
        
  # set default filter
  filter <- TRUE
  
  # filter by continent
  if (!is.null(continent)) 
  {
    filter <- tolower(spdf$continent) %in% tolower(continent)   
  }

  # filter by country name (admin field in ne)
  # todo I might be able to add the name field from ne in here too
  if (!is.null(country)) 
  {
    filter_country <- tolower(spdf$admin) %in% tolower(country)   
    filter <- filter & filter_country
  }
  
  # todo I could add other optional filters e.g. iso_a3
  
  spdf[filter, ]
}