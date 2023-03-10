#' load a Natural Earth vector that has already been downloaded to R using
#' \code{\link{ne_download}}
#'
#' returns loaded data as a spatial object.
#'
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{10}
#' or \code{'small'}, \code{'medium'}, \code{'large'}
#'
#' @param type type of natural earth file one of 'countries', 'map_units',
#'    'map_subunits', 'sovereignty', 'states' OR the portion of any natural
#'    earth vector url after the scale and before the . e.g. for
#'    'ne_50m_urban_areas.zip' this would be 'urban_areas' OR the raster
#'    filename e.g. for 'MSR_50M.zip' this would be 'MSR_50M'
#'
#' @param category one of natural earth categories : 'cultural', 'physical',
#' 'raster'
#'
#' @param destdir folder to load files from, default=tempdir()
#'
#' @param file_name OPTIONAL name of file (excluding path) instead of natural
#' earth attributes
#'
#' @param returnclass 'sp' default or 'sf' for Simple Features
#'
#' @seealso \code{\link{ne_download}}
#'
#' @examples \dontrun{
#' # download followed by load from tempdir() works in same R session
#' spdf_world <- ne_download(scale = 110, type = "countries") 
#' spdf_world2 <-ne_load(scale = 110, type = "countries")
#'
#' # download followed by load from specified directory works between R sessions
#' spdf_world <- ne_download(scale = 110, type = "countries", destdir = getwd())
#' spdf_world2 <- ne_load(scale = 110, type = "countries", destdir = getwd())
#'
#' # for raster download & load
#' rst <- ne_download(scale = 50, type = "OB_50M", category = "raster", destdir = getwd())
#'
#' # load after having downloaded
#' rst <- ne_load(scale = 50, type = "OB_50M", category = "raster", destdir = getwd())
#'
#' # plot
#' library(terra) plot(rst)
#' # end dontrun
#' }
#'
#' @return A \code{Spatial} object depending on the data (points, lines,
#' polygons or raster).
#'
#' @export
ne_load <- function(scale = 110,
                    type = "countries",
                    category = c("cultural", "physical", "raster"),
                    destdir = tempdir(),
                    file_name = NULL,
                    returnclass = c("sp", "sf")) {
  category <- match.arg(category)
  returnclass <- match.arg(returnclass)

  if (is.null(file_name)) {
    file_name <- ne_file_name(scale = scale, type = type, category = category)
  }


  error_msg <- paste0(
    "the file ",
     file_name, " seems not to exist in your local folder ",
     destdir,
    "\nDid you download it using ne_download()?"
  )

  if (category == "raster") {
    file_tif <- file.path(destdir, file_name, paste0(file_name, ".tif"))

    if (!file.exists(file_tif)) {
      stop(error_msg)
    }

    rst <- terra::rast(file_tif)

    return(rst)
  } else { # for shapefiles

    # add '.shp' for the exists test (it's not needed by readOGR)
    if (!file.exists(file.path(destdir, paste0(file_name, ".shp")))) {
      stop(error_msg)
    }

    # read in data as sf object
    sf_object <- sf::read_sf(destdir, file_name)

    # convert to sp if chosen
    return(ne_as_sp(sf_object, returnclass))
  }
}
