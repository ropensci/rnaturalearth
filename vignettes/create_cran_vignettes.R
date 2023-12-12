# Use this to create the vignette to prevent CRAN checks from failing when
# gitignore API is not available.

# https://ropensci.org/blog/2019/12/08/precompute-vignettes/

library(fs)

infiles <- dir_ls("vignettes", glob = "*.orig")
outfiles <- fs::path_ext_remove(infiles)

purrr::walk2(infiles, outfiles, knitr::knit)

figfiles <- fs::dir_ls(glob = "*.png")

fs::file_move(figfiles, "vignettes")
