## ----kintr_setup, include=FALSE---------------------------------------------------
rootDIR="~/Schreibtisch/spatialstat_SoSe2020/"
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(root.dir = rootDIR)
knitr::opts_chunk$set(fig.path='{{ site.baseurl }}/assets/images/unit05/')



## ----setup, echo=TRUE,message=FALSE, warning=FALSE--------------------------------
rm(list=ls())
rootDIR="~/Schreibtisch/spatialstat_SoSe2020/"
## laden der benötigten libraries
# wir definieren zuerst eine liste mit den Paketnamen und 
# nutzen dann eine for  schleife die jedes element aus der  liste nimmt 
# und schaut ob es bereits installiert ist utils::installed.packages() 
# falls nicht wird es installiert 
libs= c("sf","mapview","tmap","tmaptools","spdep","ineq","cartography","spatialreg","ggplot2","usedist","raster","downloader","RColorBrewer","colorspace","viridis")
for (lib in libs){
  if(!lib %in% utils::installed.packages()){
    utils::install.packages(lib)
  }}
# nicht wundern lapply()ist eine integrierte for Schleife die alle im vector libs
# enthaltenen packages lädt indem sie den package Namen als character string an die 
# function library übergibt
invisible(lapply(libs, library, character.only = TRUE))


## ----loaddata, echo=TRUE,message=FALSE, warning=FALSE-----------------------------
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




## ----lm, echo=TRUE,message=FALSE, warning=FALSE-----------------------------------
lm_um = lm(Universitaeten.Mittel ~ Beschaeftigte, data=nuts3_kreise)
summary(lm_um)


## ----lmplot1, echo=TRUE,message=FALSE, warning=FALSE------------------------------
plot(nuts3_kreise$Beschaeftigte,nuts3_kreise$Universitaeten.Mittel, pch = 2, cex = 1.0, col = "red", main = "Universitaeten.Mittel ~ Beschaeftigte", xlab = "Beschaftigte", ylab = "Universitaeten.Mittel")
# hinzufügen der Regressionsgeraden
abline(lm_um )


## ----ggplot0, echo=TRUE,message=FALSE, warning=FALSE------------------------------
# berechnung und plotten des Regressionsmodells lm_um
ggplot(nuts3_kreise, aes(x = Beschaeftigte, y = Universitaeten.Mittel)) + 
  geom_point() +
  stat_smooth(method = "lm")



## ----ggplot2, echo=TRUE,message=FALSE, warning=FALSE------------------------------


# initialisiert den Basisdatensatz
  ggplot(lm_um$model, aes_string(x = names(lm_um$model)[2], y = names(lm_um$model)[1])) + 
# für den scatterplot hinzu
    geom_point() +
# sttistische glättungfals zuviele Daten corhanden sind     
    stat_smooth(method = "lm", col = "red") +
# fügt die Überschrift mit hilfe der in lm_um gespeicherten Modelldaten hinzu
    labs(title = paste("Adj R2 = ",signif(summary(lm_um)$adj.r.squared, 5),
                       "Intercept =",signif(lm_um$coef[[1]],5 ),
                       " Slope =",signif(lm_um$coef[[2]], 5),
                       " P =",signif(summary(lm_um)$coef[2,4], 5)))



## ----ggplot3, echo=TRUE,message=FALSE, warning=FALSE------------------------------

ggplotRegression <- function (fit,method="lm") {

ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
  geom_point() +
  stat_smooth(method = method, col = "red") +
  labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                     "Intercept =",signif(fit$coef[[1]],5 ),
                     " Slope =",signif(fit$coef[[2]], 5),
                     " P =",signif(summary(fit)$coef[2,4], 5)))
}

ggplotRegression(lm(Universitaeten.Mittel ~ Beschaeftigte, data=nuts3_kreise))

# loess model (Locally Weighted Scatterplot Smoothing)
ggplotRegression(lm(Universitaeten.Mittel ~ Beschaeftigte, data=nuts3_kreise),method = "loess")


