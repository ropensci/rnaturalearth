test_that("ne_fix_geometry returns a valid sf object", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")

  world <- ne_countries()
  result <- ne_fix_geometry(world)

  expect_s3_class(result, "sf")
  expect_equal(nrow(result), nrow(world))
  expect_equal(ncol(result), ncol(world))
})

test_that("ne_fix_geometry preserves the original CRS", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")

  world <- ne_countries()
  result <- ne_fix_geometry(world)

  expect_equal(sf::st_crs(result), sf::st_crs(world))
})

test_that("ne_fix_geometry produces valid geometries", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")

  world <- ne_countries()
  result <- ne_fix_geometry(world)

  expect_true(all(sf::st_is_valid(result)))
})

test_that("ne_fix_geometry preserves attribute data", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")

  world <- ne_countries()
  result <- ne_fix_geometry(world)

  result_df <- as.data.frame(sf::st_drop_geometry(result))
  world_df <- as.data.frame(sf::st_drop_geometry(world))

  expect_equal(result_df, world_df)
})

test_that("ne_fix_geometry errors on non-sf input", {
  expect_error(ne_fix_geometry(data.frame(x = 1)), "sf")
  expect_error(ne_fix_geometry("not sf"), "sf")
  expect_error(ne_fix_geometry(42), "sf")
})
