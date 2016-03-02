#data-raw/data_download_script.r

#how data is got into rnaturalearth
#reproducible workflow allowing package data to be updated e.g. when there are updates to Natural Earth. 
#just by sourcing this script

#For variable names I follow Natural Earth terminology :
#* small scale 1:110m
#* medium scale 1:50m
#* large scale 1:10m


#### use rnaturalearth::ne_download() to download data and read into R 


library(rnaturalearth)


countries110 <- ne_download(scale=110, type='countries', category='cultural')
map_units110 <- ne_download(scale=110, type='map_units', category='cultural')
sovereignty110 <- ne_download(scale=110, type='sovereignty', category='cultural')

countries50 <- ne_download(scale=50, type='countries', category='cultural')
map_units50 <- ne_download(scale=50, type='map_units', category='cultural')
sovereignty50 <- ne_download(scale=50, type='sovereignty', category='cultural')

countries10 <- ne_download(scale=10, type='countries', category='cultural')
map_units10 <- ne_download(scale=10, type='map_units', category='cultural')
sovereignty10 <- ne_download(scale=10, type='sovereignty', category='cultural')

states50 <- ne_download(scale=50, type='states', category='cultural')
states10 <- ne_download(scale=10, type='states', category='cultural')

#not saved yet, points for tiny countries
tiny_countries110 <- ne_download(scale=110, type='tiny_countries', category='cultural')

#http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_coastline.zip
coastline110 <- ne_download(scale=110, type='coastline', category='physical')
coastline50 <- ne_download(scale=50, type='coastline', category='physical')
coastline10 <- ne_download(scale=10, type='coastline', category='physical')


#### todo
#### version numbers, can I check the version number from the VERSION.txt file and save it in the package somewhere ?
#### would want to put that in ne_download()


#### investigating attribute data, chose not to trim

str(countries110@data)
#'data.frame':	177 obs. of  63 variables:
str(countries50@data)
#'data.frame':	241 obs. of  63 variables:
str(map_units110@data)
#'data.frame':	183 obs. of  63 variables:
str(sovereignty110@data)
#'data.frame':	171 obs. of  63 variables:
str(tiny_countries110@data)
#'data.frame':	37 obs. of  64 variables:
#but its a spatial points dataframe rather than polygons ...


#temporary for looking at the data 
# countries110data <- countries110@data
# countries50data <- countries50@data
# map_units110data <- map_units110@data
# sovereignty110data <- sovereignty110@data
# tiny_countries110data <- tiny_countries110@data
# states50data <- states50@data
# states10data <- states10@data

#states50 only has these countries
#unique(states50$admin)
#Australia                Brazil                   Canada                   United States of America
#length(unique(states10$admin))
#257

#which fields to keep
#i'm thinking it may be better to keep more fields, they take up very little space 
#and if we don't want to worry about joining it may be useful for users to have them
#fieldsToKeep <- c('admin','name','iso_a3','pop_est')
#fieldsToKeep <- c('admin','iso_a3','pop_est')

#remember the difference between 'admin' & 'name' in NatEarth, 'name' tends to be abbreviated


#### check polygon geometries (it seems to be no longer be necessary to correct these)
# require(rgeos)
# countries110@polygons=lapply(countries110@polygons, checkPolygonsHoles)


#### removing non-ascii characters from data files

