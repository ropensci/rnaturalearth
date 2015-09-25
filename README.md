# rnaturalearth

An R package to hold and facilitate interaction with [natural earth](http://www.naturalearthdata.com/) vector map data.

## Aims :
1. provide easy access to a pre-downloaded subset of Natural Earth vectors most commonly needed for world mapping
1. provide a simple, reproduciple and sustainable workflow from Natural Earth data to rnaturalearth enabling updating as new versions become available
1. provide functions allowing users easily to download other Natural Earth vectors
1. to clarify differences in world maps classified by countries, sovereign states and map units
1. to follow Natural Earth naming conventions so that rnaturalearth users can use Natural Earth documentation

## Install

```r
devtools::install_github("andysouth/rnaturalearth", build_vignettes=TRUE)
require(rnaturalearth)
```

## First Usage
Here using `sp::plot` as a simple, quick way to plot maps. Maps could also be made with `ggplot2`, `tmap` or other options.
```r
require(sp)

#world countries
plot(world_countries()
#uk
plot(world_countries(country = 'united kingdom'))
#states, admin level1 boundaries
plot(world_states(country ='spain')) 

```

## Details of different country definitions and scales
```r
vignette("what-is-a-country", package="rnaturalearth")
```

## To download Natural Earth data not already in the package
```r
lakes110 <- ne_download(scale=110, type='lakes', category='physical')
plot(lakes110)
```

## Reproducible download of Natural Earth data in the package
```r
vignette("getting-map-data-in", package="rnaturalearth")
```

## Acknowledgements
Thanks to [Lincoln Mullen](https://github.com/lmullen) for code structure inspiration from [USAboundaries](https://github.com/ropensci/USAboundaries), [Hadley Wickham](https://github.com/hadley) for comments and prompting, [Bob Rudis](https://github.com/hrbrmstr) for answers to stackoverflow questions about downloading Natural Earth data into R.


## Earlier plans

### suggested data
1. Country boundaries, Small scale, 1:110m 
    + Suitable for schematic maps of the world on a postcard.
    + missing countries from medium scale added in, e.g. for bubble plots. see line 122 in https://github.com/AndySouth/rworldmapSetup/blob/master/saveMapPolygons.r
    
2. Country boundaries, Medium scale, 1:50m
    + Suitable for making zoomed-out maps of countries and regions.

3. Country synonyms lookup
    + dataframe with ISO3 and country synonyms
    + similar to https://github.com/AndySouth/rworldmap/blob/master/data/countrySynonyms.rda
    
4. Country larger regions lookup
    + dataframe with ISO3 and membership of different regional groupings, e.g. continent, least developed countries etc.
    + similar to https://github.com/AndySouth/rworldmap/blob/master/data/countryRegions.rda

5. Coastline, small scale, 1:110m
    + http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_coastline.zip

### suggested functions

1. get country boundaries at passed resolution
    + similar to https://github.com/AndySouth/rworldmap/blob/master/R/getMap.r
    + allow return as sp object or fortified dataframe
    
2. facilitate joining of user data to country boundaries
    + similar to https://github.com/AndySouth/rworldmap/blob/master/R/joinCountryData2Map.R
    + ... but with a better name
    + similar allowing of join by ISO codes or names, with attempted synonym matching
    + similar reporting of country joining success and failure

3. facilitate subsetting by country groupings
    + e.g. continent, least developed countries etc.
    
4. download maps from http://www.naturalearthdata.com/
    + the function used by the package maintainer to download data when updates are made available
    + also allows users to download other natural earth vector data not stored in the package
    + optional stripping out of unwanted attribute variables
    + deas with non ASCII country names,  https://github.com/AndySouth/rworldmapSetup/blob/master/saveMapPolygons.r
    + set CRS
    + set best compression with resaveRdaFiles("data")
    + ? check polygon geometry with checkPolygonsHoles
    + ? deal with countries with missing ISO3 codes, see line 55 in https://github.com/AndySouth/rworldmapSetup/blob/master/saveMapPolygons.r
    + ? move French Guiana out of France see line 182 in https://github.com/AndySouth/rworldmapSetup/blob/master/saveMapPolygons.r
    
    
