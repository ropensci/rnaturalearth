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
#' @param load `TRUE` to load the spatial object into R, `FALSE` to return the
#' filename of the downloaded object. If the requested object is a vector, it
#' will be saved as a GPKG file. If a raster is requested, it will be saved as
#' a GeoTIFF file.
#'
#' @details Note that the filename of the requested object will be returned if
#' `load = FALSE`.
#'
#' @details
#' If the data is to be loaded into memory (`load = TRUE`), the download will
#' be handled using the GDAL virtual file system, allowing direct access to the
#' data without writing it to disk.
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
#'   scale = 50, type = "MSR_50M", category = "raster", destdir = getwd()
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

  if (!dir.exists(destdir)) {
    cli::cli_abort("{.arg destdir} must be an existing directory")
  }
  warn <- returnclass == "sp" & load & category == "raster"

  if (warn) {
    deprecate_sp("ne_download(returnclass = 'sp')")
  }

  scale <- check_scale(scale)

  gdal_url <- ne_file_name(
    scale = scale,
    type = type,
    category = category
  )

  cli::cli_inform("Reading {.file {basename(gdal_url)}} from naturalearth...")

  if (category == "raster") {
    rst <- terra::rast(gdal_url)
    if (load) return(rst)
  } else {
    layer <- layer_name(type, scale)
    spatial_object <- read_spatial_vector(
      gdal_url,
      layer = layer,
      returnclass = returnclass
    )
    if (load) return(spatial_object)
  }

  dest_file <- file.path(
    destdir,
    sprintf(
      "%s.%s",
      tools::file_path_sans_ext(basename(gdal_url)),
      ifelse(category == "raster", "tif", "gpkg")
    )
  )

  cli::cli_inform(
    "Writing {.file {basename(dest_file)}} to {.path {destdir}}..."
  )

  if (category == "raster") {
    terra::writeRaster(
      rst,
      dest_file,
      overwrite = TRUE,
      gdal = c(
        "COMPRESS=ZSTD",
        "PREDICTOR=2",
        "TILED=YES",
        "TFW=NO",
        "BLOCKXSIZE=256",
        "BLOCKYSIZE=256"
      )
    )
  } else if (returnclass == "sf") {
    sf::write_sf(spatial_object, dest_file, delete_dsn = TRUE)
  } else {
    terra::writeVector(spatial_object, dest_file, overwrite = TRUE)
  }

  return(dest_file)
}
