#' Fix invalid geometries in Natural Earth data
#'
#' Fixes geometry issues such as self-intersections and incorrect ring
#' directions that can cause problems with spherical geometry (s2).
#'
#' @param x An `sf` object, typically returned by [ne_countries()],
#'   [ne_states()], [ne_coastline()], or [ne_download()].
#'
#' @return An `sf` object with repaired geometries.
#'
#' @details
#' Natural Earth geometries can contain edges that cross when interpreted as
#' geodesic arcs on the sphere (e.g., Sudan, Russia at small scale). This
#' function applies two fixes:
#'
#' 1. Writes to a temporary GeoJSON file and re-reads with
#'    `check_ring_dir = TRUE` to ensure correct ring winding order
#'    (counter-clockwise for exterior rings, clockwise for holes).
#' 2. Projects to EPSG:3857, applies [sf::st_make_valid()], and projects back
#'    to the original CRS to resolve edge crossings in spherical geometry.
#'
#' This approach is adapted from the
#' [s2 package](https://github.com/r-spatial/s2) data preparation pipeline
#' and a fix proposed in
#' [GitHub issue #78](https://github.com/ropensci/rnaturalearth/issues/78).
#'
#' @examples
#' world <- ne_countries()
#' world_fixed <- ne_fix_geometry(world)
#'
#' # Check validity with s2
#' all(sf::st_is_valid(world_fixed))
#'
#' @export
ne_fix_geometry <- function(x) {
  if (!inherits(x, "sf")) {
    cli::cli_abort("{.arg x} must be an {.cls sf} object.")
  }

  original_crs <- sf::st_crs(x)

  # Step 1: Fix ring winding order via GeoJSON round-trip
  tmp <- tempfile(fileext = ".geojson")
  on.exit(unlink(tmp), add = TRUE)

  sf::write_sf(x, tmp)
  x <- sf::read_sf(tmp, check_ring_dir = TRUE)

  # Step 2: Fix edge crossings by validating in planar space
  sf::st_geometry(x) <- sf::st_geometry(x) |>
    sf::st_transform(crs = 3857L) |>
    sf::st_make_valid() |>
    sf::st_transform(crs = original_crs)

  x
}
