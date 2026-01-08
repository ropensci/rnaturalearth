#' return a natural earth filename based on arguments
#'
#' returns a string that can then be used to download the file.
#'
#' @inherit ne_download
#'
#' @param type type of natural earth file to download one of 'countries',
#'    'map_units', 'map_subunits', 'sovereignty', 'states' OR the portion of any
#'    natural earth vector url after the scale and before the . e.g. for
#'    'ne_50m_urban_areas.zip' this would be 'urban_areas' OR the raster
#'    filename e.g. for 'MSR_50M.zip' this would be 'MSR_50M'
#'
#' @param category one of natural earth categories : 'cultural', 'physical',
#' 'raster'
#'
#' @examples
#' ne_url <- ne_file_name(scale = 110, type = "countries")
#'
#' @return string
#'
#' @export
ne_file_name <- function(
  scale = 110L,
  type = "countries",
  category = c("cultural", "physical", "raster")
) {
  scale <- check_scale(scale)
  category <- match.arg(category)

  type <- normalize_type(type)

  base_url <- "/vsizip//vsicurl/https://naciscdn.org/naturalearth"

  # Construct the file path based on the data category
  gdal_url <- if (category == "raster") {
    file.path(
      base_url,
      sprintf("%sm", scale),
      category,
      sprintf("%s.zip", type),
      sprintf("%s.tif", type)
    )
  } else {
    file.path(
      base_url,
      sprintf("%sm", scale),
      category,
      sprintf("ne_%sm_%s.zip", scale, type)
    )
  }

  return(gdal_url)
}

#' Normalize the type argument for Natural Earth datasets
#'
#' This function standardizes the `type` argument by mapping common names to
#' their respective Natural Earth dataset names.
#'
#' @inheritParams ne_file_name
#'
#' @return A string representing the normalized dataset type.
normalize_type <- function(type) {
  if (
    type %in%
      c(
        "countries",
        "map_units",
        "map_subunits",
        "sovereignty",
        "tiny_countries",
        "boundary_lines_land",
        "pacific_groupings",
        "breakaway_disputed_areas",
        "boundary_lines_disputed_areas",
        "boundary_lines_maritime_indicator"
      )
  ) {
    return(paste0("admin_0_", type))
  }

  if (
    type %in%
      c(
        "parks_and_protected_lands_area",
        "parks_and_protected_lands_line",
        "parks_and_protected_lands_point",
        "parks_and_protected_lands_scale_rank"
      )
  ) {
    return("parks_and_protected_lands")
  }

  if (type == "states") {
    return("admin_1_states_provinces_lakes")
  }

  type
}

#' Generate the layer name for a Natural Earth dataset
#'
#' @inheritParams ne_file_name
#' @return A string representing the dataset layer name.
layer_name <- function(type, scale) {
  if (
    type %in%
      c(
        "countries",
        "map_units",
        "map_subunits",
        "sovereignty",
        "tiny_countries",
        "boundary_lines_land",
        "pacific_groupings",
        "breakaway_disputed_areas",
        "boundary_lines_disputed_areas",
        "boundary_lines_maritime_indicator"
      )
  ) {
    type <- paste0("admin_0_", type)
  }

  if (type == "states") {
    type <- "admin_1_states_provinces_lakes"
  }

  sprintf("ne_%sm_%s", scale, type)
}
