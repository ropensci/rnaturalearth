# Create list of layer names and metadata links

Parses Natural Earth Github folder content for layer names and metadata
links.

## Usage

``` r
ne_git_layer_names(x, scale, getmeta)
```

## Arguments

- x:

  object returned by ne_git_contents

- scale:

  one of `110`, `50`, `10`

- getmeta:

  whether to get url of the metadata for each layer

## Value

list of lists with layer names and metadata links.
