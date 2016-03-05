#data-raw/data_download_script.r

#how data is got into rnaturalearth
#reproducible workflow allowing package data to be updated e.g. when there are updates to Natural Earth. 
#just by sourcing this script

#one example file in rnaturalearth
#scale 110 and 50 files in rntauralearthdata
#scale 10 files in rntauralearthhires

library(rnaturalearth)

countries110 <- ne_download(scale=110, type='countries', category='cultural')

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
# relies on working directory being set to root of the package

# to do for all data objects in package
for (i in 1:length(data_object_names))
{
  data_name <- data_object_names[i]
  #eval(parse(text=paste0("save(",data_name,", file='data/",data_name,".rda'"))) 
  #this sorts compression
  eval(parse(text=paste0("devtools::use_data(",data_name,", compress='xz', overwrite=TRUE)"))) 
}


