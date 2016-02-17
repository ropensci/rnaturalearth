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
#' @param destdir folder to load files from, default=tempdir()
#' @param file_name OPTIONAL name of file (excluding path) instead of natural earth attributes

#' @examples
#' #commented out to stop download in check
#' #download followed by load from tempdir() works in same R session
#' #spdf_world <- ne_download( scale = 110, type = 'countries' )
#' #spdf_world2 <-    ne_load( scale = 110, type = 'countries' )
#' #download followed by load from specified directory works between R sessions
#' #spdf_world <- ne_download( scale = 110, type = 'countries', destdir = getwd() )
#' #spdf_world2 <-    ne_load( scale = 110, type = 'countries', destdir = getwd() )
#' #for raster
#' #download & load
#' #rst <- ne_download(scale = 50, type = "OB_50M", category = "raster", destdir = getwd())
#' #load after having downloaded
#' #rst <- ne_load(scale = 50, type = "OB_50M", category = "raster", destdir = getwd())
#' #plot
#' #library(raster)
#' #plot(rst)

#' @return A \code{Spatial} object depending on the data (points, lines, polygons or raster).
#' @export

ne_load <- function(scale = 110,
                    type = 'countries',
                    #category = c('cultural', 'physical'),
                    category = c('cultural', 'physical', 'raster'),
                    #destdir = NULL,
                    destdir = tempdir(),
                    file_name = NULL
) 
{
  
  if (is.null(file_name)) 
  {
    file_name <- ne_file_name(scale=scale, type=type, category=category)    
  }
  
  
  error_msg <- paste0("the file ",file_name," seems not to exist in your local folder ",destdir,
                      "\nDid you download it using ne_download()?")
  
  if ( category == 'raster' )
  {

    file_tif <- file.path(destdir, file_name ,paste0(file_name, ".tif"))
    
    if (!file.exists( file_tif ) )
      stop(error_msg)
    
    rst <- raster::raster(file_tif)
    
    return(rst)
    
    
  } else #for shapefiles
  {
    
    #add '.shp' for the exists test (it's not needed by readOGR)
    if (!file.exists( file.path(destdir, paste0(file_name,'.shp'))))
      stop(error_msg)
    
    
    sp_object <- readOGR(destdir, file_name, encoding='UTF-8', stringsAsFactors=FALSE)
    
    return(sp_object)
  }
  
}