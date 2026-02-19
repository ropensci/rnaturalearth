# a' Fix invalid geometries in Natural Earth data
#'
#' Repairs geometry issues such as self-intersections, incorrect ring
#' directions, and geodesic edge crossings that cause problems with spherical
#' geometry ([s2][s2::s2-package]). The result is valid under both s2
#' (spherical) and GEOS (planar) engines.
#'
#' @param x An `sf` object, typically returned by [ne_countries()],
#'   [ne_states()], [ne_coastline()], or [ne_download()].
#'
#' @return An `sf` object with repaired geometries. The original CRS,
#'   attributes, and geometry type (`MULTIPOLYGON`) are preserved.
#'
#' @details
#' Natural Earth geometries can contain edges that cross when interpreted as
#' geodesic arcs on the sphere (e.g., Sudan, Russia at small scale). This
#' function applies three targeted fixes:
#'
#' 1. **Ring winding order** -- Writes to a temporary GeoPackage file and
#'    re-reads with `check_ring_dir = TRUE` to ensure correct ring orientation
#'    (counter-clockwise for exterior rings, clockwise for holes). GeoPackage is
#'    used instead of GeoJSON to preserve coordinate precision, attribute types,
#'    and CRS.
#' 2. **Planar repair** -- Applies [sf::st_make_valid()] with s2 disabled to
#'    resolve self-intersections and other topology errors detectable in flat
#'    coordinates.
#' 3. **Spherical repair** -- Any geometries that remain s2-invalid are
#'    converted to s2 geography via [s2::s2_geog_from_wkb()] (bypassing the
#'    edge-crossing check) and repaired with [s2::s2_buffer_cells()] using a
#'    negligible 1-meter buffer. The result is then wrapped at the antimeridian
#'    ([sf::st_wrap_dateline()]) and re-validated in planar mode to preserve R2
#'    compatibility. Any `GEOMETRYCOLLECTION` outputs from [sf::st_make_valid()]
#'    are reduced to their polygon components before casting to
#'    `MULTIPOLYGON`. Only the affected features are modified; valid geometries
#'    are left untouched.
#'
#' A warning is issued if the input uses a projected (non-geographic) CRS,
#' since the s2-based repair assumes longitude/latitude coordinates.
#'
#' The user's current `sf_use_s2()` setting is saved and restored on exit.
#'
#' This approach is adapted from the
#' [s2 package](https://github.com/r-spatial/s2) data preparation pipeline
#' and a fix proposed in
#' [GitHub issue #78](https://github.com/ropensci/rnaturalearth/issues/78).
#'
#' @examples
#' \donttest{
#' world <- ne_countries(scale = "small", returnclass = "sf")
#'
#' # Before: Sudan and Russia are s2-invalid
#' sf::sf_use_s2(TRUE)
#' world$name[!sf::st_is_valid(world)]
#'
#' # After: all valid under both s2 and GEOS
#' world_fixed <- ne_fix_geometry(world)
#' all(sf::st_is_valid(world_fixed))            # TRUE (s2)
#' sf::sf_use_s2(FALSE)
#' all(sf::st_is_valid(world_fixed))            # TRUE (GEOS/R2)
#' }
#'
#' @export
ne_fix_geometry <- function(x) {
  if (!inherits(x, "sf")) {
    cli::cli_abort("{.arg x} must be an {.cls sf} object.")
  }

  if (!is.na(sf::st_is_longlat(x)) && !sf::st_is_longlat(x)) {
    cli::cli_warn(
      "{.fn ne_fix_geometry} is designed for geographic (lon/lat) CRS.
       The input uses a projected CRS, which may produce unexpected results."
    )
  }

  original_crs <- sf::st_crs(x)

  # Save and restore s2 setting on exit (suppress toggle messages)
  s2_was_on <- sf::sf_use_s2()
  on.exit(suppressMessages(sf::sf_use_s2(s2_was_on)), add = TRUE)

  # Step 1: Fix ring winding order via GeoPackage round-trip
  # GPKG preserves CRS, attribute types, and coordinate precision
  # (unlike GeoJSON which forces WGS84 and uses text-based coordinates)
  tmp <- tempfile(fileext = ".gpkg")
  on.exit(unlink(tmp), add = TRUE)

  suppressMessages(sf::sf_use_s2(FALSE))
  sf::write_sf(x, tmp)
  x <- sf::read_sf(tmp, check_ring_dir = TRUE)

  # Step 2: Make valid in planar mode (handles self-intersections)
  sf::st_geometry(x) <- sf::st_make_valid(sf::st_geometry(x))

  # Step 3: Fix remaining s2-invalid geometries via s2 buffer
  suppressMessages(sf::sf_use_s2(TRUE))
  s2_invalid_idx <- which(!sf::st_is_valid(x))

  if (length(s2_invalid_idx) > 0L) {
    cli::cli_inform(c(
      "i" = "Repairing {length(s2_invalid_idx)} s2-invalid
       geometr{?y/ies} with a 1-meter buffer."
    ))

    suppressMessages(sf::sf_use_s2(FALSE))
    geom <- sf::st_geometry(x)
    geom_fix <- geom[s2_invalid_idx]

    wkb <- sf::st_as_binary(geom_fix)
    s2_geog <- s2::s2_geog_from_wkb(wkb, oriented = FALSE, check = FALSE)
    s2_geog <- s2::s2_buffer_cells(s2_geog, distance = 1L)

    suppressMessages(sf::sf_use_s2(TRUE))
    geom_fix <- sf::st_as_sfc(s2_geog, crs = original_crs)

    # Restore R2 compatibility for any dateline-crossing results
    suppressMessages(sf::sf_use_s2(FALSE))
    geom_fix <- sf::st_wrap_dateline(
      geom_fix,
      options = c("WRAPDATELINE=YES", "DATELINEOFFSET=180")
    )
    geom_fix <- sf::st_make_valid(geom_fix)

    # st_make_valid() may produce GEOMETRYCOLLECTION containing stray
    # lines or points; extract only polygon components before casting
    types <- sf::st_geometry_type(geom_fix)
    gc_idx <- which(types == "GEOMETRYCOLLECTION")
    if (length(gc_idx) > 0L) {
      for (i in gc_idx) {
        parts <- sf::st_collection_extract(
          sf::st_sfc(geom_fix[[i]], crs = original_crs),
          "POLYGON"
        )
        if (length(parts) > 0L) {
          geom_fix[[i]] <- sf::st_combine(parts)[[1L]]
        }
      }
      geom_fix <- sf::st_sfc(geom_fix, crs = original_crs)
    }

    geom_fix <- sf::st_cast(geom_fix, "MULTIPOLYGON")

    geom[s2_invalid_idx] <- geom_fix
    sf::st_geometry(x) <- geom
  }

  sf::st_crs(x) <- original_crs

  x
}
