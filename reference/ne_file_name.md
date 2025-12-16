# return a natural earth filename based on arguments

returns a string that can then be used to download the file.

## Usage

``` r
ne_file_name(
  scale = 110L,
  type = "countries",
  category = c("cultural", "physical", "raster")
)
```

## Arguments

- scale:

  The scale of map to return, one of \`110\`, \`50\`, \`10\` or
  \`small\`, \`medium\`, \`large\`.

- type:

  type of natural earth file to download one of 'countries',
  'map_units', 'map_subunits', 'sovereignty', 'states' OR the portion of
  any natural earth vector url after the scale and before the . e.g. for
  'ne_50m_urban_areas.zip' this would be 'urban_areas' OR the raster
  filename e.g. for 'MSR_50M.zip' this would be 'MSR_50M'

- category:

  one of natural earth categories : 'cultural', 'physical', 'raster'

## Value

string

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
ne_url <- ne_file_name(scale = 110, type = "countries")
```
