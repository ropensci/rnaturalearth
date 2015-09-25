#' return a natural earth filename based on arguments
#'
#' returns a string that can then be used to download the file.
#' 
#'
#' @param scale scale of map to return, one of \code{'110'}, \code{'50'}, \code{'10'}
#' @param type type of natural earth file to download one of 'countries', 'map_units', 'map_subunits', 'sovereignty', 'states'
#'    OR the portion of any natural earth vector url after the scale and before the . 
#'    e.g. for "ne_50m_urban_areas.zip" this would be "urban_areas"
#' @param category one of natural earth categories : 'cultural', 'physical', 'raster'

#' @examples
#' ne_name <- ne_file_name( scale = 110, type = 'countries' )
#' 
#' @return string
#' @export

ne_file_name <- function(scale = 110,
                    type = 'countries',
                    category = c('cultural', 'physical', 'raster')
) 
{
  
  #check on permitted scales, convert names to numeric
  scale <- check_scale(scale)
  
  category <- match.arg(category)  
  #type is left unchecked so users can specify any natearth filename
  
  #some combinations are not available
  if ( type=='map_subunits' & scale==110 )
    stop("The combination of type=",type,"and scale=",scale,"is not available in Natural Earth")
  
  
  #add admin_0 to known types
  if (type=='countries' | type=='map_units' | type=='map_subunits' | type=='sovereignty' | type=='tiny_countries' ) 
    type <- paste0('admin_0_',type)
  
  #add admin_1 to known types
  #this actually just expands 'states' to the name including lakes
  #todo think about this one
  if (type == 'states')
    type <- 'admin_1_states_provinces_lakes'
  
  
  file_name <- paste0('ne_',scale,'m_',type)
}