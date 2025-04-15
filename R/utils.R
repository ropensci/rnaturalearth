#' Read Spatial Vector
#'
#' This function reads a spatial vector file and returns either an `sf` object
#' or a `sv` object.
#'
#' @param x A character string specifying the path to the spatial vector file.
#' @param returnclass A character string specifying the class of object to
#' return. Options are "sf" for sf object and "sv" for sv object.
#' @param layer A character string specifying the later to read in case there
#' are more than one in the zip file.
#'
#' @return Either an `sf` object or a `sv` object.
read_spatial_vector <- function(x, layer, returnclass = c("sf", "sv")) {
  returnclass <- match.arg(returnclass)
  switch(
    returnclass,
    sf = sf::read_sf(x, layer = layer),
    sv = terra::vect(x, layer = layer)
  )
}

#' Convert from/to sf/sv objects
#'
#' @inherit ne_download
#' @param x Object to be converted
#' @return Object of class "sf" or "sv"
convert_spatial_class <- function(x, returnclass = c("sf", "sv")) {
  returnclass <- match.arg(returnclass)
  switch(returnclass, sf = sf::st_as_sf(x), sv = terra::vect(x))
}

#' @title Extracts the http URL from a VSIZIP URL
#' @description This function takes a VSIZIP URL and extracts the http URL from
#' it
#' @param url A character string representing the VSIZIP URL
#' @return A character string representing the http URL extracted from the
#' VSIZIP URL
sanitize_gdal_url <- function(url) {
  url <- sub("^/vsizip//vsicurl/", "", url)
  sub("(.+\\.zip)/.*", "\\1", url)
}

#' Create Destination File Path
#'
#' @description Creates a destination file path by combining the directory path
#' with a formatted filename based on the GDAL URL and category.
#'
#' @param gdal_url A character string representing the GDAL URL
#' @param category A character string specifying the data category ("raster" or other)
#' @param destdir A character string specifying the destination directory
#'
#' @return A character string representing the complete destination file path
make_dest_path <- function(gdal_url, category, destdir) {
  file.path(
    destdir,
    sprintf(
      "%s.%s",
      tools::file_path_sans_ext(basename(gdal_url)),
      ifelse(category == "raster", "tif", "gpkg")
    )
  )
}
