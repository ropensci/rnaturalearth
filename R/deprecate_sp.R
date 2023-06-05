rnaturalearth_env <- new.env(parent = emptyenv())

.onLoad <- function(...) {
  assign("rnaturalearth_update_message", FALSE, envir = rnaturalearth_env)
}

rnaturalearthStartupMessage <- function() {
  msg <- "Support for Spatial objects (`sp`) will be deprecated in {rnaturalearth} and will be removed in a future release of the package. Please use `sf` objects with {rnaturalearth}. For example: `ne_download(returnclass = 'sf')`"
}

.onAttach <- function(lib, pkg) {
  # startup message
  msg <- rnaturalearthStartupMessage()
  packageStartupMessage(msg)
  invisible()
}

deprecate_sp <- function(what,
                         env = rlang::caller_env(),
                         user_env = rlang::caller_env(2)) {
  lifecycle::deprecate_warn(
    when = "1.0.0",
    what = what,
    details = "Please use `sf` objects with {rnaturalearth}, support for Spatial objects (sp) will be removed in a future release of the package.",
    env = env,
    user_env = user_env
  )
}
