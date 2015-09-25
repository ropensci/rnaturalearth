#' download a vector from Natural Earth and (optionally) read into R
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
  
  file_name <- ne_file_name(scale=scale, type=type, category=category)
  
  address <- paste0('http://www.naturalearthdata.com/http//',
                    'www.naturalearthdata.com/download/',scale,'m/',category,'/',
                    file_name,'.zip' )
  
  download.file(file.path(address), f <- tempfile())
  
  #todo how best to allow caching as suggested by Hadley
  #i want to allow local save, and later to allow easy load from previous local save

  #if (!is.null(local_folder)) unzip(f, exdir=local_folder)
  #but then tricky to allow default saving to current dir (maybe if TRUE?)
  #ne_download(local_folder=[my_folder])
  

  #ne_download() download & load (+option to not load)
  #ne_load() allows loading from previous download, will need to check it's there
  
  #what do I want default behaviour to be ?
  
  unzip(f, exdir=tempdir())
  
  sp_object <- readOGR(tempdir(), file_name, encoding='UTF-8')
  
  return(sp_object)
  
}