[![Travis-CI Build Status](https://travis-ci.org/AndySouth/rnaturalearth.svg?branch=master)](https://travis-ci.org/AndySouth/rnaturalearth)

# rnaturalearth

An R package to hold and facilitate interaction with [Natural Earth](http://www.naturalearthdata.com/) vector map data.

### Aims :
1. access to a pre-downloaded subset of Natural Earth vectors commonly used in world mapping
1. allow easy subsetting by countries and regions
1. facilitate download of other Natural Earth vectors
1. provide a simple, reproducible and sustainable workflow from Natural Earth data to rnaturalearth enabling updating as new versions become available
1. to clarify differences in world maps classified by countries, sovereign states and map units
1. to follow Natural Earth naming conventions so that rnaturalearth users can use Natural Earth documentation

The [Natural Earth](http://www.naturalearthdata.com/) website structures vector data by scale, category and type. These determine the filenames of downloads. rnaturalearth uses this structure to facilitate download (like an API). 

### Install rnaturalearth

```r
devtools::install_github("andysouth/rnaturalearth", build_vignettes=TRUE)
require(rnaturalearth)
```

### First Usage
Here using `sp::plot` as a simple, quick way to plot maps. Maps could also be made with `ggplot2`, `tmap` or other options.
```r
require(sp)

#world countries
plot(world_countries())
#uk
plot(world_countries(country = 'united kingdom'))
#states, admin level1 boundaries
plot(world_states(country ='spain')) 

```

### Introductory vignette
```r
vignette("what-is-a-country", package="rnaturalearth")
```

### To download Natural Earth data not already in the package
Specify the `scale`, `category` and `type` of the vector you want. For example for `scale=50` and `category=physical` the available options for `type` can be found [here](http://www.naturalearthdata.com/downloads/50m-physical-vectors/).

```r
#lakes
lakes110 <- ne_download(scale=110, type='lakes', category='physical')
plot(lakes110)

#rivers
rivers50 <- ne_download(scale=50, type='rivers_lake_centerlines', category='physical')
plot(rivers50)
```

### Details of different country definitions and scales
```r
vignette("what-is-a-country", package="rnaturalearth")
```

## Reproducible download of Natural Earth data in the package
`data-raw/data_download_script.r`

## Acknowledgements
Thanks to [Lincoln Mullen](https://github.com/lmullen) for code structure inspiration from [USAboundaries](https://github.com/ropensci/USAboundaries), [Hadley Wickham](https://github.com/hadley) for comments and prompting, [Bob Rudis](https://github.com/hrbrmstr) for answers to stackoverflow questions about downloading Natural Earth data into R.


## Earlier plans and potential future work

### potential additional data

1. Country synonyms lookup
    + dataframe with ISO3 and country synonyms
    + similar to https://github.com/AndySouth/rworldmap/blob/master/data/countrySynonyms.rda
    
1. Country larger regions lookup
    + dataframe with ISO3 and membership of different regional groupings, e.g. continent, least developed countries etc.
    + similar to https://github.com/AndySouth/rworldmap/blob/master/data/countryRegions.rda


### potential additional functions

1. facilitate joining of user data to country boundaries
    + similar to https://github.com/AndySouth/rworldmap/blob/master/R/joinCountryData2Map.R
    + ... but with a better name
    + similar allowing of join by ISO codes or names, with attempted synonym matching
    + similar reporting of country joining success and failure

1. facilitate subsetting by country groupings
    + e.g. least developed countries etc.

    
    
