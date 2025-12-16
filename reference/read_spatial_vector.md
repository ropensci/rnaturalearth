# Read Spatial Vector

This function reads a spatial vector file and returns either an \`sf\`
object or a \`sv\` object.

## Usage

``` r
read_spatial_vector(x, layer, returnclass = c("sf", "sv"))
```

## Arguments

- x:

  A character string specifying the path to the spatial vector file.

- layer:

  A character string specifying the later to read in case there are more
  than one in the zip file.

- returnclass:

  A character string specifying the class of object to return. Options
  are "sf" for sf object and "sv" for sv object.

## Value

Either an \`sf\` object or a \`sv\` object.
