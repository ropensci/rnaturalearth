#' download a vector from Natural Earth and read into R
#'
#' returns downloaded vector as a spatial object
#'
#' @param scale scale of map to return, one of \code{'110'}, \code{'50'}, \code{'10'}
#' @param type type of natural earth file to download one of 'countries', 'map_units', 'map_subunits', 'sovereignty', 'states'
#'    OR the portion of any natural earth vector url after the scale and before the . 
#'    e.g. for "ne_50m_urban_areas.zip" this would be "urban_areas"
#' @param category one of natural earth categories : 'cultural', 'physical', 'raster'

#' @examples
#' spdf_world <- ne_download( scale = '110', type = 'countries' )
#' 
#' if (require(sp)) {
#'   plot(spdf_world)
#'   plot(ne_download(type='populated_places'))
#'   
#' }
#' @return A \code{Spatial} object depending on the vector source (points, lines or polygons).
#' @export

ne_download <- function(scale = c('110','50','10'),
                        type = 'countries',
                        category = c('cultural', 'physical', 'raster')
                        ) 
{
  
  #checks on permitted arguments
  scale <- match.arg(scale)
  category <- match.arg(category)  
  #type is left unchecked so users can specify any natearth filename
  
  
  #some combinations are not available
  if ( type=='map_subunits' & scale=='110' )
    stop("The combination of type=",type,"and scale=",scale,"is not available in Natural Earth")
  
  
  #add admin_0 to known types
  if (type=='countries' | type=='map_units' | type=='map_subunits' | type=='sovereignty' ) 
    type <- paste0('admin_0_',type)

  #add admin_1 to known types
  if (type == 'states')
    type <- 'admin_1_states_provinces_lakes'
  
  
  
  file_name <- paste0('ne_',scale,'m_',type)
  
  address <- paste0('http://www.naturalearthdata.com/http//',
                    'www.naturalearthdata.com/download/',scale,'m/',category,'/',
                    file_name,'.zip' )
  
  download.file(file.path(address), f <- tempfile())
  
  unzip(f, exdir=tempdir())
  
  sp_object <- readOGR(tempdir(), file_name, encoding='UTF-8')
  
  return(sp_object)
  
}