# check whether the requested data exist on Natural Earth

checks from a list dependent on type, category and scale. If it returns
FALSE the data may still exist on the website. Doesn't yet do checking
on raster names because I found the naming convention too tricky.

## Usage

``` r
check_data_exist(
  type,
  scale = 110L,
  category = c("cultural", "physical", "raster")
)
```

## Arguments

- type:

  type of natural earth file to download one of 'countries',
  'map_units', 'map_subunits', 'sovereignty', 'states' OR the portion of
  any natural earth vector url after the scale and before the . e.g. for
  'ne_50m_urban_areas.zip' this would be 'urban_areas' OR the raster
  filename e.g. for 'MSR_50M.zip' this would be 'MSR_50M'

- scale:

  The scale of map to return, one of \`110\`, \`50\`, \`10\` or
  \`small\`, \`medium\`, \`large\`.

- category:

  one of natural earth categories : 'cultural', 'physical', 'raster'

## Value

TRUE or FALSE

## Details

Note that the filename of the requested object will be returned if
\`load = FALSE\`.

If the data is to be loaded into memory (\`load = TRUE\`), the download
will be handled using the GDAL virtual file system, allowing direct
access to the data without writing it to disk.

## See also

[`ne_load`](http://ropensci.github.io/rnaturalearth/reference/ne_load.md),
pre-downloaded data are available using
[`ne_countries`](http://ropensci.github.io/rnaturalearth/reference/ne_countries.md),
[`ne_states`](http://ropensci.github.io/rnaturalearth/reference/ne_states.md).
Other geographic data are available in the raster package :
[`getData`](https://rdrr.io/pkg/raster/man/getData.html).

## Examples

``` r
check_data_exist(type = "countries", scale = 110, category = "cultural")
#> [1] TRUE

# Type not in list for this category
check_data_exist(type = "airports", scale = 110, category = "physical")
#> Warning: `airports` seems not to be in the list for category= "physical" maybe try the
#> other category of c('cultural', 'physical')
#> [1] FALSE

# Type in list but scale shows FALSE
check_data_exist(type = "airports", scale = 110, category = "cultural")
#> Warning: The requested daa seem not to exist in the list of Natural Earth data. Check
#> `?ne_download` or <http://www.naturalearthdata.com/features/> to see data
#> availability.
#> [1] FALSE
```
