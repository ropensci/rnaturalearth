#' check that this scale is present in Natural Earth
#'
#' check name or numeric scale representations, return numeric one
#'
#' @param x scale of map to return, one of \code{110}, \code{50}, \code{10} or
#' \code{'small'}, \code{'medium'}, \code{'large'}
#'
#' @return integer scale of map
check_scale <- function(x) {
  if (is.numeric(x) && length(x) == 1L) {
    if (x %in% c(110L, 50L, 10L)) {
      return(x)
    }
  } else if (is.character(x) && length(x) == 1L) {
    xnew <- c(small = 110L, medium = 50L, large = 10L)[tolower(x)]

    if (!is.na(xnew)) {
      return(unname(xnew))
    }
  }

  cli::cli_abort(
    "Invalid {.arg scale} argument. Must be one of {.val [110, 50, 10, 'small', 'medium', 'large']} you provided : {.val {x}}."
  )
}
