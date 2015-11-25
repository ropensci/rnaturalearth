context("ne states : data saved in package")


test_that("type of object returned is as expected", {
  expect_is(ne_states(country='france'), "SpatialPolygonsDataFrame")
  expect_is(ne_states(geounit='france'), "SpatialPolygonsDataFrame")
  expect_is(ne_states(country='united kingdom'), "SpatialPolygonsDataFrame")
  expect_is(ne_states(geounit='england'), "SpatialPolygonsDataFrame")
  })



test_that("filter by country gives bigger object than by geounit", {
  
  expect_more_than( object.size(ne_states(country='france')),
                    object.size(ne_states(geounit='france')) )
  
  expect_more_than( object.size(ne_states(country='united kingdom')),
                    object.size(ne_states(geounit='england')) )
  
})

test_that("equivalent country and iso_a2 arguments give identical results", {
  
  expect_identical( ne_states(country='france'),
                    ne_states(iso_a2='FR') )
  
  expect_identical( ne_states(country='united kingdom'),
                    ne_states(iso_a2='GB') )
  
})

test_that("Error message if incorrect filters are applied", {
  expect_error(ne_states(country='madeupname'))
  expect_error(ne_states(geounit='madeupname'))
  expect_error(ne_states(iso_a2 ='madeupname'))
})



