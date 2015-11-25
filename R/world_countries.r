#' Get natural earth world country polygons
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
#' spdf_world <- ne_countries()
#' spdf_africa <- ne_countries(continent='africa')
#' spdf_france <- ne_countries(country='france')
#' 
#' if (require(sp)) {
#'   plot(spdf_world)
#'   plot(spdf_africa)
#'   plot(spdf_france)   
#' }
#' @return A \code{SpatialPolygonsDataFrame} object.
#' @export
#' 
ne_countries <- function(scale = 110,
                            type = 'countries',
                            continent = NULL,
                            country = NULL,
                            geounit = NULL,
                            sovereignty = NULL) {
  

  spdf <- get_data(scale=scale, type=type)

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