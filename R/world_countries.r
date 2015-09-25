#' Get world country polygons
#'
#' returns world country polygons at a specified scale
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{'small'}, \code{'medium'}
#' @param type country type, one of 'countries', 'map_units', 'sovereignty'
#' @param continent a character vector of continent names to get countries from.
#' @param country a character vector of country names. 
#' @param geounit a character vector of geounit names. 
#' @param sovereignty a character vector of sovereignty names.  
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
                            type = 'countries',
                            continent = NULL,
                            country = NULL,
                            geounit = NULL,
                            sovereignty = NULL) {
  

  # check on permitted scales, convert names to numeric
  scale <- check_scale(scale)

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

  # some large scale NE data still have old uppercase fieldnames, this to correct
  names(spdf) <- tolower(names(spdf))
  
        
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

  # filter by geounit
  if (!is.null(geounit)) 
  {
    filter_geounit <- tolower(spdf$geounit) %in% tolower(geounit)   
    filter <- filter & filter_geounit
  }  
    
  # filter by sovereignty (BEWARE its called sovereignt in ne)
  if (!is.null(sovereignty)) 
  {
    filter_sovereignty <- tolower(spdf$sovereignt) %in% tolower(sovereignty)   
    filter <- filter & filter_sovereignty
  } 
  
  # todo I could add other optional filters e.g. iso_a3
  
  spdf[filter, ]
}