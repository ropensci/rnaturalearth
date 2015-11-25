context("ne countries : data saved in package")

spdf_world <- ne_countries()
spdf_africa <- ne_countries(continent='africa')
spdf_france <- ne_countries(country='france')

test_that("type of object returned is as expected", {
  expect_is(spdf_world, "SpatialPolygonsDataFrame")
  expect_is(spdf_africa, "SpatialPolygonsDataFrame")
  expect_is(spdf_france, "SpatialPolygonsDataFrame")
})

#not sure whether I want to test num polygons explicitly
#I might want to allow flexibility for these to change as the data changes
test_that("number of rows/polygons in objects is as expected", {

  expect_equal(length(spdf_world), 177)
  expect_equal(length(spdf_africa), 51)
  expect_equal(length(spdf_france), 1)  
})

test_that("scale argument gives expected relative sizes of objects", {

  expect_more_than( object.size(ne_countries(scale='medium')),
                    object.size(ne_countries(scale='small')) )

  expect_more_than( object.size(ne_countries(scale=50)),
                    object.size(ne_countries(scale=110)) )
  
})

test_that("equivalent scale arguments as numeric or text give identical results", {
  
  expect_identical( ne_countries(scale='medium'),
                    ne_countries(scale=50) )
  
  expect_identical( ne_countries(scale='small'),
                    ne_countries(scale=110) )
  
})

test_that("Error message if incorrect filters are applied", {
  expect_error(ne_countries(continent='madeupname'))
  expect_error(ne_countries(country='madeupname'))
  expect_error(ne_countries(geounit='madeupname'))
  expect_error(ne_countries(sovereignty ='madeupname'))
})

test_that("Error message if incorrect type argument", {
  expect_error(ne_countries(type='madeupname'))
})


