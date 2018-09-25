
#' Return a dataframe of available vector layers on Natural Earth
#'
#' Checks the Natural Earth Github repository for current vector layers and
#' provides the file name required in the type argument of ne_download.
#'
#' @param scale scale of map to return, one of \code{110}, \code{50}, \code{10} or \code{'small'}, \code{'medium'}, \code{'large'}
#' @param category one of natural earth categories : 'cultural', 'physical' 
#'
#' @return dataframe with two variables: layers and metadata
#' @export
#'
#' @examples
#' \dontrun{
#' find_vector_data(scale = 10, category = "physical")
#' }
find_vector_data <- function(scale = 110, 
                             category = c("cultural", "physical")) {
  
  ## check permitted category (no way to check against available rasters)
  category <- match.arg(category)
  
  ## check on permitted scales, convert names to numeric
  scale <- check_scale(scale)
  
  ## Available paths include: 10m_cultural, 10m_physical,
  ## 50m_cultural, etc...
  
  if (category == "cultural") {
    if (scale == 110) {
      path <- "110m_cultural"
    } else if (scale == 50) {
      path <- "50m_cultural"
    } else if (scale == 10) {
      path <- "10m_cultural"
    } else (stop("Incorrect scale specified, must be 110, 50, or 10"))
  }
  
  else if (category == "physical") {
    if (scale == 110) {
      path <- "110m_physical"
    } else if (scale == 50) {
      path <- "50m_physical"
    } else if (scale == 10) {
      path <- "10m_physical"
    } else (stop("Incorrect scale specified, must be 110, 50, or 10"))
  }
  
  else (stop("Incorrect category specified, must be 'physical' or 'cultural'"))
  
  ## call to git_contents returns a list with contents of
  ## github directory (based on specified path), github api
  ## response, and http path.
  
  resp <- git_contents(path = path)
  
  ## call to git layer names returns a list of lists with
  ## valid layer names and metadata link
  
  layers <- git_layer_names(x = resp, scale = scale)
  
  ## I think returning as a data.frame makes the most sense
  
  layers <- data.frame(
    layers = layers$layers,
    metadata = layers$metalink
  )
  
  return(layers)
  
}



#' Return contents of Natural Earth Github directory
#'
#' Uses the Github API to return contents of Natural Earth Github directories.
#' @param path string, one of: \code{'110m_physical'}, \code{'110m_cultural'},
#'   \code{'50m_physical'}, \code{'50m_cultural'}, \code{'10m_physical'},
#'   \code{'10m_cultural'}
#'
#' @return list. Includes parsed json content, http path, and response
#'   code.
#' @import httr
#' @importFrom jsonlite fromJSON
#' @export
#' @keywords internal
git_contents  <- function(path) {
  
  ## create pathnames to natural earth vector folders on github use httr::GET
  ## and the github api to access the github contents API. Note that this is
  ## rate limited, so someone could get locked. Probably don't want to include
  ## this in CRAN tests.
  
  path <- paste0("/repos/nvkelso/natural-earth-vector/contents/", path)
  url <- modify_url("https://api.github.com", path = path)
  ua <- user_agent("http://github.com/ropensci/rnaturalearth")
  resp <- GET(url, ua)
  
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  
  df <- content(x = resp, as = "text", encoding = "UTF-8")
  df <- jsonlite::fromJSON(df)
  
  if (status_code(resp) != 200) {
    stop(
      sprintf(
        "GitHub API request failed [%s]\n%s\n<%s>", 
        status_code(resp),
        df$message,
        df$documentation_url
      ),
      call. = FALSE
    )
  }
  
  structure(
    list(content = df,
         path = path,
         response = resp)
  )
}


#' Create list of layer names and metadata links
#'
#' Parses Natural Earth Github folder content for layer names and metadata
#' links.
#'
#' @param x object returned by git_contents
#' @param scale one of \code{110}, \code{50}, \code{10}
#'
#' @return list of lists with layer names and metadata links.
#' @export
#' @keywords internal
git_layer_names <- function(x, scale) {
  
  ## uses the output from git_contents
  ## creates a list of available layer names and
  ## list of metadata links
  
  if (status_code(x$response) != 200) {
    stop(
      sprintf(
        "GitHub API request failed [%s]\n%s\n<%s>", 
        status_code(resp),
        x$content$message,
        X$content$documentation_url
      ),
      call. = FALSE
    )
  }
  
  ## Create the pattern that matches the prefix that should be removed
  if (scale == 110) {
    (prefix <- "ne_110m_")
  } else if (scale == 50) {
    (prefix <- "ne_50m_")
  } else if (scale == 10) {
    (prefix <- "ne_10m_")
  } else (stop("Incorrect scale specified, must be 110, 50, or 10"))
  
  
  ## clean and return layer names
  l <- x$content
  l <- regmatches(l$name, regexpr("^(.*).README.html", l$name))
  l <- gsub(".README.html","", l)
  l <- gsub(prefix, "", l)
  
  ## clean and return links
  m <- x$content$download_url
  m <- regmatches(m, regexpr("^(.*).README.html", m))
  
  findlinks <- function(x) {
    page <- content(GET(x))
    link <- regmatches(page, regexpr('<link rel="canonical" href=(.*?)/>', page))
    link <- gsub("<link rel=\"canonical\" href=\"", "", link)
    link <- gsub("\" />", "", link)
  }
  
  
  ## iterate findlinks function through each html page to
  ## pull out the metadata link. Adding an optional status bar
  ## since downloads could stall.
  ## pbapply is suggested,
  ## if user doesn't have pbapply installed, lapply is used.
  m <- if (requireNamespace("pbapply", quietly = TRUE)) {
    pbapply::pblapply(m, findlinks)
  } else {
    lapply(m, findlinks)
  }
  
  m <- unlist(m)
  
  ## return a list with layer name and metadata link
  structure(
    list(layers = l,
         metalink = m)
  )
}