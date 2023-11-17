# TODO: Change to sf in rnaturalearthhires
test_that("type of object returned is as expected", {
  # skip tests if rnaturalearthhires not available in testing env
  # specifically on winbuilder and CRAN
  # reduces efectiveness of the test
  testthat::skip_if_not_installed("rnaturalearthhires")

  expect_is(ne_states(country = "france"), "sf")
  expect_is(ne_states(geounit = "france"), "sf")
  expect_is(ne_states(country = "united kingdom"), "sf")
  expect_is(ne_states(geounit = "england"), "sf")
})

test_that("filter by country gives bigger object than by geounit", {
  # skip tests if rnaturalearthhires not available in testing env
  # specifically on winbuilder and CRAN
  # reduces efectiveness of the test
  testthat::skip_if_not_installed("rnaturalearthhires")

  expect_gt(
    object.size(ne_states(country = "france")),
    object.size(ne_states(geounit = "france"))
  )

  expect_gt(
    object.size(ne_states(country = "united kingdom")),
    object.size(ne_states(geounit = "england"))
  )
})

test_that("equivalent country and iso_a2 arguments give identical results", {
  # skip tests if rnaturalearthhires not available in testing env
  # specifically on winbuilder and CRAN
  # reduces efectiveness of the test
  testthat::skip_if_not_installed("rnaturalearthhires")

  expect_identical(
    ne_states(country = "france"),
    ne_states(iso_a2 = "FR")
  )

  expect_identical(
    ne_states(country = "united kingdom"),
    ne_states(iso_a2 = "GB")
  )
})

test_that("Error message if incorrect filters are applied", {
  # skip tests if rnaturalearthhires not available in testing env
  # specifically on winbuilder and CRAN
  # reduces efectiveness of the test
  testthat::skip_if_not_installed("rnaturalearthhires")

  expect_error(ne_states(country = "madeupname"))
  expect_error(ne_states(geounit = "madeupname"))
  expect_error(ne_states(iso_a2 = "madeupname"))
})
