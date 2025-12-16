# Return a dataframe of available vector layers on Natural Earth

Checks the Natural Earth Github repository for current vector layers and
provides the file name required in the type argument of ne_download.

## Usage

``` r
ne_find_vector_data(
  scale = 110L,
  category = c("cultural", "physical"),
  getmeta = FALSE
)
```

## Arguments

- scale:

  The scale of map to return, one of \`110\`, \`50\`, \`10\` or
  \`small\`, \`medium\`, \`large\`.

- category:

  one of natural earth categories : 'cultural', 'physical'

- getmeta:

  whether to get url of the metadata for each layer

## Value

dataframe with two variables: layer and metadata

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
ne_find_vector_data(scale = 10, category = "physical")
} # }
```
