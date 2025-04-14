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

  expect_s4_class(rst, "SpatRaster")
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
  expect_s4_class(vect, "SpatVector")

  vect <- ne_load(scale = 50L, destdir = tempdir(), returnclass = "sf")
  expect_s4_class(vect, "sf")
})
