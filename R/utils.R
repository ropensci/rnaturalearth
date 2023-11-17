read_spatial <- function(x, returnclass = c("sf", "sv")) {
  returnclass <- match.arg(returnclass)
  switch(returnclass,
    "sf" = sf::st_read(x),
    "sv" = terra::vect(x)
  )
}

#' Convert from/to sf/sv objects
#'
#' @inherit ne_download
#' @param x Object to be converted
#' @return Object of class "sf" or "sv"
convert_spatial_class <- function(x, returnclass = c("sf", "sv")) {
  returnclass <- match.arg(returnclass)
  switch(returnclass,
    "sf" = sf::st_as_sf(x),
    "sv" = terra::vect(x)
  )
}