## ----lmplot2, echo=TRUE,message=FALSE, warning=FALSE------------------------------
par(mfrow = c(2, 2))  
plot(lm_um)  
par(mfrow = c(1, 1))  


## ----ggplot1, echo=TRUE,message=FALSE, warning=FALSE------------------------------
# 1) Standrd ggplot des Regressionsmodells
ggplot(nuts3_kreise, aes(x = Beschaeftigte, y = Universitaeten.Mittel)) + 
  geom_point() +
  stat_smooth(method = "lm")


# 2) Zuweisung der Vorhersage- und Residualwerte ins nuts3_kreise Objekt
nuts3_kreise$predicted <- predict(lm_um)
nuts3_kreise$residuals <- residuals(lm_um)

# Wiederholung von 1) nur wird hier das Konfidenzintervall ausgeblendet se=FALSE, und als Farbe für die Gereade lightgrey gesetzt
# geom_segment zieht Linien  zwischen den Vorhersagewerten und Residuen während alpha die Linien transparent macht
ggplot(nuts3_kreise, aes(x = Beschaeftigte, y = Universitaeten.Mittel)) +
  geom_smooth(method = "lm", se = FALSE, color = "lightgrey") +
  geom_segment(aes(xend = Beschaeftigte, yend = predicted), alpha = .2) +

# Hier werden die Größen und Farben der Residuen erzeugt
  geom_point(aes(color = abs(residuals), size = abs(residuals))) + 
  scale_color_continuous(low = "black", high = "red") +
  guides(color = FALSE, size = FALSE) +  
  geom_point(aes(y = predicted), shape = 1) +
  theme_bw()
# alternativ mit Farben und ohne Größen
ggplot(nuts3_kreise, aes(x = Beschaeftigte, y = Universitaeten.Mittel)) +
  geom_smooth(method = "lm", se = FALSE, color = "lightgrey") +
  geom_segment(aes(xend = Beschaeftigte, yend = predicted), alpha = .2) +
  geom_point(aes(color = residuals)) +
  scale_color_gradient2(low = "blue", mid = "white", high = "red") +  
  guides(color = FALSE) +
  geom_point(aes(y = predicted), shape = 1) +
  theme_bw()




## ----basics, echo=TRUE,message=FALSE, warning=FALSE-------------------------------
library(RColorBrewer)
library(colorspace)
clrs_spec <- colorRampPalette(rev(brewer.pal(11, "Spectral")))
clrs_hcl <- function(n) {
  hcl(h = seq(230, 0, length.out = n), 
      c = 60, l = seq(10, 90, length.out = n), 
      fixup = TRUE)
  }
### function to plot a color palette
pal <- function(col, border = "transparent", ...)
{
 n <- length(col)
 plot(0, 0, type="n", xlim = c(0, 1), ylim = c(0, 1),
      axes = FALSE, xlab = "", ylab = "", ...)
 rect(0:(n-1)/n, 0, 1:n/n, 1, col = col, border = border)
}
pal(clrs_spec(100))
pal(desaturate(clrs_spec(100)))
pal(rainbow(100))



## ----rcolorbrewer, echo=TRUE,message=FALSE, warning=FALSE-------------------------
library(RColorBrewer)
display.brewer.all()


## ----ggplotcol, echo=TRUE,message=FALSE, warning=FALSE----------------------------
# berechnung und plotten des Regressionsmodells lm_um
ggplot(nuts3_kreise, aes(x = Beschaeftigte, y = Universitaeten.Mittel)) + 
  geom_point(color = nuts3_kreise$Beschaeftigte) +
  scale_color_viridis(option = "D")+
  stat_smooth(method = "lm")


## ----tmap, echo=TRUE,message=FALSE, warning=FALSE---------------------------------
# Darstellung mit tmap Farbgebung nach em Methode mit 8 Klassen mit Hilfe der cartography::getBreaks() Funktion  
tm_shape(nuts3_kreise) + 
  tm_fill(col = "Beschaeftigte",breaks = getBreaks(nuts3_kreise$Beschaeftigte,nclass = 8,method = "em"), alpha = 0.3,palette = viridisLite::viridis(20, begin = 0, end = 0.56))

