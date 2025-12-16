# Normalize the type argument for Natural Earth datasets

This function standardizes the \`type\` argument by mapping common names
to their respective Natural Earth dataset names.

## Usage

``` r
normalize_type(type)
```

## Arguments

- type:

  type of natural earth file to download one of 'countries',
  'map_units', 'map_subunits', 'sovereignty', 'states' OR the portion of
  any natural earth vector url after the scale and before the . e.g. for
  'ne_50m_urban_areas.zip' this would be 'urban_areas' OR the raster
  filename e.g. for 'MSR_50M.zip' this would be 'MSR_50M'

## Value

A string representing the normalized dataset type.
