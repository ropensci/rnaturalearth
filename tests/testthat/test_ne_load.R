test_that("ne_load works for raster files", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  ne_download(
    scale = 50L,
    type = "OB_50M",
    category = "raster",
    destdir = tempdir(),
    load = FALSE
  )

  rst <- ne_load(
    scale = 50L,
    type = "OB_50M",
    category = "raster",
    destdir = tempdir()
  )

  expect_true(inherits(rst, "SpatRaster"))
})

test_that("ne_load works for vector files", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  ne_download(
    scale = 50L,
    destdir = tempdir(),
    load = FALSE
  )

  vect <- ne_load(scale = 50L, destdir = tempdir(), returnclass = "sv")
  expect_true(inherits(vect, "SpatVector"))

  vect <- ne_load(scale = 50L, destdir = tempdir(), returnclass = "sf")
  expect_true(inherits(vect, "sf"))
})
