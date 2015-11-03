#' download a vector from Natural Earth and (optionally) read into R
#'
#' returns downloaded vector as a spatial object.
#' 
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{10}
#' @param type type of natural earth file to download one of 'countries', 'map_units', 'map_subunits', 'sovereignty', 'states'
#'    OR the portion of any natural earth vector url after the scale and before the . 
#'    e.g. for "ne_50m_urban_areas.zip" this would be "urban_areas"
#' @param category one of natural earth categories : 'cultural', 'physical', 'raster'
#' @param destdir where to save files, defaults to \code{tempdir()}
#' @param load TRUE/FALSE whether to load file into R and return
#' @examples
#' spdf_world <- ne_download( scale = 110, type = 'countries' )
#' 
#' if (require(sp)) {
#'   plot(spdf_world)
#'   plot(ne_download(type='populated_places'))
#' }
#' 
#' #reloading from the saved file in the same session with same arguments
#' spdf_world2 <-    ne_load( scale = 110, type = 'countries' )
#' 
#' #download followed by load from specified directory will work across sessions
#' #spdf_world <- ne_download( scale = 110, type = 'countries', destdir = getwd() )
#' #spdf_world2 <-    ne_load( scale = 110, type = 'countries', destdir = getwd() )
#' 
#' @return A \code{Spatial} object depending on the vector source (points, lines or polygons), 
#'    unless load=FALSE in which case it returns the name of the downloaded shapefile (without extension).
#' @export

ne_download <- function(scale = 110,
                        type = 'countries',
                        category = c('cultural', 'physical', 'raster'),
                        destdir = tempdir(),
                        load = TRUE
                        ) 
{
  
  category <- match.arg(category)
  
  #without extension, e.g. .shp
  file_name <- ne_file_name(scale=scale, type=type, category=category, full_url=FALSE)
  #full url including .zip
  address   <- ne_file_name(scale=scale, type=type, category=category, full_url=TRUE)  

# this moved into ne_file_name    
#   address <- paste0('http://www.naturalearthdata.com/http//',
#                     'www.naturalearthdata.com/download/',scale,'m/',category,'/',
#                     file_name,'.zip' )
  
  
  #downloads the zip to a permanent place (but do I want to keep the zip, or just keep the unzipped)
  #download.file(file.path(address), zip_file <- file.path(getwd(), paste0(file_name,".zip"))
  #this puts zip in temporary place & unzipped files are saved later                
  download.file(file.path(address), zip_file <- tempfile())
                  
  
  #allowing caching as suggested by Hadley
  #ne_download() download & load (+option to not load)
  #ne_load() load previous download using same args or filename 
  
  #download.file & curl_download use 'destfile'
  #but I want to specify just the folder because the file has a set name
  
  #destdir = tempdir() #default
  #destdir=[specified_folder]  
  #destdir = getwd() #unlikely but possible


  
  if ( load )
  {
    unzip(zip_file, exdir=destdir)
    
    sp_object <- readOGR(destdir, file_name, encoding='UTF-8')
    
    return(sp_object) 
    
  } else
  {
    return(file_name)
  }

  
}