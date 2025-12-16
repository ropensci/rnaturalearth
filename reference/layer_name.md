# Generate the layer name for a Natural Earth dataset

Generate the layer name for a Natural Earth dataset

## Usage

``` r
layer_name(type, scale)
```

## Arguments

- type:

  type of natural earth file to download one of 'countries',
  'map_units', 'map_subunits', 'sovereignty', 'states' OR the portion of
  any natural earth vector url after the scale and before the . e.g. for
  'ne_50m_urban_areas.zip' this would be 'urban_areas' OR the raster
  filename e.g. for 'MSR_50M.zip' this would be 'MSR_50M'

- scale:

  The scale of map to return, one of \`110\`, \`50\`, \`10\` or
  \`small\`, \`medium\`, \`large\`.

## Value

A string representing the dataset layer name.
