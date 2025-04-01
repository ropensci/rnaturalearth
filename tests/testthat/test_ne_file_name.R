library(httr)

url_exists <- function(url) {
  url <- sanitize_gdal_url(url)
  res <- HEAD(url)
  status_code(res) == 200L
}

# a non exhaustive list of ne download urls
# initially taken from those in data_download_script.r
# fmt: skip
urls <- c(
  ne_file_name(scale = 110L, type = "countries", category = "cultural"),
  ne_file_name(scale = 110L, type = "map_units", category = "cultural"),
  ne_file_name(scale = 110L, type = "sovereignty", category = "cultural"),
  ne_file_name(scale = 50L, type = "countries", category = "cultural"),
  ne_file_name(scale = 50L, type = "map_units", category = "cultural"),
  ne_file_name(scale = 50L, type = "sovereignty", category = "cultural"),
  ne_file_name(scale = 10L, type = "countries", category = "cultural"),
  ne_file_name(scale = 10L, type = "map_units", category = "cultural"),
  ne_file_name(scale = 10L, type = "sovereignty", category = "cultural"),
  ne_file_name(scale = 50L, type = "states", category = "cultural"),
  ne_file_name(scale = 10L, type = "states", category = "cultural"),
  ne_file_name(scale = 110L, type = "tiny_countries", category = "cultural"),
  ne_file_name(scale = 110L, type = "coastline", category = "physical"),
  ne_file_name(scale = 50L, type = "coastline", category = "physical"),
  ne_file_name(scale = 10L, type = "coastline", category = "physical")
)

url_expect_fail <- ne_file_name(
  scale = 110L,
  type = "expect_fail",
  category = "cultural"
)

test_that("urls for downloads created by the package exist", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  expect_true(all(vapply(urls, url_exists, logical(1L))))
})

test_that("a bogus url does not exist", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  expect_false(url_exists(url_expect_fail))
})
