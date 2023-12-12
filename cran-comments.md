This is a breaking change release.

## revdepcheck results

We checked 37 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

- We saw 0 new problems
- We failed to check 0 packages

## R CMD check results

- The package was tested on:

  - os: macos-latest with r: 'release'
  - os: windows-latest with r: 'release'
  - os: ubuntu-latest with r: 'devel'
  - os: ubuntu-latest with r: 'release'
  - os: ubuntu-latest with r: 'oldrel-1'

- The package was tested on rhub and on winbuilder.

- There are two notes:

  - Package suggested but not available for checking: 'rnaturalearthhires'.
  - Found 416 marked Latin-1 strings because some files contains counfry names.
