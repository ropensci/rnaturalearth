#' Download data from Natural Earth and (optionally) read into R
#'
#' returns downloaded data as a spatial object or the filename if
#' \code{load=FALSE}. if \code{destdir} is specified the data can be reloaded in
#' a later R session using \code{\link{ne_load}} with the same arguments.
#'
#' @param scale The scale of map to return, one of `110`, `50`, `10` or `small`,
#' `medium`, `large`.
#'
#' @param type type of natural earth file to download one of 'countries',
#' 'map_units', 'map_subunits', 'sovereignty', 'states' OR the portion of any
#' natural earth vector url after the scale and before the . e.g. for
#' 'ne_50m_urban_areas.zip' this would be 'urban_areas'. See Details. OR the
#' raster filename e.g. for 'MSR_50M.zip' this would be 'MSR_50M'
#'
#' @param category one of natural earth categories : 'cultural', 'physical',
#' 'raster'
#'
#' @param destdir where to save files, defaults to \code{tempdir()},
#' \code{getwd()} is also possible.
#'
#' @param load `TRUE` load the spatial object into R, `FALSE` return the
#' filename of the downloaded object.
#'
#' @details Note that the filename of the requested object will be returned if
#' `load = FALSE`.
#'
#' @seealso \code{\link{ne_load}}, pre-downloaded data are available using
#'   \code{\link{ne_countries}}, \code{\link{ne_states}}. Other geographic data
#'   are available in the raster package : \code{\link[raster]{getData}}.
#'
#' @param returnclass A string determining the spatial object to return. Either
#' "sf" for for simple feature (from `sf`, the default) or "sv" for a
#' `SpatVector` (from `terra`).
#'
#' @return An object of class `sf` for simple feature (from `sf`, the default)
#' or `SpatVector` (from `terra`).
#'
#' @examples \dontrun{
#' spdf_world <- ne_download(scale = 110, type = "countries")
#'
#' plot(spdf_world)
#' plot(ne_download(type = "populated_places"))
#'
#' # reloading from the saved file in the same session with same arguments
#'
#' spdf_world2 <- ne_load(scale = 110, type = "countries")
#'
#' # download followed by load from specified directory will work across sessions
#' spdf_world <- ne_download(scale = 110, type = "countries", destdir = getwd())
#' spdf_world2 <- ne_load(scale = 110, type = "countries", destdir = getwd())
#'
#' # for raster, here an example with Manual Shaded Relief (MSR) download & load
#'
#' rst <- ne_download(scale = 50, type = "MSR_50M", category = "raster", destdir = getwd())
#'
#' # load after having downloaded
#' rst <- ne_load(
#'   scale = 50, type = "MSR_50M", category = "raster", destdir =
#'     getwd()
#' )
#'
#' # plot
#' library(terra)
#' terra::plot(rst)
#' # end dontrun
#' }
#'
#' @export
ne_download <- function(
  scale = 110L,
  type = "countries",
  category = c("cultural", "physical", "raster"),
  destdir = tempdir(),
  load = TRUE,
  returnclass = c("sf", "sv")
) {
  category <- match.arg(category)
  returnclass <- match.arg(returnclass)

  warn <- returnclass == "sp" & load & category == "raster"

  if (warn) {
    deprecate_sp("ne_download(returnclass = 'sp')")
  }

  # without extension, e.g. .shp
  file_name <- ne_file_name(
    scale = scale,
    type = type,
    category = category,
    full_url = FALSE
  )

  # full url including .zip
  address <- ne_file_name(
    scale = scale,
    type = type,
    category = category,
    full_url = TRUE
  )

  # download zip to temporary location, unzipped files are saved later
  # tryCatch catches error, returns NUll if no error

  download_failed <- tryCatch(
    utils::download.file(file.path(address), zip_file <- tempfile()),
    error = function(e) {
      message(paste("download failed"))
      # check type against lists in package to warn user if it has failed
      check_data_exist(scale = scale, category = category, type = type)
      return(TRUE)
    }
  )

  # return from this function if download error was caught by tryCatch
  if (download_failed) {
    return()
  }

  # download.file & curl_download use 'destfile'
  # but I want to specify just the folder because the file has a set name

  utils::unzip(zip_file, exdir = destdir)

  if (load && category == "raster") {
    # have to use file_name to set the folder and the tif name
    filename <- file.path(destdir, file_name, paste0(file_name, ".tif"))
    rst <- terra::rast(filename)
    return(rst)
  } else if (load) {
    # read in data as either sf of spatvector
    spatial_object <- read_spatial(
      paste0(destdir, "/", file_name, ".shp"),
      returnclass
    )
    return(spatial_object)
  } else {
    file_name <- switch(
      category,
      "raster" = file.path(destdir, file_name, paste0(file_name, ".tif")),
      file.path(destdir, paste0(file_name, ".shp"))
    )
    return(file_name)
  }
}
