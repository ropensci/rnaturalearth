#' check whether the requested data exist on Natural Earth
#'
#' checks from a list dependent on type, category and scale. If it returns FALSE
#' the data may still exist on the website. Doesn't yet do checking on raster
#' names because I found the naming convention too tricky.
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

#' @examples
#' check_data_exist(type = "countries", scale = 110, category = "cultural")
#'
#' # Type not in list for this category
#' check_data_exist(type = "airports", scale = 110, category = "physical")
#'
#' # Type in list but scale shows FALSE
#' check_data_exist(type = "airports", scale = 110, category = "cultural")
#'
#' @return TRUE or FALSE
#'
#' @export
check_data_exist <- function(
  type,
  scale = 110L,
  category = c("cultural", "physical", "raster")
) {
  # check permitted category
  category <- match.arg(category)

  # I would need to create a data_list_raster.csv file
  if (category == "raster") {
    return(TRUE)
  }

  # check on permitted scales, convert names to numeric
  scale <- check_scale(scale)

  df_data <- read.csv(
    system.file(
      "extdata",
      paste0("data_list_", category, ".csv"),
      package = "rnaturalearth"
    )
  )

  # first check if type is within the list
  if (!type %in% df_data$type) {
    cli::cli_warn(
      "{.arg {type}} seems not to be in the list for category= {.val {category}} maybe try the other category of c('cultural', 'physical')"
    )

    return(FALSE)
  }

  exist <- df_data[df_data[["type"]] == type, paste0("scale", scale)]

  if (!exist) {
    cli::cli_warn(
      "The requested daa seem not to exist in the list of Natural Earth data. Check {.code ?ne_download} or {.url http://www.naturalearthdata.com/features/} to see data availability."
    )
  }

  return(exist)
}
