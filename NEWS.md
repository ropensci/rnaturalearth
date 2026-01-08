# rnaturalearth (development version)

- Replaced `devtools` with `pak` for installing companion packages `rnaturalearthdata` and `rnaturalearthhires` from GitHub, reducing dependencies (@121). Thanks to @richardjtelford for the suggestion.

- Added automatic caching to `ne_download()`: when `destdir` is set to a persistent directory, the function now checks for existing files and loads from cache instead of re-downloading. Thank you to @plantarum for the suggestion (#124).

- Fixed raster downloads in `ne_download()` by handling Natural Earth's inconsistent zip structures, where some rasters have a subfolder inside the archive and others do not (#126).

# rnaturalearth 1.1.0

## New features

- Data is now downloaded using the GDAL Virtual File System, allowing `ne_download()` to read data directly from the zip file without requiring extraction.

- We are transitioning to the [GeoPackage](https://www.geopackage.org/) format when `load = FALSE` is used in `ne_download()`. This modern format is more efficient and flexible than the previously use shapefile format.

- Similarly, raster data (GeoTIFF) is now read directly from the zip file and written to the specified directory. For example, the following code downloads the 50m raster dataset and saves it to the working directory:

  ```r
  ne_download(
    scale = 50,
    type = "MSR_50M",
    category = "raster",
    load = FALSE,
    destdir = getwd()
  )
  ```

## Bug fixes and general improvements

- Updated the base URL for downloading data to `https://naciscdn.org/naturalearth`, replacing the previous `https://naturalearth.s3.amazonaws.com/` url. This change aligns with the [Natural Earth](https://www.naturalearthdata.com/) website's source.

- Improved package loading time by removing unnecessary imports and implementing lazy loading of dependencies (#119). Thanks to @heavywatal.

- Using the `cli` package for better messages.

- Correctly downloading parks and protected areas (#114)

```r
ne_download(
  scale = 10,
  type = "parks_and_protected_lands_line",
  category = "cultural"
)

ne_download(
  scale = 10,
  type = "parks_and_protected_lands_point",
  category = "cultural"
)

ne_download(
  scale = 10,
  type = "parks_and_protected_lands_scale_rank",
  category = "cultural"
)
```

- `rnaturalearth` now requires rnaturalearthdata (>= 1.0.0) and rnaturalearthhires (>= 1.0.0).

- Correctly returning the file name in `ne_download()` when setting `load = FALSE`

```r
ne_download(
  type = "MSR_50M",
  category = "raster",
  scale = 50,
  load = FALSE
)
```

# rnaturalearth 1.0.1

- Do not test functions who rely on `rnaturalearthhires` because it is not available on CRAN.

# rnaturalearth 1.0.0

## Breaking changes

This is a breaking changes release that ends support to `sp` object in favour of more modern interfaces (`sf` and `terra`). Although that `sp` is still available on CRAN, it is no longer being actively developed (https://geocompx.org/post/2023/rgdal-retirement/). This is the main reason that motivated the choice to transition toward `sf` (the default) and `terra`.

Users can choose either get an `sf` or `SpatVector` using the `returnclass` argument:

```
ne_countries(returnclass = "sf")
ne_countries(returnclass = "sv")
```

Affected functions are `ne_countries()`, `ne_coastline()`, `ne_states()`, `ne_load()` and `ne_download()`.

If changing the return type to `sf` creates too many problems to your existing code, you can still convert it back to `sp` :

```
countries <- ne_countries(returnclass = "sf")

# option 1
sf::as_Spatial(countries)


# option 2
as(countries, "Spatial")
```

More information about the retirement of `rgdal`, `rgeos` and `maptools`: https://r-spatial.org/r/2022/04/12/evolution.html

## Bugfix

- Correctly downloading and reading raster object (#96, closes #52).

# rnaturalearth 0.3.4

- This is a maintenance release that document/use the new special sentinel "\_PACKAGE".

# rnaturalearth 0.3.3

- Using `lifecycle` to indicate that support of `sp` object will be eventually dropped. Users should now use `ne_download(returnclass = "sf")`, instead of `ne_download(returnclass = "sp")`.

- `terra` is now included in the Imports section.

# rnaturalearth 0.3.2

- Added new maintainer and contributors ([#62](https://github.com/ropensci/rnaturalearth/issues/62)).

- Using terra over raster ([#63](https://github.com/ropensci/rnaturalearth/pull/63))
  - See <https://r-spatial.org/r/2022/04/12/evolution.html#packages-depending-on-sp-and-raster> and <https://r-spatial.org/r/2022/12/14/evolution2.html#deprecations-in-retiring-packages>

- Fixes broken data download links.
  - Now using Amazon hosted URLs as the primary source for downloading data ([#48](https://github.com/ropensci/rnaturalearth/issues/48), [#64](https://github.com/ropensci/rnaturalearth/issues/64)).

# rnaturalearth 0.3.0 2021-10-11

- fix rnaturalearthhires installation #47 thank you Ian Taylor for #43

# rnaturalearth 0.2.0

- add to river options in ne_download() by adding to data_list_physical.csv fixing [#23](https://github.com/ropensci/rnaturalearth/issues/23)
- update data to new version [Natural Earth v4.1](https://www.naturalearthdata.com/blog/miscellaneous/natural-earth-v4-1-0-release-notes/) released May 2018.

# rnaturalearth 0.1.0 CRAN

- Initial release
- sf support
