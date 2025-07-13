test_that("ne_load works for raster files", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  scale <- 50L
  type <- "OB_50M"
  category <- "raster"
  tmpdir <- tempdir()

  ne_download(
    scale = scale,
    type = type,
    category = category,
    destdir = tmpdir,
    load = FALSE
  )

  rst <- ne_load(
    scale = scale,
    type = type,
    category = category,
    destdir = tmpdir
  )

  expect_s4_class(rst, "SpatRaster")
})

test_that("ne_load works for vector files", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  tmpdir <- tempdir()

  scale_small <- 50L

  ne_download(
    scale = scale_small,
    destdir = tmpdir,
    load = FALSE
  )

  vect <- ne_load(scale = scale_small, destdir = tmpdir, returnclass = "sv")
  expect_s4_class(vect, "SpatVector")

  vect <- ne_load(scale = scale_small, destdir = tmpdir, returnclass = "sf")
  expect_s3_class(vect, "sf")

  scale_medium <- "medium"

  ne_download(
    scale = scale_medium,
    type = "land",
    category = "physical",
    destdir = tmpdir,
    load = FALSE
  )

  vect <- ne_load(
    scale = scale_medium,
    type = "land",
    category = "physical",
    destdir = tmpdir
  )

  expect_s3_class(vect, "sf")
})
