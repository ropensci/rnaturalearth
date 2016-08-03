#' return a natural earth filename based on arguments
#'
#' returns a string that can then be used to download the file.
#' 
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{10} or \code{'small'}, \code{'medium'}, \code{'large'}
#' @param type type of natural earth file to download one of 'countries', 'map_units', 'map_subunits', 'sovereignty', 'states'
#'    OR the portion of any natural earth vector url after the scale and before the . 
#'    e.g. for 'ne_50m_urban_areas.zip' this would be 'urban_areas'
#' @param category one of natural earth categories : 'cultural', 'physical', 'raster'
#' @param full_url whether to return just the filename [default] or the full URL needed for download

#' @examples
#' ne_name <- ne_file_name( scale = 110, type = 'countries' )
#' ne_url  <- ne_file_name( scale = 110, type = 'countries', full_url = TRUE )
#' 
#' @return string
#' @export

ne_file_name <- function(scale = 110,
                    type = 'countries',
                    category = c('cultural', 'physical', 'raster'),
                    full_url = FALSE
) 
{
  
  # check on permitted scales, convert names to numeric
  scale <- check_scale(scale)
  
  # check permitted category
  category <- match.arg(category) 
  
  # check type against lists in package to warn user if they try something
  # that seems not to exist
  # however continue to try the download to give user flexibility
  # to get something I may have missed out of my list or has been added more recently
  check_data_exist( scale = scale, category = category, type = type )
  

  # add admin_0 to known types
  if ( type %in% c('countries', 'map_units', 'map_subunits', 'sovereignty', 'tiny_countries',
                   'boundary_lines_land', 
                   'pacific_groupings', 
                   'breakaway_disputed_areas',
                   'boundary_lines_disputed_areas',
                   'boundary_lines_maritime_indicator') )
  {
    type <- paste0('admin_0_',type)    
  }

  
  # add admin_1 to known types
  # this actually just expands 'states' to the name including lakes
  if (type == 'states')
    type <- 'admin_1_states_provinces_lakes'

 
  if (category=='raster')
  {
    # raster seems not to have so straightforward naming, so require that name is passed in type
    file_name <- paste0(type)
  } else {
    file_name <- paste0('ne_',scale,'m_',type)
  }

  
  if (full_url)
    file_name <- paste0('http://www.naturalearthdata.com/http//',
                      'www.naturalearthdata.com/download/',scale,'m/',category,'/',
                      file_name,'.zip' )
  
  return(file_name)
  
}