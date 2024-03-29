test_that("scale argument gives expected relative sizes of objects", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  expect_gt(
    object.size(ne_countries(scale = "medium")),
    object.size(ne_countries(scale = "small"))
  )

  expect_gt(
    object.size(ne_countries(scale = 50)),
    object.size(ne_countries(scale = 110))
  )
})

test_that("equivalent scale arguments as numeric or text give identical results", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  expect_identical(
    ne_countries(scale = "medium"),
    ne_countries(scale = 50)
  )

  expect_identical(
    ne_countries(scale = "small"),
    ne_countries(scale = 110)
  )
})

test_that("Error message if incorrect filters are applied", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  expect_error(ne_countries(continent = "madeupname"))
  expect_error(ne_countries(country = "madeupname"))
  expect_error(ne_countries(geounit = "madeupname"))
  expect_error(ne_countries(sovereignty = "madeupname"))
})

test_that("Error message if incorrect type argument", {
  skip_on_cran()
  skip_if_not_installed("rnaturalearthdata")
  skip_if_not_installed("rnaturalearthhires")

  expect_error(ne_countries(type = "madeupname"))
})
