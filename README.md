# rnaturalearth

A planned R package to hold and facilitate interaction with natural earth map data, principally vector country boundaries.

http://www.naturalearthdata.com/

## suggested data
1. Country boundaries, Small scale, 1:110m 
    + Suitable for schematic maps of the world on a postcard.
    + missing countries from medium scale added in, e.g. for bubble plots. see line 122 in https://github.com/AndySouth/rworldmapSetup/blob/master/saveMapPolygons.r
    
2. Country boundaries, Medium scale, 1:50m
    + Suitable for making zoomed-out maps of countries and regions.

In both cases all attributes with exception of name, ISO3 and one example stripped out   

3. Country synonyms lookup
    + dataframe with ISO3 and country synonyms
    + similar to https://github.com/AndySouth/rworldmap/blob/master/data/countrySynonyms.rda
    
4. Country larger regions lookup
    + dataframe with ISO3 and membership of different regional groupings, e.g. continent, least developed countries etc.
    + similar to https://github.com/AndySouth/rworldmap/blob/master/data/countryRegions.rda

5. Coastline, small scale, 1:110m
    + http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_coastline.zip

## suggested functions

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
    
    
