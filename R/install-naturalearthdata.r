#' Check whether to install rnaturalearthdata and install if necessary
#'
#' If the rnaturalearthdata package is not installed, install it from GitHub using
#' devtools. If it is not up to date, reinstall it.
#' @export
check_rnaturalearthdata <- function() {
  rnaturalearthdata_version <- "0.0.0.9000"
  if (!requireNamespace("rnaturalearthdata", quietly = TRUE)) {
    message("The rnaturalearthdata package needs to be installed.")
    install_rnaturalearthdata()
  } else if (utils::packageVersion("rnaturalearthdata") < rnaturalearthdata_version) {
    message("The rnaturalearthdata package needs to be updated.")
    install_rnaturalearthdata()
  }
}

#' Install the naturalearthdata package after checking with the user
#' @export
install_naturalearthdata <- function() {
  instructions <- paste(" Please try installing the package for yourself",
                        "using the following command: \n",
                        'devtools::install_github("AndySouth/rnaturalearthdata")' )
                        #"    install.packages(\"rnaturalearthdata\", repos = \"http://packages.ropensci.org\",",
                        #"type = \"source\")")
  
  error_func <- function(e) {
    stop(paste("Failed to install the rnaturalearthdata package.\n", instructions))
  }
  
  if (interactive()) {
    input <- utils::menu(c("Yes", "No"),
                         title = "Install the rnaturalearthdata package?")
    if (input == 1) {
      message("Installing the rnaturalearthdata package.")
      tryCatch(#utils::install.packages("rnaturalearthdata",
               #                        repos = "http://packages.ropensci.org",
               #                        type = "source"),
               devtools::install_github("AndySouth/rnaturalearthdata"),
               error = error_func, warning = error_func)
    } else {
      stop(paste("The rnaturalearthdata package is necessary for that method.\n",
                 instructions))
    }
  } else {
    stop(paste("Failed to install the rnaturalearthdata package.\n", instructions))
  }
}