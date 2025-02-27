# data-raw/data_download_script.r

# getting data into rnaturalearth for admin NOT for users reproducible workflow
# allowing package data to be updated e.g. when there are updates to Natural
# Earth. just by sourcing this script need also to source the same named script
# in rnaturalearthdata and rnaturalearthhires

# one example file in rnaturalearth
# scale 110 and 50 files in rntauralearthdata
# scale 10 files in rntauralearthhires

library(rnaturalearth)

countries110 <- ne_download(
  scale = 110L,
  type = "countries",
  category = "cultural"
)

# to allow same operation on all data objects in the package
data_object_names <- data(package = "rnaturalearth")[["results"]][, "Item"]


# saving data files to correct folder in the package relies on working directory
# being set to root of the package BEWARE circular that it uses list of existing
# data in package new data would have to be added outside of this

# to do for all data objects in package
for (i in seq_along(data_object_names)) {
  data_name <- data_object_names[i]
  # this sorts compression
  eval(parse(
    text = paste0(
      "usethis::use_data(",
      data_name,
      ", compress='xz', overwrite=TRUE)"
    )
  ))
}
