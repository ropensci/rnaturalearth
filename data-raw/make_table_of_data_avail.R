# data-raw/make_table_of_data_avail.r

# script to create tables to store in package of data available from Natural Earth

# TODO add dplyr, purrr to suggests, although if just here user doesn't need it

scales <- c(10L, 50L, 110L)

# PHYSICAL
# gives a list with one table for each scale
list_scales_phys <- purrr::map(
  scales,
  ne_find_vector_data,
  category = "physical"
)

# joining the 3 lists together to get 1 column per scale
# full_join because need all layers and can't rely on left table having more
df_layers_physical <- dplyr::full_join(
  list_scales_phys[[1L]],
  list_scales_phys[[2L]],
  by = "layer"
)

df_layers_physical <- dplyr::full_join(
  df_layers_physical,
  list_scales_phys[[3L]],
  by = "layer"
)

# rename column headers
names(df_layers_physical)[2L:4L] <- paste0("scale", scales)
# convert scale figures in columns to 0,1 to show layer availability
df_layers_physical[2L:4L] <- ifelse(is.na(df_layers_physical[2L:4L]), 0L, 1L)

# order alphabetically
df_layers_physical <- dplyr::arrange(df_layers_physical, layer)

# CULTURAL
list_scales_cult <- purrr::map(
  scales,
  ne_find_vector_data,
  category = "cultural"
)

# joining the 3 lists together to get 1 column per scale
# full_join because need all layers and can't rely on left table having more
df_layers_cultural <- dplyr::full_join(
  list_scales_cult[[1L]],
  list_scales_cult[[2L]],
  by = "layer"
)

df_layers_cultural <- dplyr::full_join(
  df_layers_cultural,
  list_scales_cult[[3L]],
  by = "layer"
)

# rename column headers
names(df_layers_cultural)[2L:4L] <- paste0("scale", scales)
# convert scale figures in columns to 0,1 to show layer availability
df_layers_cultural[2L:4L] <- ifelse(is.na(df_layers_cultural[2L:4L]), 0L, 1L)

# order alphabetically
df_layers_cultural <- dplyr::arrange(df_layers_cultural, layer)


# save both tables to the package
devtools::use_data(df_layers_physical, overwrite = TRUE)
devtools::use_data(df_layers_cultural, overwrite = TRUE)
