#' rnaturalearth : world map data from Natural Earth
#'
#' Facilitates world mapping by making
#' \href{https://www.naturalearthdata.com/}{Natural Earth} map data more easily
#' available to R users.
#'
#' @name rnaturalearth

#' @docType package

#' @seealso \code{\link{ne_countries}} \code{\link{ne_states}}
#' \code{\link{ne_download}}

#' @import sp utils sf
NULL

# Hide variables from R CMD check
if (getRversion() >= "2.15.1") {
  utils::globalVariables(c("countries110"))
}
