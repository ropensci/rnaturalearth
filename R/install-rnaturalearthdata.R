#' Check whether to install rnaturalearthdata and install if necessary
#'
#' If the rnaturalearthdata package is not installed, install it from GitHub
#' using devtools. If it is not up to date, reinstall it.
#'
#' @export
check_rnaturalearthdata <- function() {
  rnaturalearthdata_version <- "0.0.0.9000"
  if (!requireNamespace("rnaturalearthdata", quietly = TRUE)) {
    cli::cli_inform(
      "The {.pkg rnaturalearthdata} package needs to be installed."
    )
    install_rnaturalearthdata()
  } else if (
    utils::packageVersion("rnaturalearthdata") < rnaturalearthdata_version
  ) {
    cli::cli_inform("The {.pkg rnaturalearthdata} package needs to be updated.")
    install_rnaturalearthdata()
  }
}

#' Install the naturalearthdata package after checking with the user
#' @export
install_rnaturalearthdata <- function() {
  error_func <- function(e) {
    cli::cli_abort(
      "Failed to install the {.pkg rnaturalearthdata} package.\nPlease try installing the package for yourself using the following command: {.code install.packages(\"rnaturalearthdata\")}"
    )
  }

  # 23/2/17 changed to try install if not interactive to avoid winbuilder
  # warning
  input <- 1L
  if (interactive()) {
    input <- utils::menu(
      c("Yes", "No"),
      title = "Install the rnaturalearthdata package?"
    )
  }

  if (input == 1L) {
    cli::cli_inform("Installing the {.pkg rnaturalearthdata} package.")
    tryCatch(
      utils::install.packages(
        "rnaturalearthdata",
        repos = c("http://packages.ropensci.org", "http://cran.rstudio.com"),
        type = "source"
      ),
      error = error_func,
      warning = error_func
    )
  } else {
    cli::cli_abort(
      "The {.pkg rnaturalearthdata} package is necessary for that method."
    )
  }
}
