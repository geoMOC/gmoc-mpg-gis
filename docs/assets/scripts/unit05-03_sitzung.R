## ----kintr_setup, include=FALSE-------------------------------------
rootDIR="~/Schreibtisch/spatialstat_SoSe2020/"
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(root.dir = rootDIR)
knitr::opts_chunk$set(fig.path='{{ site.baseurl }}/assets/images/unit05/')



## ----setup, echo=TRUE,message=FALSE, warning=FALSE------------------
rm(list=ls())
rootDIR="~/Schreibtisch/spatialstat_SoSe2020/"
## laden der benötigten libraries
# wir definieren zuerst eine liste mit den Paketnamen und 
# nutzen dann eine for  schleife die jedes element aus der  liste nimmt 
# und schaut ob es bereits installiert ist utils::installed.packages() 
# falls nicht wird es installiert 
libs= c("sf","mapview","tmap","spdep","ineq","cartography", "tidygeocoder","usedist","raster","kableExtra","downloader","rnaturalearthdata")
for (lib in libs){
  if(!lib %in% utils::installed.packages()){
    utils::install.packages(lib)
  }}
# nicht wundern lapply()ist eine integrierte for Schleife die alle im vector libs
# enthaltenen packages lädt indem sie den package Namen als character string an die 
# function library übergibt
invisible(lapply(libs, library, character.only = TRUE))


## ----loaddata, echo=TRUE,message=FALSE, warning=FALSE---------------
#---------------------------------------------------------
# nuts3_autocorr.R 
# Autor: Chris Reudenbach, creuden@gmail.com
# Urheberrecht: Chris Reudenbach 2020 GPL (>= 3)
#
# Beschreibung: Skript berechnet unterschiedliche Autokorrelationen aus den Kreisdaten
#  
#--------------------
##- Laden der Kreisdaten
#--------------------

# Aus der Sitzung Eins werden die gesäuberten Kreisdaten von github geladen und eingelesen

download(url ="https://raw.githubusercontent.com/GeoMOER/moer-mhg-spatial/master/docs/assets/data/nuts3_kreise.rds",     destfile = "nuts3_kreise.rds")

# Einlesen der nuts3_kreise Daten
nuts3_kreise = readRDS("nuts3_kreise.rds")

# Gleiches gilt für die Punktdaten der Städte
download(url ="https://raw.githubusercontent.com/GeoMOER/moer-mhg-spatial/master/docs/assets/data/geo_coord_city.rds",     destfile = "geo_coord_city.rds")

# Einlesen der city  Daten
geo_coord_city = readRDS("geo_coord_city.rds")

# zu Demozwecken wird ein Rasterdatensatz  (Corine Daten für Deutschland heruntergeladen und eingelesen)

download(url ="https://raw.githubusercontent.com/GeoMOER/moer-mhg-spatial/master/docs/assets/data/lulc_nuts3_kreise.tif",     destfile = "lulc_nuts3_kreise.tif")
lulc_nuts3_kreise = raster("lulc_nuts3_kreise.tif")



## ----tmap-intro, echo=TRUE,message=FALSE, warning=FALSE-------------

# Definition von nuts3_kreise mit der Aufforderung diese Fläche zu füllen
tm_shape(nuts3_kreise) +
  tm_fill() 
# erzeuge geometrien
tm_shape(nuts3_kreise) +
  tm_borders() 
# füllen und darstellen der geometrien
tm_shape(nuts3_kreise) +
  tm_fill() +
  tm_borders() 

# abkürzung mit der Bequemlichkeitsfunktion qtm
qtm(nuts3_kreise) 


## ----tmap-1, echo=TRUE,message=FALSE, warning=FALSE-----------------

map_nuts3_kreise = tm_shape(lulc_nuts3_kreise)

map_nuts3_kreise + tm_raster(style = "cont", palette = "YlGn") +
  tm_scale_bar(position = c("left", "bottom"))



## ----tmap-aest, echo=TRUE,message=FALSE, warning=FALSE--------------
tmap_mode("plot")
map1 = tm_shape(nuts3_kreise) + tm_fill(col = "red")
map2 = tm_shape(nuts3_kreise) + tm_fill(col = "red", alpha = 0.3)
map3 = tm_shape(nuts3_kreise) + tm_borders(col = "blue")
map4 = tm_shape(nuts3_kreise) + tm_borders(lwd = 3)
map5 = tm_shape(nuts3_kreise) + tm_borders(lty = 2)
map6 = tm_shape(nuts3_kreise) + tm_fill(col = "red", alpha = 0.3) +
  tm_borders(col = "blue", lwd = 3, lty = 2)
tmap_arrange(map1, map2, map3, map4, map5, map6)



## ----tmap-aest2, echo=TRUE,message=FALSE, warning=FALSE-------------
# Standardeinstellungen
tm_shape(nuts3_kreise) + 
  tm_fill(col = "Beschaeftigte")



# Darstellung mit tmap Farbgebung nach gleicher Klassenabstand
tm_shape(nuts3_kreise) + 
  tm_polygons("Beschaeftigte",    breaks=seq(0,1250000, by=150000))

# Darstellung mit tmap Farbgebung nach Jenks Methode mit 8 Klassen mit Hilfe der cartography::getBreaks() Funktion 
tm_shape(nuts3_kreise) + 
  tm_fill(col = "Beschaeftigte",breaks = getBreaks(nuts3_kreise$Beschaeftigte,nclass = 8,method = "jenks"))

# Darstellung mit tmap Farbgebung nach em Methode mit 8 Klassen mit Hilfe der cartography::getBreaks() Funktion  
tm_shape(nuts3_kreise) + tm_fill(col = "Beschaeftigte",breaks = getBreaks(nuts3_kreise$Beschaeftigte,nclass = 8,method = "em"))


## ----tmap-aest3, echo=TRUE,message=FALSE, warning=FALSE-------------

# Darstellung mit tmap Farbgebung nach Jenks mit 5 Klassen mit Hilfe der tmap eigenen Funktion aus tm_fill()  
# dazu werden Titel und Legende auserhalb dargestellt und ein weiterer Datensatz (Anteil.Hochschulabschluss) überlagert
legend_title = expression("Beschäftigte /Kreis")
tm_shape(nuts3_kreise) + 
  tm_fill(col = "Beschaeftigte",title = legend_title, style = "jenks" ) + 
  tm_layout(main.title = "Landkreise in Deutschland",legend.outside = TRUE,main.title.size = 0.8,legend.title.size = 0.8) +  
  tm_symbols(col = "green",  border.col = "black", size = "Anteil.Hochschulabschluss") 


