#' Check whether to install rnaturalearthhires and install if necessary
#'
#' If the rnaturalearthhires package is not installed, install it from GitHub
#' using pak. If it is not up to date, reinstall it.
#'
#' @export
check_rnaturalearthhires <- function() {
  # TODO: This should be done dynamically by checking the version on Github
  rnaturalearthhires_version <- "1.0.0.9000"

  if (!requireNamespace("rnaturalearthhires", quietly = TRUE)) {
    cli::cli_inform(
      "The {.pkg rnaturalearthhires} package needs to be installed."
    )
    install_rnaturalearthhires()
  } else if (
    utils::packageVersion("rnaturalearthhires") < rnaturalearthhires_version
  ) {
    cli::cli_inform(
      "The {.pkg rnaturalearthhires} package needs to be updated."
    )
    install_rnaturalearthhires()
  }
}

#' Install the naturalearthhires package after checking with the user
#' @export
install_rnaturalearthhires <- function() {
  input <- 1L

  if (interactive()) {
    input <- utils::menu(
      c("Yes", "No"),
      title = "Install the rnaturalearthhires package?"
    )
  }

  if (input != 1L) {
    cli::cli_abort(
      "The {.pkg rnaturalearthhires} package is necessary for that method.\n Please try installing the package yourself with {.code pak::pkg_install(\"ropensci/rnaturalearthhires\")}"
    )
  }

  cli::cli_inform("Installing the {.pkg rnaturalearthhires} package.")

  tryCatch(
    pak::pkg_install("ropensci/rnaturalearthhires"),
    error = function(e) {
      cli::cli_inform(conditionMessage(e))
    }
  )
}
