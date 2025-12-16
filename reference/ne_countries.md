# Get natural earth world country polygons

returns world country polygons at a specified scale, or points of
tiny_countries

## Usage

``` r
ne_countries(
  scale = 110L,
  type = "countries",
  continent = NULL,
  country = NULL,
  geounit = NULL,
  sovereignty = NULL,
  returnclass = c("sf", "sv")
)
```

## Arguments

- scale:

  The scale of map to return, one of \`110\`, \`50\`, \`10\` or
  \`small\`, \`medium\`, \`large\`.

- type:

  country type, one of 'countries', 'map_units', 'sovereignty',
  'tiny_countries'

- continent:

  a character vector of continent names to get countries from.

- country:

  a character vector of country names.

- geounit:

  a character vector of geounit names.

- sovereignty:

  a character vector of sovereignty names.

- returnclass:

  A string determining the spatial object to return. Either "sf" for for
  simple feature (from \`sf\`, the default) or "sv" for a \`SpatVector\`
  (from \`terra\`).

## Value

An object of class \`sf\` for simple feature (from \`sf\`, the default)
or \`SpatVector\` (from \`terra\`).

## Details

Note that the filename of the requested object will be returned if
\`load = FALSE\`.

If the data is to be loaded into memory (\`load = TRUE\`), the download
will be handled using the GDAL virtual file system, allowing direct
access to the data without writing it to disk.

## See also

[`ne_load`](http://ropensci.github.io/rnaturalearth/reference/ne_load.md),
pre-downloaded data are available using `ne_countries`,
[`ne_states`](http://ropensci.github.io/rnaturalearth/reference/ne_states.md).
Other geographic data are available in the raster package :
[`getData`](https://rdrr.io/pkg/raster/man/getData.html).

## Examples

``` r
world <- ne_countries()
africa <- ne_countries(continent = "africa")
france <- ne_countries(country = "france")

plot(world$geometry)

plot(africa$geometry)

plot(france$geometry)


# get as SpatVector
world <- ne_countries(returnclass = "sv")
terra::plot(world)


tiny_countries <- ne_countries(type = "tiny_countries", scale = 50)
plot(tiny_countries)
#> Warning: plotting the first 10 out of 170 attributes; use max.plot = 170 to plot all

```
