#' coerce return object to sf if option set 
#'
#' @param x scale of map to return, one of \code{110}, \code{50}, \code{10} or \code{'small'}, \code{'medium'}, \code{'large'}
#' @param returnclass 'sp' default or 'sf' for Simple Features
#' 
# @examples
# ne_as_sf(x,'sf')
#' #not exported
#' 
#' @return an sf or sp object

ne_as_sf <- function(x, returnclass = c('sp','sf')) {
 
  returnclass <- match.arg(returnclass)   

  if (returnclass == 'sf')
    sf::st_as_sf( x )
  else
    x  
}