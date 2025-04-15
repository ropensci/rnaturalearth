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
#' @param destdir folder to load files from, default = tempdir()
#'
#' @param file_name OPTIONAL name of file (excluding path) instead of natural
#' earth attributes
#'
#' @details This function should be used after first downloading the data with
#' \code{ne_download(load = FALSE)}. The downloaded file can then be loaded
#' using this function.
#'
#' @seealso \code{\link{ne_download}}
#'
#' @examples \dontrun{
#' # download followed by load from tempdir() works in same R session
#' spdf_world <- ne_download(
#'   scale = 110,
#'   type = "countries"
#' )
#' spdf_world2 <- ne_load(
#'   scale = 110,
#'   type = "countries"
#' )
#'
#' # download followed by load from specified directory works between R sessions
#' spdf_world <- ne_download(
#'   scale = 110,
#'   type = "countries",
#'   destdir = getwd()
#' )
#' spdf_world2 <- ne_load(
#'   scale = 110,
#'   type = "countries",
#'   destdir = getwd()
#' )
#'
#' # for raster download & load
#' rst <- ne_download(
#'   scale = 50,
#'   type = "OB_50M",
#'   category = "raster",
#'   destdir = getwd(),
#'   load = FALSE
#' )
#'
#' # load after having downloaded
#' rst <- ne_load(
#'   scale = 50,
#'   type = "OB_50M",
#'   category = "raster",
#'   destdir = getwd()
#' )
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
  scale <- check_scale(scale)

  if (returnclass == "sp") {
    deprecate_sp("ne_download(returnclass = 'sp')")
  }

  if (is.null(file_name)) {
    file_name <- ne_file_name(scale = scale, type = type, category = category)
  }

  spatial_file_path <- make_dest_path(file_name, category, destdir)

  error_msg <- "The file {.path {spatial_file_path}} seems not to exist in your local folder {.path {destdir}}. Did you download it using {.fn rnaturalearth::ne_download}?"

  if (!file.exists(spatial_file_path)) {
    cli::cli_abort(error_msg)
  }

  if (category == "raster") {
    rst <- terra::rast(spatial_file_path)

    return(rst)
  } else {
    layer <- layer_name(type, scale)

    # read in data as either sf of spatvector
    spatial_object <- read_spatial_vector(
      spatial_file_path,
      layer = layer,
      returnclass
    )

    return(spatial_object)
  }
}
