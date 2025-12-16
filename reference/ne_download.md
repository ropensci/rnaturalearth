# Download data from Natural Earth and (optionally) read into R

returns downloaded data as a spatial object or the filename if
`load=FALSE`. if `destdir` is specified the data can be reloaded in a
later R session using
[`ne_load`](http://ropensci.github.io/rnaturalearth/reference/ne_load.md)
with the same arguments.

## Usage

``` r
ne_download(
  scale = 110L,
  type = "countries",
  category = c("cultural", "physical", "raster"),
  destdir = tempdir(),
  load = TRUE,
  returnclass = c("sf", "sv")
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
  'ne_50m_urban_areas.zip' this would be 'urban_areas'. See Details. OR
  the raster filename e.g. for 'MSR_50M.zip' this would be 'MSR_50M'

- category:

  one of natural earth categories : 'cultural', 'physical', 'raster'

- destdir:

  where to save files, defaults to
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html),
  [`getwd()`](https://rdrr.io/r/base/getwd.html) is also possible.

- load:

  \`TRUE\` to load the spatial object into R, \`FALSE\` to return the
  filename of the downloaded object. If the requested object is a
  vector, it will be saved as a GPKG file. If a raster is requested, it
  will be saved as a GeoTIFF file.

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
pre-downloaded data are available using
[`ne_countries`](http://ropensci.github.io/rnaturalearth/reference/ne_countries.md),
[`ne_states`](http://ropensci.github.io/rnaturalearth/reference/ne_states.md).
Other geographic data are available in the raster package :
[`getData`](https://rdrr.io/pkg/raster/man/getData.html).

## Examples

``` r
if (FALSE) { # \dontrun{
spdf_world <- ne_download(scale = 110, type = "countries")

plot(spdf_world)
plot(ne_download(type = "populated_places"))

# reloading from the saved file in the same session with same arguments

spdf_world2 <- ne_load(scale = 110, type = "countries")

# download followed by load from specified directory will work across sessions
spdf_world <- ne_download(scale = 110, type = "countries", destdir = getwd())
spdf_world2 <- ne_load(scale = 110, type = "countries", destdir = getwd())

# for raster, here an example with Manual Shaded Relief (MSR) download & load

rst <- ne_download(scale = 50, type = "MSR_50M", category = "raster", destdir = getwd())

# load after having downloaded
rst <- ne_load(
  scale = 50, type = "MSR_50M", category = "raster", destdir = getwd()
)

# plot
library(terra)
terra::plot(rst)
# end dontrun
} # }
```
