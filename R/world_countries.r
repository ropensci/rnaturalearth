#' Get world country polygons
#'
#' returns world country polygons at a specified resolution
#'
#' @param resolution resoloution of the map to return, either \code{110} or \code{50}.
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
world_countries <- function(resolution = 110,
                            continent = NULL,
                            country = NULL) {
  
  # choose which map
  spdf <- NULL
  if ( resolution==110 | resolution=='110' | tolower(resolution)=='small' ) {
    
    spdf <- countries110    
    
  } else if ( resolution==50 | resolution=='50' | tolower(resolution)=='medium' ) {
    
    spdf <- countries50  
    
  } else {
    
    stop("resolution needs to be set to one of 110, 50, 'small', 'medium' you have :",resolution,"\n")
    
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
  
  
  spdf[filter, ]
}