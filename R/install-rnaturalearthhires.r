#' Check whether to install rnaturalearthhires and install if necessary
#'
#' If the rnaturalearthhires package is not installed, install it from GitHub using
#' devtools. If it is not up to date, reinstall it.
#' @export
check_rnaturalearthhires <- function() {
  rnaturalearthhires_version <- "0.0.0.9000"
  if (!requireNamespace("rnaturalearthhires", quietly = TRUE)) {
    message("The rnaturalearthhires package needs to be installed.")
    install_rnaturalearthhires()
  } else if (utils::packageVersion("rnaturalearthhires") < rnaturalearthhires_version) {
    message("The rnaturalearthhires package needs to be updated.")
    install_rnaturalearthhires()
  }
}

#' Install the naturalearthhires package after checking with the user
#' @export
install_rnaturalearthhires <- function() {
  instructions <- paste(" Please try installing the package for yourself",
                        "using the following command: \n",
                        "    devtools::install_github(\"ropensci/rnaturalearthhires\")")
  
  error_func <- function(e) {
    stop(paste("Failed to install the rnaturalearthhires package.\n", instructions))
  }
  
  #23/2/17 changed to try install if not interactive to avoid winbuilder warning
  input <- 1
  if (interactive()) {
    input <- utils::menu(c("Yes", "No"),
                         title = "Install the rnaturalearthhires package?")
  }
  
  if (input == 1) {
      message("Installing the rnaturalearthhires package.")
      tryCatch(#utils::install.packages("rnaturalearthhires",
               #                        repos = "http://packages.ropensci.org",
               #                       type = "source"),
               devtools::install_github("ropensci/rnaturalearthhires"),
               error = error_func, warning = error_func)
    } else {
      stop(paste("The rnaturalearthhires package is necessary for that method.\n",
                 instructions))
    }
  
  #} else {
  #   stop(paste("Failed to install the rnaturalearthhires package.\n", instructions))
  # }
}
