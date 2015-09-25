#' Get world state (admin level 1) polygons
#'
#' returns world state polygons (administrative level 1) for specified countries
#'
#' @param country a character vector of country names. 
#' @param geounit a character vector of geounit names. 
#' @param iso_a2 a character vector of iso_a2 country codes  
#' @param spdf an optional alternative states map
#' @examples
#' 
#' #comparing using country and geounit to filter
#' spdf_france_country <- world_states(country='france')
#' spdf_france_geounit <- world_states(geounit='france')
#'  
#' if (require(sp)) {
#'   plot(spdf_france_country)
#'   plot(spdf_france_geounit) 
#'   
#'   plot(world_states(country ='united kingdom'))  
#'   plot(world_states(geounit='england'))     
#' }
#' @return A \code{SpatialPolygonsDataFrame} object.
#' @export
#' 
world_states <- function(   country = NULL,
                            geounit = NULL,
                            iso_a2 = NULL,
                            spdf = NULL) {
  

  #add check if country, geounit and iso_a2 are in the data
  
  #set map from one stored
  #this adds potential to add or pass other potential state maps, e.g. without lakes
  #but no checking is done
  #may not be needed
  if (is.null(spdf)) spdf <- states10
  
  #states50 only has Australia  Brazil Canada United States of America
  #?not worth including option
  
  # set default filter
  filter <- TRUE
  
  # filter by country name (admin field in ne)
  if (!is.null(country)) 
  {
    filter_country <- tolower(spdf$admin) %in% tolower(country)   
    filter <- filter & filter_country
  }
  
  # filter by geounit
  if (!is.null(geounit)) 
  {
    #BEWARE seeming natearth bug of extra n in geoNunit
    #$ admin     : Factor w/ 257 levels "Afghanistan",..: 14 1 1 1 1 1 1 1 1 1 ...
    #$ geonunit  : Factor w/ 284 levels "Afghanistan",..: 15 1 1 1 1 1 1 1 1 1 ...
    filter_geounit <- tolower(spdf$geonunit) %in% tolower(geounit)   
    filter <- filter & filter_geounit
  }  
  
  # filter by iso_a2
  if (!is.null(iso_a2)) 
  {
    filter_iso_a2 <- tolower(spdf$iso_a2) %in% tolower(iso_a2)   
    filter <- filter & filter_iso_a2
  } 
  
  
  spdf[filter, ]
}


