---
title: "Control files and functions"
toc: true
toc_label: In this example
---


At the moment there don't seem to be any real advantages to using functions instead of control scripts.  The main reason is that we just created a batch file that simply processes external functions (e.g. those of the lidR package) one after the other.
<!--more-->
However, we also notice that we still have to do a lot of preprocessing and already the control files are starting to get cluttered. 
Therefore it makes sense to separate and generalize some repetitive functionalities.  For example, the preprocessing of the lidar data up to the correct setup of the catalog. 

Keep in mind we should go one step further and [follow Hadley Wickham's explanation](https://r4ds.had.co.nz/functions.html#when-should-you-write-a-function) when you should write a function?  

## Splitting up the control file
However we start simply with splitting up the control files to clarify the structure and reduce the redundant repetitions.

It is a good practice to separate at least setup of a projet, data pre-processing, data analysis and the presentation of the results. 
{: .notice--success}

This separation means that we need a kind of a master control script that rules the workflow and provides general settings. 

We start bottom up. First we transform the clipping into a function.


### Seperating the clipping of an arbitrary Area of Interest from LAS data

So if I want to extract a section from a LAS file it would be very helpful to be able to call this as a function. In this call at least the data file and the coordinates have to be passed.

Furthermore it is mandatory for further projects to have a detailed or standardized documentation. This costs once more time but pays off more than.  Please note that the following examples already use the `Roxygen2` documentation syntax which can be used later for automated documentation 



```r
#------------------------------------------------------------------------------
# Type: control script 
# Name: 10_CHM_Catalog.R
# Author: Chris Reudenbach, creuden@gmail.com
# Description:  script creates a canopy height model from generic Lidar 
#              las data using the lidR package. In addition the script cuts the area to 
#              a defined extent using the lidR catalog concept.
#              Furthermore the data is tiled into a handy format even for poor memory 
#              and a canopy height model is calculated
# Data: regular las LiDAR data sets 
# Output: Canopy heightmodel RDS file of the resulting catalog
# Copyright: Chris Reudenbach, Thomas Nauss 2017,2020, GPL (>= 3)
#------------------------------------------------------------------------------

## clean your environment
rm(list = ls()) 
gc()

# 0 - load packages
#-----------------------------

library("future")



# 1 - source files
#-----------------
source(file.path(envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd",
                                          alt_env_id = "COMPUTERNAME",
                                          alt_env_value = "PCRZP",
                                          alt_env_root_folder = "F:/BEN/edu/mpg-envinsys-plygrnd"),
                 "msc-phygeo-class-of-2020-creu/src/000_setup.R"))


# 2 - define variables
#---------------------

# switch if lasclip is called
lasclip = TRUE
set.seed(1000)



# 3 - start code 
#-----------------

#---- if not clipped yet
if (lasclip){
  crop_aoimof = cut_mof( coord  = c(xmin,ymin,xmax,ymax),
                        chunksize = 250,
                        overlap = 10,
                        envrmt = envrmt)
} else   crop_aoimof = readRDS(file= file.path(envrmt$path_level1,"crop_aoimof.rds"))

#---- We assume that you have the "crop_aoimof" catalog stored in envrmt$path_level0 

# the fastest and simplest algorithm to interpolate a surface is given with p2r()
# the available options are  p2r, dsmtin, pitfree
dsm_p2r_1m = grid_canopy(crop_aoimof, res = 1, algorithm = p2r())
plot(dsm_p2r_1m)              

# now we calculate a digital terrain model by interpolating the ground points 
# and creates a rasterized digital terrain model. The algorithm uses the points 
# classified as "ground" and "water (Classification = 2 and 9 according to LAS file format 
# available algorithms are  knnidw, tin, and kriging
dtm_knnidw_1m <- grid_terrain(crop_aoimof, res=1, algorithm = knnidw(k = 6L, p = 2))
plot(dtm_knnidw_1m)

# we remove the elevation of the surface from the catalog data and create a new catalog
crop_aoimof_chm <- lidR::normalize_height(crop_aoimof, dtm_knnidw_1m)

# if you want to save this catalog  an reread it  you need 
# to uncomment the following lines
#- saveRDS(mof100_ctg_chm,file= file.path(envrmt$path_level1,"mof100_ctg_chm.rds"))
#- mof100_ctg_chm<-readRDS(file.path(envrmt$path_level1,"mof100_ctg_chm.rds"))


# Now create a CHM based on the normalized data and a CHM with the dsmtin() algorithm
# Note the DSM (digital surface model) is now a CHM because we 
# already have normalized the data

# first set a NEW  output name for the catalog
lidR::opt_output_files(crop_aoimof_chm) <- paste0(envrmt$path_normalized,"/{ID}_chm_dsmtin") # add output filname template

# calculate a chm raster with dsmtin()/p2r
chm_dsmtin_1m = grid_canopy(crop_aoimof_chm, res=1.0, dsmtin())

# write it to a tif file
raster::writeRaster(chm_dsmtin_1m,file.path(envrmt$path_data_mof,"chm_dsmtin_1m.tif"),overwrite=TRUE) 

# 4 - visualize 
# -------------------

## standard plot command

plot(raster::raster(file.path(envrmt$path_data_mof,"chm_dsmtin_1m.tif")))

## call mapview with some additional arguments
mapview(raster(file.path(envrmt$path_data_mof,"chm_dsmtin_1m.tif")),
        map.types = "Esri.WorldImagery",  
        legend=TRUE, 
        layer.name = "canopy height model",
        col = pal(256),
        alpha.regions = 0.65)


```
### Adaption of 000_setup.R

To utilize this conept we need to adapt the `000_setup.R` script. Basically we have add the argument `fkts` which is pointing to a folder which contains all of our functions - in this case the `cut_mof()` function. Addtionally we have moved some of the common variables and options in the basic setup file. 

```r
#---- mpg course basic setup
# install/check from github
devtools::install_github("envima/envimaR")
#devtools::install_github("gisma/uavRst")
devtools::install_github("r-spatial/link2GI")

library(envimaR)

packagesToLoad = c("lidR", "link2GI", "mapview", "raster", "rgdal", "rlas", "sp",  "sf")

mvTop<-mapview::mapviewPalette("mapviewTopoColors")
mvSpec<-mapviewTopoColors<-mapview::mapviewPalette("mapviewSpectralColors")

# get viridris colAZor palette
pal<-mapview::mapviewPalette("mapviewTopoColors")

#########################################################################

# define rootfolder
rootDir = envimaR::alternativeEnvi(root_folder = "/home/creu/edu/mpg-envinsys-plygrnd/",
                                   alt_env_id = "COMPUTERNAME",
                                   alt_env_value = "PCRZP",
                                   alt_env_root_folder = "F:/BEN/edu")


# define project specific subfolders
projectDirList   = c("data/",                # datafolders for all kind of date
                     "data/auxdata/",        # the following used by scripts however
                     "data/aerial/",     # you may add whatever you like                     
                     "data/aerial/org/",     # you may add whatever you like
                     "data/lidar/org/",
                     "data/lidar/",
                     "data/grass/",
                     "data/lidar/level0/",                     
                     "data/lidar/level1/",
                     "data/lidar/level1/normalized",
                     "data/lidar/level1/ID",
                     "data/lidar/level2/",
                     "data/lidar/level0/all/",
                     "data/data_mof", 
                     "data/tmp/",
                     "run/",                # temporary data storage
                     "log/",                # logging
                     "src/",                # scripts
                     "/doc/")                # documentation markdown etc.

############################################################################
############################################################################
############################################################################
# setup of root directory, folder structure and loading libraries
# returns "envrmt" list which contains the folder structure as short cuts
envrmt = envimaR::createEnvi(root_folder = rootDir,
                             folders = projectDirList,
                             path_prefix = "path_",
                             libs = packagesToLoad,
                             alt_env_id = "COMPUTERNAME",
                             alt_env_value = "PCRZP",
                             fcts_folder = file.path(rootDir,"msc-phygeo-class-of-2020-creu/src/fun/"),
                             alt_env_root_folder = "F:/BEN/edu")
# set raster temp path
raster::rasterOptions(tmpdir = envrmt$path_tmp)

## dealing with the crs warnings is cumbersome and complex
## you may reduce the warnings with uncommenting  the following line
## for a deeper  however rarely less confusing understanding have a look at:
## https://rgdal.r-forge.r-project.org/articles/CRS_projections_transformations.html
## https://www.r-spatial.org/r/2020/03/17/wkt.html
rgdal::set_thin_PROJ6_warnings(TRUE)

###############################
# test area so called "sap flow halfmoon"
xmin = 477500
ymin = 5631730
xmax = 478350
ymax = 5632500

## define current projection ETRS89 / UTM zone 32N
## the definition of proj4 strings is DEPRCATED have a look at the links under section zero
epsg = 25832
# for reproducible random
set.seed(1000)

return(envrmt)
```
### Main Control File
```r
#------------------------------------------------------------------------------
# Type: control script 
# Name: 00_preprocess_RGB.R
# Author: Chris Reudenbach, creuden@gmail.com
# Description:  - fixes the white areas of airborne RGB images
#               - merge all image to one image
#               - clip the image to the sapflow half moon
#               - calculates synthetic bands
#               
#              
#              
# Data: regular authority provided airborne RGB imagery 
# Output: merged, clipped and corrected image of AOI, stack of synthetic bands
# Copyright: Chris Reudenbach, Thomas Nauss 2017,2020, GPL (>= 3)
# git clone https://github.com/GeoMOER-Students-Space/msc-phygeo-class-of-2020-creu.git
#------------------------------------------------------------------------------

## clean your environment
## 
rm(list=ls()) 


# 0 - load additional packages
#-----------------------------
# for an unique combination of all files in the file list
# google expression: rcran unique combination of vector 
# alternative google expression: expand.grid unique combinations
# have a look at: https://stackoverflow.com/questions/17171148/non-redundant-version-of-expand-grid
library(gtools)
require(envimaR)

# 1 - source setup file


source(file.path(envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd",
                                          alt_env_id = "COMPUTERNAME",
                                          alt_env_value = "PCRZP",
                                          alt_env_root_folder = "F:/BEN/edu/mpg-envinsys-plygrnd"),
                 "msc-phygeo-class-of-2020-creu/src/000_setup.R"))



# 2 start analysis 
#-----------------
## step 05
source(file.path(rootDir,"msc-phygeo-class-of-2020-creu/src/fun_rs/05_prepcrocess_RGB.R"))

## step 20
source("src/fun_rs/20_calculate_synthetic_bands.R")



```
