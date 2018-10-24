# Create leaflet map of MOF

library(mapview)
library(sf)

setwd("C:\\Users\\tnauss\\permanent\\edu\\mpg-remote-sensing\\moer-mpg-remote-sensing\\staging\\html")

mapviewOptions(basemaps = mapviewGetOption("basemaps")[c(3, 1:2, 4:5)])

mof = read_sf("C:\\Users\\tnauss\\permanent\\edu\\mpg-envinsys-plygrnd\\data\\data_mof\\uwcWaldorte.shp", "uwcWaldorte")

m <- mapview(mof)

## create standalone .html
mapshot(m, url = "mof_map.html")
