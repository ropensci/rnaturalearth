# load a Natural Earth vector that has already been downloaded to R using [`ne_download`](http://ropensci.github.io/rnaturalearth/reference/ne_download.md)

returns loaded data as a spatial object.

## Usage

``` r
ne_load(
  scale = 110L,
  type = "countries",
  category = c("cultural", "physical", "raster"),
  destdir = tempdir(),
  file_name = NULL,
  returnclass = c("sf", "sv")
)
```

## Arguments

- scale:

  The scale of map to return, one of \`110\`, \`50\`, \`10\` or
  \`small\`, \`medium\`, \`large\`.

- type:

  type of natural earth file one of 'countries', 'map_units',
  'map_subunits', 'sovereignty', 'states' OR the portion of any natural
  earth vector url after the scale and before the . e.g. for
  'ne_50m_urban_areas.zip' this would be 'urban_areas' OR the raster
  filename e.g. for 'MSR_50M.zip' this would be 'MSR_50M'

- category:

  one of natural earth categories : 'cultural', 'physical', 'raster'

- destdir:

  folder to load files from, default = tempdir()

- file_name:

  OPTIONAL name of file (excluding path) instead of natural earth
  attributes

- returnclass:

  A string determining the spatial object to return. Either "sf" for for
  simple feature (from \`sf\`, the default) or "sv" for a \`SpatVector\`
  (from \`terra\`).

## Value

An object of class \`sf\` for simple feature (from \`sf\`, the default)
or \`SpatVector\` (from \`terra\`).

## Details

This function should be used after first downloading the data with
`ne_download(load = FALSE)`. The downloaded file can then be loaded
using this function.

## See also

[`ne_download`](http://ropensci.github.io/rnaturalearth/reference/ne_download.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# download followed by load from tempdir() works in same R session
spdf_world <- ne_download(
  scale = 110,
  type = "countries"
)
spdf_world2 <- ne_load(
  scale = 110,
  type = "countries"
)

# download followed by load from specified directory works between R sessions
spdf_world <- ne_download(
  scale = 110,
  type = "countries",
  destdir = getwd()
)
spdf_world2 <- ne_load(
  scale = 110,
  type = "countries",
  destdir = getwd()
)

# for raster download & load
rst <- ne_download(
  scale = 50,
  type = "OB_50M",
  category = "raster",
  destdir = getwd(),
  load = FALSE
)

# load after having downloaded
rst <- ne_load(
  scale = 50,
  type = "OB_50M",
  category = "raster",
  destdir = getwd()
)

# plot
library(terra)
plot(rst)
# end dontrun
} # }
```
