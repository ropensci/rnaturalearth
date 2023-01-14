#' check whether the requested data exist on Natural Earth
#'
#' checks from a list dependent on type, category and scale. If it returns FALSE the data may still exist on the website.
#' Doesn't yet do checking on raster names because I found the naming convention too tricky.
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{10} or \code{'small'}, \code{'medium'}, \code{'large'}
#'
#' @param type type of natural earth file to download one of 'countries', 'map_units', 'map_subunits', 'sovereignty', 'states'
#'    OR the portion of any natural earth vector url after the scale and before the .
#'    e.g. for 'ne_50m_urban_areas.zip' this would be 'urban_areas'
#'    OR the raster filename e.g. for 'MSR_50M.zip' this would be 'MSR_50M'
#'
#' @param category one of natural earth categories : 'cultural', 'physical', 'raster'

#' @examples
#' check_data_exist(scale = 110, category = "cultural", type = "countries")
#'
#' # type not in list for this category
#' check_data_exist(scale = 110, category = "physical", type = "airports")
#'
#' # type in list but scale shows FALSE
#' check_data_exist(scale = 110, category = "cultural", type = "airports")
#'
#' @return TRUE or FALSE
#'
#' @export

check_data_exist <- function(scale = 110,
                             type,
                             category = c("cultural", "physical", "raster")) {
  # check permitted category
  category <- match.arg(category)

  # todo doesn't yet check raster
  # I would need to create a data_list_raster.csv file
  if (category == "raster") {
    return(TRUE)
  }

  # check on permitted scales, convert names to numeric
  scale <- check_scale(scale)


  df_data <- read.csv(system.file("extdata", paste0("data_list_", category, ".csv"), package = "rnaturalearth"))


  # first check if type is within the list
  if (!type %in% df_data$type) {
    warning(type, " seems not to be in the list for category=", category, " maybe try the other category of c('cultural', 'physical')")
    return(FALSE)
  }

  # df_data[df_data$type=='roads', 'scale110']

  exist <- df_data[df_data$type == type, paste0("scale", scale)]


  if (!exist) {
    warning(
      "your combination of type, category, scale",
      " seem not to exist in the list of Natural Earth data.",
      " Check ?ne_download or http://www.naturalearthdata.com/features/ to see data availability."
    )
  }

  return(exist)
}
