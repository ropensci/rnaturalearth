test_that("type of object returned is sf", {
  world <- ne_countries()
  africa <- ne_countries(continent = "africa")
  france <- ne_countries(country = "france")

  expect_is(world, "sf")
  expect_is(africa, "sf")
  expect_is(france, "sf")
})

test_that("type of object returned is SpatVector", {
  world <- ne_countries(returnclass = "sv")
  africa <- ne_countries(continent = "africa", returnclass = "sv")
  france <- ne_countries(country = "france", returnclass = "sv")

  expect_is(world, "SpatVector")
  expect_is(africa, "SpatVector")
  expect_is(france, "SpatVector")
})

# Check if I should do all the tests for all the scales.
test_that("type of object returned is either sf or SpatVector for coastlines", {
  expect_true(inherits(ne_coastline(returnclass = "sf", scale = 10), "sf"))
  expect_true(inherits(ne_coastline(returnclass = "sf", scale = 50), "sf"))
  expect_true(inherits(ne_coastline(returnclass = "sf", scale = 110), "sf"))
  expect_true(inherits(ne_coastline(returnclass = "sv"), "SpatVector"))
})

test_that("type of object returned is either sf or SpatVector for states", {
  expect_true(inherits(ne_states(returnclass = "sf"), "sf"))
  expect_true(inherits(ne_states(returnclass = "sv"), "SpatVector"))
})