# * checking data for non-ASCII characters ... WARNING
# Warning: found non-ASCII strings
# 'CuraC'ao' in object 'countries10'
# 'St-BarthC)lemy' in object 'countries10'
# 'CC4te d'Ivoire' in object 'countries10'
# 'SC#o TomC) and Principe' in object 'countries10'
# 'Saint-BarthC)lemy' in object 'countries10'
# 'Cland Islands' in object 'countries10'
# 'FC8royar Is. (Faeroe Is.)' in object 'countries10'
# 'Democratic Republic of SC#o TomC) and Principe' in object 'countries10'
# 'Nouvelle-CalC)donie' in object 'countries10'
# 'RC)publique Togolaise' in object 'countries10'
# 'RepC:blica Bolivariana de Venezuela' in object 'countries10'
# 'Ctte d'Ivoire' in object 'countries110'
# 'Nouvelle-Calidonie' in object 'countries110'
# 'Ripublique Togolaise' in object 'countries110'
# 'Repzblica Bolivariana de Venezuela' in object 'countries110'
# 'Curagao' in object 'countries50'
# 'St-Barthilemy' in object 'countries50'
# 'Ctte d'Ivoire' in object 'countries50'
# 'Sco Tomi and Principe' in object 'countries50'
# 'Saint-Barthilemy' in object 'countries50'
# 'Eland Islands' in object 'countries50'
# 'Fxroyar Is. (Faeroe Is.)' in object 'countries50'
# 'Democratic Republic of Sco Tomi and Principe' in object 'countries50'
# 'Nouvelle-Calidonie' in object 'countries50'
# 'Ripublique Togolaise' in object 'countries50'
# 'Repzblica Bolivariana de Venezuela' in object 'countries50'
# 'CuraC'ao' in object 'map_units10'
# 'St-BarthC)lemy' in object 'map_units10'
# 'CC4te d'Ivoire' in object 'map_units10'
# 'SC#o TomC) and Principe' in object 'map_units10'
# 'Saint-BarthC)lemy' in object 'map_units10'
# 'Cland Islands' in object 'map_units10'
# 'FC8royar Is. (Faeroe Is.)' in object 'map_units10'
# 'Democratic Republic of SC#o TomC) and Principe' in object 'map_units10'
# 'Nouvelle-CalC)donie' in object 'map_units10'
# 'RC)publique Togolaise' in object 'map_units10'
# 'RepC:blica Bolivariana de Venezuela' in object 'map_units10'
# 'BouvetC8ya' in object 'map_units10'
# 'Ctte d'Ivoire' in object 'map_units110'
# 'Nouvelle-Calidonie' in object 'map_units110'
# 'Ripublique Togolaise' in object 'map_units110'
# 'Repzblica Bolivariana de Venezuela' in object 'map_units110'
# 'Curagao' in object 'map_units50'
# 'St-Barthilemy' in object 'map_units50'
# 'Ctte d'Ivoire' in object 'map_units50'
#   'Sco Tomi and Principe' in object 'map_units50'
#   'Saint-Barthilemy' in object 'map_units50'
#   'Eland Islands' in object 'map_units50'
#   'Fxroyar Is. (Faeroe Is.)' in object 'map_units50'
#   'Democratic Republic of Sco Tomi and Principe' in object 'map_units50'
#   'Nouvelle-Calidonie' in object 'map_units50'
#   'Ripublique Togolaise' in object 'map_units50'
#   'Repzblica Bolivariana de Venezuela' in object 'map_units50'
#   'CC4te d'Ivoire' in object 'sovereignty10'
#   'SC#o TomC) and Principe' in object 'sovereignty10'
#   'Democratic Republic of SC#o TomC) and Principe' in object 'sovereignty10'
#   'RC)publique Togolaise' in object 'sovereignty10'
#   'RepC:blica Bolivariana de Venezuela' in object 'sovereignty10'
#   'Ctte d'Ivoire' in object 'sovereignty110'
#   'Ripublique Togolaise' in object 'sovereignty110'
#   'Repzblica Bolivariana de Venezuela' in object 'sovereignty110'
#   'Ctte d'Ivoire' in object 'sovereignty50'
#   'Sco Tomi and Principe' in object 'sovereignty50'
#   'Democratic Republic of Sco Tomi and Principe' in object 'sovereignty50'
#   'Ripublique Togolaise' in object 'sovereignty50'
#   'Repzblica Bolivariana de Venezuela' in object 'sovereignty50'

# states50@data <- data.frame( lapply(states50@data, function(x) iconv(x, "latin1", "ASCII", sub="")))
# states10@data <- data.frame( lapply(states10@data, function(x) iconv(x, "latin1", "ASCII", sub="")))

#to allow same operation on all data objects in the package
data_object_names <- data(package = "rnaturalearth")[["results"]][,"Item"]

#dangerous code to remove all non-ascii characters
#todo I might want to do something more intelligent than this
#e.g. currently Curaçao is converted to Curaao
for (i in 1:length(data_object_names))
{
  data_name <- data_object_names[i]
  data_object <- eval(parse(text = data_name))
  
  data_object@data <- data.frame( lapply(data_object@data, function(x) iconv(x, "latin1", "ASCII", sub="")))
  
  #but now I want to reallocate back to the named object
  #beware this is dangerous
  eval(parse(text=paste(data_name,"<- data_object")))
  
}


#### saving data files to correct folder in the package
#this relies on working directory being set to root of the package

#the lines below could be replaced by this dangerous eval(parse(text=)) loop
for (i in 1:length(data_object_names))
{
  data_name <- data_object_names[i]
  #eval(parse(text=paste0("save(",data_name,", file='data/",data_name,".rda'"))) 
  #this sorts compression
  eval(parse(text=paste0("devtools::use_data(",data_name,", compress='xz', overwrite=TRUE)"))) 
}

#devtools::use_data(countries110, compress='xz', overwrite=TRUE)
# save(countries110, file="data/countries110.rda")
# save(map_units110, file="data/map_units110.rda")
# save(sovereignty110, file="data/sovereignty110.rda")
# 
# save(countries50, file="data/countries50.rda")
# save(map_units50, file="data/map_units50.rda")
# save(sovereignty50, file="data/sovereignty50.rda")
# 
# save(countries10, file="data/countries10.rda")
# save(map_units10, file="data/map_units10.rda")
# save(sovereignty10, file="data/sovereignty10.rda")
# 
# save(states50, file="data/states50.rda")
# save(states10, file="data/states10.rda")
# 
# #save(tiny_countries110, file="data/tiny_countries110.rda")
# 
# save(coastline110, file="data/coastline110.rda")
# save(coastline50, file="data/coastline50.rda")
# save(coastline10, file="data/coastline10.rda")


