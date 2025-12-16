test_that("ne_download() can download data and return the associated file when load = FALSE", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  # fmt: skip
  urls <- c(
    ne_download( scale = 110L, type = "countries", category = "cultural", load = FALSE),
    ne_download(scale = 110L, type = "map_units", category = "cultural", load = FALSE),
    ne_download(scale = 110L, type = "sovereignty", category = "cultural", load = FALSE),
    ne_download(scale = 50L, type = "countries", category = "cultural", load = FALSE),
    ne_download(scale = 10L, type = "countries", category = "cultural", load = FALSE),
    ne_download(scale = 10L, type = "map_units", category = "cultural", load = FALSE),
    ne_download(scale = 10L, type = "sovereignty", category = "cultural", load = FALSE),
    ne_download(scale = 10L, type = "coastline", category = "physical", load = FALSE),
    ne_download(scale = 10L, type = "parks_and_protected_lands_line", category = "cultural", load = FALSE),
    ne_download(scale = 10L, type = "parks_and_protected_lands_point", category = "cultural", load = FALSE),
    ne_download(scale = 10L, type = "parks_and_protected_lands_scale_rank", category = "cultural", load = FALSE),
    ne_download(scale = 110L, type = "countries", category = "cultural", load = FALSE, returnclass = "sv"),
    ne_download(scale = 10L, type = "parks_and_protected_lands_scale_rank", category = "cultural", load = FALSE, returnclass = "sv"),
    ne_download(scale = 50L, type = "MSR_50M", category = "raster", load = FALSE)
  )

  expect_true(all(file.exists(urls)))
})

# fmt: on
test_that("ne_download() uses caching when load = TRUE and destdir is not tempdir()", {
  skip_on_cran()
  skip_if_not_installed("sf")

  # Create a temporary directory for caching
  cache_dir <- file.path(tempdir(), "ne_cache_test")
  dir.create(cache_dir, showWarnings = FALSE)
  on.exit(unlink(cache_dir, recursive = TRUE), add = TRUE)

  # First call: should download and save
  result1 <- ne_download(
    scale = 110L,
    type = "countries",
    category = "cultural",
    destdir = cache_dir,
    load = TRUE
  )

  # Check that the file was created
  expected_file <- file.path(cache_dir, "ne_110m_admin_0_countries.gpkg")
  expect_true(file.exists(expected_file))

  # Check that result is an sf object
  expect_s3_class(result1, "sf")

  # Second call: should load from cache (not re-download)
  result2 <- ne_download(
    scale = 110L,
    type = "countries",
    category = "cultural",
    destdir = cache_dir,
    load = TRUE
  )

  # Check that result is still an sf object
  expect_s3_class(result2, "sf")

  # Results should be identical
  expect_identical(nrow(result1), nrow(result2))
  expect_identical(ncol(result1), ncol(result2))
})
