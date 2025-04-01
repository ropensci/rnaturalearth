#' Return a dataframe of available vector layers on Natural Earth
#'
#' Checks the Natural Earth Github repository for current vector layers and
#' provides the file name required in the type argument of ne_download.
#'
#' @inherit ne_download
#'
#' @param category one of natural earth categories : 'cultural', 'physical'
#'
#' @param getmeta whether to get url of the metadata for each layer
#'
#' @return dataframe with two variables: layer and metadata
#'
#' @export
#'
#' @examples \dontrun{
#' ne_find_vector_data(scale = 10, category = "physical")
#' }
ne_find_vector_data <- function(
  scale = 110L,
  category = c("cultural", "physical"),
  getmeta = FALSE
) {
  ## check permitted category (no way to check against available rasters)
  category <- match.arg(category)

  ## check on permitted scales, convert names to numeric
  scale <- check_scale(scale)

  ## Available paths include: 10m_cultural, 10m_physical,
  ## 50m_cultural, etc...

  # scale has already been checked in check_scale, and category in match.arg
  path <- paste0(scale, "m_", category)

  ## call to ne_git_contents returns a list with contents of
  ## github directory (based on specified path), github api
  ## response, and http path.

  resp <- ne_git_contents(path = path)

  ## call to git layer names returns a list of lists with
  ## valid layer names and metadata link

  layers <- ne_git_layer_names(x = resp, scale = scale, getmeta = getmeta)

  ## I think returning as a data.frame makes the most sense

  if (getmeta) {
    layers <- data.frame(
      layer = layers[["layer"]],
      scale = scale,
      metadata = layers[["metalink"]]
    )
  } else {
    layers <- data.frame(
      layer = layers[["layer"]],
      scale = scale
    )
  }

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
#'
#' @keywords internal
ne_git_contents <- function(path) {
  ## create pathnames to natural earth vector folders on github use httr::GET
  ## and the github api to access the github contents API. Note that this is
  ## rate limited, so someone could get locked. Probably don't want to include
  ## this in CRAN tests.

  path <- paste0("/repos/nvkelso/natural-earth-vector/contents/", path)
  url <- httr::modify_url("https://api.github.com", path = path)
  ua <- httr::user_agent("http://github.com/ropensci/rnaturalearth")
  resp <- httr::GET(url, ua)

  if (httr::http_type(resp) != "application/json") {
    cli::cli_abort("API did not return json")
  }

  df <- httr::content(x = resp, as = "text", encoding = "UTF-8")
  df <- jsonlite::fromJSON(df)

  if (httr::status_code(resp) != 200L) {
    cli::cli_abort(
      sprintf(
        "GitHub API request failed [%s]\n%s\n<%s>",
        httr::status_code(resp),
        df[["message"]],
        df[["documentation_url"]]
      )
    )
  }

  structure(
    list(
      content = df,
      path = path,
      response = resp
    )
  )
}


#' Create list of layer names and metadata links
#'
#' Parses Natural Earth Github folder content for layer names and metadata
#' links.
#'
#' @param x object returned by ne_git_contents
#'
#' @param scale one of \code{110}, \code{50}, \code{10}
#'
#' @param getmeta whether to get url of the metadata for each layer
#'
#' @return list of lists with layer names and metadata links.

#' @keywords internal
ne_git_layer_names <- function(x, scale, getmeta) {
  ## uses the output from ne_git_contents
  ## creates a list of available layer names and
  ## list of metadata links

  if (httr::status_code(x$response) != 200L) {
    cli::cli_abort(
      sprintf(
        "GitHub API request failed [%s]\n%s\n<%s>",
        httr::status_code(x$response),
        x$content$message,
        x$content$documentation_url
      )
    )
  }

  ## Create the pattern that matches the prefix that should be removed
  prefix <- paste0("ne_", scale, "m_")

  ## clean and return layer names
  l <- x$content
  # gets just readme because 1 per layer
  l <- regmatches(l$name, regexpr("^(.*).README.html", l$name))
  # cuts off parts of filenames to get just the layer name
  l <- gsub(".README.html", "", l)
  l <- gsub(prefix, "", l)

  # if we didn't need links to metadata then this function could stop here
  if (!getmeta) {
    ## return a list with just layer name
    return(structure(list(layer = l)))
  }

  ## clean and return links to the metadata on NaturalEarthData.com
  m <- x$content$download_url
  m <- regmatches(m, regexpr("^(.*).README.html", m))

  findlinks <- function(x) {
    page <- httr::content(httr::GET(x))
    link <- regmatches(
      page,
      regexpr(
        '<link rel="canonical" href=(.*?)/>',
        page
      )
    )
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
  structure(list(layer = l, metalink = m))
}
