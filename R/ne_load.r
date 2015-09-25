#' load a Natural Earth vector that has already been downloaded into R
#'
#' returns loaded vector as a spatial object.
#' 
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{10}
#' @param type type of natural earth file to download one of 'countries', 'map_units', 'map_subunits', 'sovereignty', 'states'
#'    OR the portion of any natural earth vector url after the scale and before the . 
#'    e.g. for "ne_50m_urban_areas.zip" this would be "urban_areas"
#' @param category one of natural earth categories : 'cultural', 'physical', 'raster'
#' @param destdir folder to load files from
#' @param file_name OPTIONAL name of file (excluding path) instead of natural earth attributes

#' @examples
#' spdf_world <- ne_load( scale = 110, type = 'countries' )
#' 
#' if (require(sp)) {
#'   plot(spdf_world)
#'   plot(ne_download(type='populated_places'))
#'   
#' }
#' @return A \code{Spatial} object depending on the vector source (points, lines or polygons).
#' @export

ne_load <- function(scale = 110,
                    type = 'countries',
                    category = c('cultural', 'physical', 'raster'),
                    destdir = NULL,
                    file_name = NULL
) 
{
  
  #destdir must be specified
  if (is.null(destdir))
    stop("you need to specify destdir= for the local folder you previously saved the file in. 
          Use ne_download() if you have yet to download the file")
  
  if (!is.null(file_name))  
    file_name <- ne_file_name(scale=scale, type=type, category=category)
  
  if (!file.exists(file_name))
    stop("the file ",file_name,"seems not to exist in your local folder ",destdir,"\nDid you download it using ne_download()?")
  
  sp_object <- readOGR(destdir, file_name, encoding='UTF-8')
  
  return(sp_object)
  
}