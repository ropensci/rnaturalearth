# Create Destination File Path

Creates a destination file path by combining the directory path with a
formatted filename based on the GDAL URL and category.

## Usage

``` r
make_dest_path(gdal_url, category, destdir)
```

## Arguments

- gdal_url:

  A character string representing the GDAL URL

- category:

  A character string specifying the data category ("raster" or other)

- destdir:

  A character string specifying the destination directory

## Value

A character string representing the complete destination file path
