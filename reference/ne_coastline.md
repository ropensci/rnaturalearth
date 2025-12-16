# Get natural earth world coastline

returns world coastline at specified scale

## Usage

``` r
ne_coastline(scale = 110L, returnclass = c("sf", "sv"))
```

## Arguments

- scale:

  The scale of map to return, one of \`110\`, \`50\`, \`10\` or
  \`small\`, \`medium\`, \`large\`.

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
if (requireNamespace("rnaturalearthdata")) {
  coast <- ne_coastline()
  plot(coast)
}
#> Loading required namespace: rnaturalearthdata

```
