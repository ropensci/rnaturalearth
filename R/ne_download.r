#' download data from Natural Earth and (optionally) read into R
#'
#' returns downloaded data as a spatial object or the filename if \code{load=FALSE}.  
#' if \code{destdir} is specified the data can be reloaded in a later R session using \code{\link{ne_load}}
#' with the same arguments.
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{10} or \code{'small'}, \code{'medium'}, \code{'large'}
#' @param type type of natural earth file to download one of 'countries', 'map_units', 'map_subunits', 'sovereignty', 'states'
#'    OR the portion of any natural earth vector url after the scale and before the . 
#'    e.g. for 'ne_50m_urban_areas.zip' this would be 'urban_areas'. See Details.
#'    OR the raster filename e.g. for 'MSR_50M.zip' this would be 'MSR_50M'
#' @param category one of natural earth categories : 'cultural', 'physical', 'raster'
#' @param destdir where to save files, defaults to \code{tempdir()}, \code{getwd()} is also possible.
#' @param load TRUE/FALSE whether to load file into R and return
#' @param returnclass 'sp' default or 'sf' for Simple Features
#' 
#' @details A non-exhaustive list of datasets available according to \code{scale} specified by the \code{type} param 
#'   \tabular{lccc}{
#'          	                   \tab scale = 'small'	\tab scale = 'medium'	\tab scale = 'large' \cr
#'   category = 'physical', type = '[below]' \cr
#'   coastline	                 \tab y	        \tab y      	\tab y        \cr
#'   land     	                 \tab y	        \tab y      	\tab y        \cr
#'   ocean     	                 \tab y	        \tab y      	\tab y        \cr
#'   rivers_lake_centerlines     \tab y	        \tab y      	\tab y        \cr
#'   lakes     	                 \tab y	        \tab y      	\tab y        \cr 
#'   glaciated_areas     	       \tab y	        \tab y      	\tab y        \cr
#'   antarctic_ice_shelves_polys \tab -	        \tab y      	\tab y        \cr
#'   geographic_lines            \tab y	        \tab y      	\tab y        \cr
#'   graticules_1     	         \tab y	        \tab y      	\tab y        \cr
#'   graticules_30     	         \tab y	        \tab y      	\tab y        \cr
#'   wgs84_bounding_box     	   \tab y	        \tab y      	\tab y        \cr
#'   playas     	               \tab -	        \tab y      	\tab y        \cr
#'   minor_islands      	       \tab -	        \tab -      	\tab y        \cr
#'   reefs              	       \tab -	        \tab -      	\tab y        \cr 
#'   category = 'cultural', type = '[below]'             \cr    
#'   populated_places        	   \tab y	        \tab y      	\tab y        \cr
#'   boundary_lines_land \tab y	        \tab y      	\tab y        \cr
#'   breakaway_disputed_areas \tab -	        \tab y      	\tab y        \cr
#'   airports              	     \tab -	        \tab y      	\tab y        \cr
#'   ports              	       \tab -	        \tab y      	\tab y        \cr
#'   urban_areas              	 \tab -	        \tab y      	\tab y        \cr
#'   roads              	       \tab -	        \tab -      	\tab y        \cr   
#'   railroads              	   \tab -	        \tab -      	\tab y        \cr       
#'   }
#' @seealso \code{\link{ne_load}}, pre-downloaded data are available using \code{\link{ne_countries}}, \code{\link{ne_states}}.
#' Other geographic data are available in the raster package : \code{\link[raster]{getData}}.
#' @examples
#' \dontrun{
#' spdf_world <- ne_download( scale = 110, type = 'countries' )
#' 
#' if (require(sp)) {
#'   plot(spdf_world)
#'   plot(ne_download(type = 'populated_places'))
#' }
#' 
#' # reloading from the saved file in the same session with same arguments
#' spdf_world2 <-    ne_load( scale = 110, type = 'countries' )
#' 
#' # download followed by load from specified directory will work across sessions
#' spdf_world <- ne_download( scale = 110, type = 'countries', destdir = getwd() )
#' spdf_world2 <-    ne_load( scale = 110, type = 'countries', destdir = getwd() )
#'
#' # for raster, here an example with Manual Shaded Relief (MSR)
#' # download & load
#' rst <- ne_download(scale = 50, type = 'MSR_50M', category = 'raster', destdir = getwd())
#' 
#' # load after having downloaded
#' rst <- ne_load(scale = 50, type = 'MSR_50M', category = 'raster', destdir = getwd())
#' 
#' # plot
#' library(raster)
#' raster::plot(rst)
#' } # end dontrun
#' @return A \code{Spatial} object depending on the data (points, lines, polygons or raster), 
#'    unless load=FALSE in which case it returns the name of the downloaded shapefile (without extension).
#' @export

ne_download <- function(scale = 110,
                        type = 'countries',
                        category = c('cultural', 'physical', 'raster'),
                        destdir = tempdir(),
                        load = TRUE,
                        returnclass = c('sp','sf')
                        ) 
{
  
  category <- match.arg(category)
  returnclass <- match.arg(returnclass)
  
  # without extension, e.g. .shp
  file_name <- ne_file_name(scale=scale, type=type, category=category, full_url=FALSE)
  # full url including .zip
  address   <- ne_file_name(scale=scale, type=type, category=category, full_url=TRUE)  
  
  # download zip to temporary location, unzipped files are saved later  
  # tryCatch catches error, returns NUll if no error

  download_failed <- tryCatch( utils::download.file(file.path(address), zip_file <- tempfile()),
     error = function(e) {
       message(paste('download failed'))
       # check type against lists in package to warn user if it has failed
       check_data_exist( scale = scale, category = category, type = type ) 
       return(TRUE)
     })
  
  #return from this function if download error was caught by tryCatch
  if (download_failed) return()
                  
  # an alternative downloading the zip to a permanent place
  # download.file(file.path(address), zip_file <- file.path(getwd(), paste0(file_name,'.zip'))
  
  # download.file & curl_download use 'destfile'
  # but I want to specify just the folder because the file has a set name

  utils::unzip(zip_file, exdir=destdir)
  
  if ( load & category == 'raster' )
  {
    # have to use file_name to set the folder and the tif name
    rst <- terra::rast(file.path(destdir, file_name, paste0(file_name, '.tif')))
    return(rst)
    
  } else if ( load )
  {
    #use_iconv=TRUE to avoid problems with non ASCII vars
    sp_object <- rgdal::readOGR(destdir, file_name, encoding='UTF-8', stringsAsFactors=FALSE, use_iconv=TRUE)
    
    #to convert any '-99' or '-099' to NA
    sp_object@data[sp_object@data=='-99' | sp_object@data=='-099'] <- NA
    
    # convert to sf if chosen
    return( ne_as_sf(sp_object, returnclass))
    
    
  } else
  {
    return(file_name)
  }

  
}
