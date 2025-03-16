test_that("ne_download returns the correct file name when load = FALSE", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  # fmt: skip
  urls <- c(
    ne_download(scale = 110L, type = "countries", category = "cultural", load = FALSE),
    ne_download(scale = 110L, type = "map_units", category = "cultural", load = FALSE),
    ne_download(scale = 110L, type = "sovereignty", category = "cultural", load = FALSE),
    ne_download(scale = 50L, type = "countries", category = "cultural", load = FALSE),
    ne_download(scale = 10L, type = "countries", category = "cultural", load = FALSE),
    ne_download(scale = 10L, type = "map_units", category = "cultural", load = FALSE),
    ne_download(scale = 10L, type = "sovereignty", category = "cultural", load = FALSE),
    ne_download(scale = 10L, type = "coastline", category = "physical", load = FALSE),
    ne_download(scale = 50L, type = "MSR_50M", category = "raster", load = FALSE)
  )

  vapply(
    urls,
    function(x) {
      expect_true(file.exists(x))
      TRUE
    },
    logical(1L)
  )
})
