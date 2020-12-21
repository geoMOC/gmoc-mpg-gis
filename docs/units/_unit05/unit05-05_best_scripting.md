---
title: "Splitting up the LiDAR control file"
toc: true
toc_label: In this example
---


At the moment there don't seem to be any real advantages to using functions instead of control scripts.  The main reason is that we just created a batch file that simply processes external functions (e.g. those of the lidR package) one after the other.
However, we also notice that we still have to do a lot of preprocessing and already the control files are starting to get cluttered. 
Therefore it makes sense to separate and generalize some repetitive functionalities.  For example, the preprocessing of the lidar data up to the correct setup of the catalog. 
The analysis of the data should be placed in another separate script and so on.  This division means that this part of our control file does not have to be called over and over again.  So if I want to extract a section from a LAS file it would be very helpful to be able to call this as a function. In this call at least the data file and the coordinates have to be passed.

Furthermore it is mandatory for further projects to have a detailed or standardized documentation. This costs once more time but pays off more than.  Please note that the following examples already use the `Roxygen2` documentation syntax which can be used later for automated documentation 


```r

# ===============================================================================
# cut_mof.R
#
# Author: Chris Reudenbach, creuden@gmail.com
#
# Copyright: Chris Reudenbach, Thomas Nauss 2017-2020, GPL (>= 3)
#
# ===============================================================================
#
#'cut a LAS file via lidR catalog to a given extent
#' function expects an las file in the envrmt$path_lidar_org folder
#' default coordinates and proj system is the mof_hal_moon and coresponding proj
#'@param coord vector of minx,miny,maxx,maxy coordinates
#'@param EPSG code for projection purposes
#'@param envrmt  list of path variables as derived by the envimaR package
#'@param chunksize size of tiles
#'@param overlap overlap of tiles
#'@detail Note the input file(s) must be stored in envrmt$path_level0, 
#' while the output catalog is written to envrmt$path_level1
#'@examples
#'mof <- cu t_mof(coord  = c(477500.0,5631730.0,478350.0,5632500.0),
#'               proj   = 25832, 
#'               envrmt = envrmt)
#'               
cut_mof<- function( coord  = NULL,
                    epsg = 25832, 
                    chunksize = 250,
                    overlap = 10,
                    envrmt = NULL) {
  if (is.null(envrmt)) return(warning("no pathes provided..."))
  if (is.null(coord)) return(warning("no coordinates provided"))
  #---- if you run into memory shortages set up the a lidR catalog 
  # setting up a lidR catalog structure
  core_aoimof_ctg <- lidR::readLAScatalog(envrmt$path_level0)
  projection(core_aoimof_ctg) <-sf::st_crs(25832)
  lidR::opt_chunk_size(core_aoimof_ctg) = chunksize
  future::plan(multisession)
  lidR::opt_chunk_buffer(core_aoimof_ctg) <- overlap
  lidR::opt_output_files(core_aoimof_ctg) <- paste0(envrmt$path_normalized,"/{ID}_norm") # add output filname template
  core_aoimof_ctg@output_options$drivers$Raster$param$overwrite <- TRUE
  
  #---- crop the original data to new extent 
  crop_aoimof <- lidR::lasclipRectangle(core_aoimof_ctg, 
                                        xleft = coord[[1]], 
                                        ybottom = coord[[2]], 
                                        xright = coord[[3]], 
                                        ytop = coord[[4]])
  
  #---- write the new dataset to the level1 folder
  saveRDS(crop_aoimof,file= file.path(envrmt$path_level1,"crop_aoimof.rds"))
  return(crop_aoimof)
}

```
As a first result the `makeChmCatalog.R` script can be shortened significantly:

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

return(envrmt)
```

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

return(envrmt)
```
