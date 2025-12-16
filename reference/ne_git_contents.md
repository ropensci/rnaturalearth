# Return contents of Natural Earth Github directory

Uses the Github API to return contents of Natural Earth Github
directories.

## Usage

``` r
ne_git_contents(path)
```

## Arguments

- path:

  string, one of: `'110m_physical'`, `'110m_cultural'`,
  `'50m_physical'`, `'50m_cultural'`, `'10m_physical'`, `'10m_cultural'`

## Value

list. Includes parsed json content, http path, and response code.
