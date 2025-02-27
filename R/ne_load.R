#' load a Natural Earth vector that has already been downloaded to R using
#' \code{\link{ne_download}}
#'
#' returns loaded data as a spatial object.
#'
#' @inherit ne_download
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
#' @seealso \code{\link{ne_download}}
#'
#' @examples \dontrun{
#' # download followed by load from tempdir() works in same R session
#' spdf_world <- ne_download(scale = 110, type = "countries")
#' spdf_world2 <- ne_load(scale = 110, type = "countries")
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
#' library(terra)
#' plot(rst)
#' # end dontrun
#' }
#'
#' @export
ne_load <- function(
  scale = 110L,
  type = "countries",
  category = c("cultural", "physical", "raster"),
  destdir = tempdir(),
  file_name = NULL,
  returnclass = c("sf", "sv")
) {
  category <- match.arg(category)

  returnclass <- match.arg(returnclass)

  if (returnclass == "sp") {
    deprecate_sp("ne_download(returnclass = 'sp')")
  }

  if (is.null(file_name)) {
    file_name <- ne_file_name(scale = scale, type = type, category = category)
  }

  error_msg <- "The file {.path {file_name}} seems not to exist in your local folder {.path {destdir}}. Did you download it using {.fn rnaturalearth::ne_download}?"

  if (category == "raster") {
    file_tif <- file.path(destdir, file_name, paste0(file_name, ".tif"))

    if (!file.exists(file_tif)) {
      cli::cli_abort(error_msg)
    }

    rst <- terra::rast(file_tif)

    return(rst)
  } else {
    # for shapefiles

    # add '.shp' for the exists test (it's not needed by readOGR)
    if (!file.exists(file.path(destdir, paste0(file_name, ".shp")))) {
      cli::cli_abort(error_msg)
    }

    # read in data as either sf of spatvector
    spatial_object <- read_spatial(
      paste0(destdir, "/", file_name, ".shp"),
      returnclass
    )

    return(spatial_object)
  }
}
