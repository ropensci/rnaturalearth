# rnaturalearth 1.0.1

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
