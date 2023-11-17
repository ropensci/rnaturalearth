deprecate_sp <- function(what, env = rlang::caller_env()) {
  lifecycle::deprecate_stop(
    when = "1.0.0",
    what = what,
    details = "Please use `sf` objects with {rnaturalearth}, Spatial objects (sp) are no longer supported. For example: `ne_download(returnclass = 'sf')`",
    env = env
  )
}
