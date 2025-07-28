## revdepcheck results

We checked 54 reverse dependencies (22 from CRAN + 32 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

- We saw 0 new problems
- We failed to check 0 packages

## R CMD check results

- The package was tested on:
  - os: macos-latest with r: 'release'
  - os: windows-latest with r: 'release'
  - os: ubuntu-latest with r: 'devel'
  - os: ubuntu-latest with r: 'release'
  - os: ubuntu-latest with r: 'oldrel-1'

## CRAN submission

The package was submitted to CRAN on 2025-07-13. The submission was canceled due to the need to fix a reverse dependency issue with the `slandr` package, which was identified during the CRAN checks. I have contacted the maintainer of the package and proposed a fix (https://github.com/bodkan/slendr/pull/180). The maintainer has merged the fix and will submit a new version to CRAN soon.
