## Resubmission

- This is a resubmission because DESCRIPTION contained an invalid field (Remotes) which has been removed.

- This release also cause breaking changes in vignette building in two packages (https://win-builder.r-project.org/incoming_pretest/rnaturalearth_0.3.2_20230116_105021/reverseDependencies/summary.txt). We have contacted the package maintainers on 2023-17-01 with specific information on how to fix the problems (https://github.com/ropensci/rnaturalearth/issues/69).
  
  - The maintainer of `voluModel` has responded and a new version of their package has been updated on CRAN.
  - The maintainer of `CAST` has made the proper changes and the submission to CRAN is intended for the next days.

## revdepcheck results

We checked 27 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

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
  - Found 416 marked Latin-1 strings because some files contains country names.
