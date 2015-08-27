#' download a vector from Natural Earth and read into R
#'
#' returns downloaded vector as a spatial object.
#' 
#'
#' @param scale scale of map to return, one of \code{'110'}, \code{'50'}, \code{'10'}
#' @param type type of natural earth file to download one of 'countries', 'map_units', 'map_subunits', 'sovereignty', 'states'
#'    OR the portion of any natural earth vector url after the scale and before the . 
#'    e.g. for "ne_50m_urban_areas.zip" this would be "urban_areas"
#' @param category one of natural earth categories : 'cultural', 'physical', 'raster'

#' @examples
#' spdf_world <- ne_download( scale = 110, type = 'countries' )
#' 
#' if (require(sp)) {
#'   plot(spdf_world)
#'   plot(ne_download(type='populated_places'))
#'   
#' }
#' @return A \code{Spatial} object depending on the vector source (points, lines or polygons).
#' @export

ne_download <- function(scale = 110,
                        type = 'countries',
                        category = c('cultural', 'physical', 'raster')
                        ) 
{
  
  #check on permitted scales, convert names to numeric
  scale <- check_scale(scale)
  
  category <- match.arg(category)  
  #type is left unchecked so users can specify any natearth filename
  
  # todo split ne_file_name out into separate function
  
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
  
  address <- paste0('http://www.naturalearthdata.com/http//',
                    'www.naturalearthdata.com/download/',scale,'m/',category,'/',
                    file_name,'.zip' )
  
  download.file(file.path(address), f <- tempfile())
  
  #todo how best to allow caching as suggested by Hadley
  #i want to allow local save, and later to allow easy load from previous local save
  #option1
  #ne_download(save_shape_to=[my_folder])
  #if (!is.null(save_shape_to)) unzip(f, exdir=save_shape_to)
  #but then tricky to allow default saving to current dir (maybe if TRUE?)
  #ne_download(local_location=[my_folder])
  
  #option2
  #ne_download() 
  #ne_load() allows loading from previous download, will need to check it's there
  
  unzip(f, exdir=tempdir())
  
  sp_object <- readOGR(tempdir(), file_name, encoding='UTF-8')
  
  return(sp_object)
  
}