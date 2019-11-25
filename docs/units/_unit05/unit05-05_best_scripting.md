---
title: "Best Practice Scripts & Functions in R"
toc: true
toc_label: In this example
---

Opinions differ widely on how best to organize the programming workflow in general and the development of scripts and functions in particular. The probably supreme rule is to remain consistent in the naming of functions, variables, etc.. You will see in the example scripts that this is not as easy as it looks like...

In order not to overstretch the arch, the following sources are worthwhile a visit - complexity is ascending...<!--more-->
- [r-bloggers](https://www.r-bloggers.com/r-code-best-practices/){:target="_blank"} best practices introduction
- [Efficient R programming](https://csgillespie.github.io/efficientR/coding-style.html){:target="_blank"} Coding style
- [USGS](https://owi.usgs.gov/blog/intro-best-practices/){:target="_blank"} best practices introduction


For the beginning it is a recommendation to start a script with a header that includes information about script type  author, scripts purpose, inputs and outputs if appropriate used/usable data and legal stuff. In addition it is very helpful to keep inline with a structure that addresses your workflow. That means something like a fixed structure loading packages, sourcing files, defining variables and so on.

A basic first corpus may look like below. Please note just write meaningful stuff into the header it is not a punishment but for clarification. 


```r
# ===============================================================================
# xyz.R
# Author: Chris Reudenbach, creuden@gmail.com
# Copyright: Chris Reudenbach, Thomas Nauss 2017,2018,2019, GPL (>= 3)
#
# Description:  script creates a canopy height model CHM from generic LiDAR 
#               las data sets using the lidR package
#
# Input:       Airborne LiDAR (ALS) data set from the Hessian Authorithy
#
# Output:      Canopy Height Model as a raster file
#
# Remarks:  BLABLA
# ===============================================================================


# 0 - load packages
#---------------------


# 1 - source files
#---------------------


# 2 - define variables
#---------------------


# 3 - start code 
#--------------------


```

## Introduction to functions

The use of function is imperative and ubiquitous the sooner you start the better. The principle is simple: Identify processes that are performed more than once and pack them into your own independent script:

Have a look at the [R function](https://swcarpentry.github.io/r-novice-inflammation/02-func-R/) exercises.

## Splitting up the LiDAR control file

At the moment there are no major advantages to using functions. This is due to the fact that we have just created a batch file where more or less linear external functions (e.g. those of the lidR package) are processed.
Allerdigns batch or control file already starts to get confusing. Therefore, it is helpful to separate individual functionalities. E.g. the preprocessing of the data up to the catalog. On this basis the later analyses should take place. Therefore, this part of our control file does not have to be run through again and again. Even if it is not a very good example for a function it would be convenient to just call the cutting algorithm with the data file, the cutting coordinates and the environment variables.
Please note the following examples alredy uses the `Roxygen` package notation for automated documentation. 

```r

# ===============================================================================
# cut_mof.R
#
# Author: Chris Reudenbach, creuden@gmail.com
#
# Copyright: Chris Reudenbach, Thomas Nauss 2017-2019, GPL (>= 3)
#
# ===============================================================================
#
#'cut a LAS file via lidR catalog to a given extent
#' function expects an las file in the envrmt$path_lidar_org folder
#' default coordinates and proj system is the mof_hal_moon and coresponding proj
#'@param coord vector of minx,miny,maxx,maxy coordinates
#'@param proj4 projection string oin proj4 format
#'@param envrmt  list of path variables as derived by the envimaR package
#'
#'# extracted lasfile is written in corresponding directory a lidR catalog is returned
#'
#'@examples
#'mof <- cut_mof(coord  = c(477600.0,5632500.0,478350.0,5632500.0),
#'               proj   = proj4<- sp::CRS("+init=epsg:32632"), 
#'               envrmt = envrmt)




cut_mof<- function( coord  = c(477600.0,5632500.0,478350.0,5632500.0),
                    proj   = proj4<- sp::CRS("+init=epsg:32632"), 
                    envrmt = NULL){

                    
# assign the coords
xmin<-coord[1]
ymin=coord[2]
xmax=coord[3]
ymax=coord[4]

 las_files= list.files(envrmt$path_lidar_org, pattern = glob2rx("*.las"), full.names = TRUE)
if (!file.exists(las_files[1])) return(cat(paste0("no las file found please check ",envrmt$path_lidar_org)))

###############  TODO Check it #####################

#---- if you run into memory shortages set up the a lidR catalog 
# we need it for better handling poor available memory 
# check on https://rdrr.io/cran/lidR/man/catalog.html

 core_aoimof_ctg = lidR::readLAScatalog(envrmt$path_lidar_org)
 sp::proj4string(core_aoimof_ctg) <- sp::CRS(proj4) 
 future::plan(multisession, workers = 2L)
 lidR::set_lidr_threads(4)
 lidR::opt_chunk_size(core_aoimof_ctg) = 100
 lidR::opt_chunk_buffer(core_aoimof_ctg) <- 5


#---- If not cut the original data to new extent 
# note if using the catalog exchange lidR::readLAS(las_files[1]) with core_aoimof_ctg
# check on https://rdrr.io/cran/lidR/man/lasclip.html
core_aoimof<- lidR::lasclipRectangle(lidR::readLAS(las_files[1]), xleft = xmin, ybottom = ymin, xright = xmax, ytop = ymax)

#---- write the new dataset to the level0 folder and create a corresponding index file (lax)
lidR::writeLAS(core_aoimof,file.path(envrmt$path_level0,"las_mof.las"))
rlas::writelax(file.path(envrmt$path_level0, "las_mof.las"))

return(core_aoimof)
}

```

The `makeChmCatalog.R` script can be shortened significantly:

```r
# ===============================================================================
# makeChmCatalog.R
#
# Author: Chris Reudenbach, creuden@gmail.com
#
# Copyright: Chris Reudenbach, Thomas Nauss 2017-2019, GPL (>= 3)
#
# ===============================================================================

#' creates a canopy height model from generic Lidar las data using the lidR package
#'  
#' In addition the script cuts the area to a defined extent using the lidR catalog concept.
#' Furthermore the data is tiled into a handy format even for poor memory 
#' and a canopy height model is calculated
#'
#' Input:  regular las LiDAR data sets 
#' Output: Canopy heightmodel RDS file of the resulting catalog
#
#================================================================================


# 0 - load packages
#-----------------------------
library("future")

# 1 - source files
#-----------------
source(file.path(envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd",
                                          alt_env_id = "COMPUTERNAME",
                                          alt_env_value = "PCRZP",
                                          alt_env_root_folder = "F:/BEN/edu"),
                 "src/mpg_course_basic_setup.R"))


# 2 - define variables
#---------------------

# get viridris color palette
pal<-mapview::mapviewPalette("mapviewTopoColors")

# 3 - start code 
#-----------------


# cut the origdata to the AOI
mof <- cut_mof(coord  = c(477600.0,5632500.0,478350.0,5632500.0),
               proj   = proj4<- sp::CRS("+init=epsg:32632"), 
               envrmt = envrmt)

#---- calculate chm following example 1 from the help
# Remove the topography from a point cloud 
dtm <- lidR::grid_terrain(mof, 1, lidR::kriging(k = 10L))
mof_norm <- lidR::lasnormalize(mof, dtm)

# Create a CHM based on the normalized data and a DSM by pitfree()
# if the error  "filename exists; use overwrite=TRUE" occures navigate to the 
# paste0(envrmt$path_normalized,"/{ID}_norm") and delete the tif files

lidR::opt_output_files(mof_norm) <- paste0(envrmt$path_normalized,"/{ID}_chm") # add output filname template
chm_all = grid_canopy(mof_norm, 1.0, dsmtin())

#chm_all = grid_canopy(mof_norm_kri, 1.0, pitfree(c(0,2,5,10,15), c(0,1)))

# write it to tiff
raster::writeRaster(chm_all,file.path(envrmt$path_data_mof,"mof_chm_all.tif"),overwrite=TRUE) 

# 4 - visualize 
-------------------

## set mapview raster options to full resolution
## check on https://r-spatial.github.io/mapview/
mapview::mapviewOptions(mapview.maxpixels = 1000*1000)

## visualize the catalogs
mapview(mof100_ctg) + mapview(mof_norm, zcol= "Max.Z" ),url="mof_sapflow_ctg.html"

## call mapview with some additional arguments
mapview(raster::raster(file.path(envrmt$path_data_mof,"mof_chm_all.tif")),
         legend=TRUE, 
         layer.name = "canopy height model",
         col = pal(256),
         alpha.regions = 0.65)


```