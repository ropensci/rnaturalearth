#' rnaturalearth : world vector maps from Natural Earth
#'
#' Facilitates world mapping by making \href{http://www.naturalearthdata.com/}{Natural Earth} map data more easily available to R users. Focuses on vector data.
#'
#' @name rnaturalearth
#' @docType package
#' @seealso world_countries
#' @import sp rgdal
#rgdal is needed for ne_download but we may want to put that in a separate package ?
NULL

# Hide variables from R CMD check
if (getRversion() >= "2.15.1") {
  utils::globalVariables(c("countries110", "countries50", "map_units110", "sovereignty110"))
}