---
title: "Automated setup of working environment"
toc: true
toc_label: In this example
---

Setting up a working or project environment requires the definition of different folder paths and the loading of necessary R packages and additional functions. If, in addition, external APIs (application programming interface) of QGIS, SAGA, GRASS Orfeo Toolbox (to name the most important) are to be integrated stably and without great effort, the associated paths and environment variables must also be defined correctly. 

<!--more-->

## Basic idea

There are several R-packages like e.g. [workflowR](https://jdblischak.github.io/workflowr/){:target="_blank"} or [usethis](https://usethis.r-lib.org/){:target="_blank"}  which provide a wide range of functions for such issues. For the entry into a structured organization of R-based development projects, we suggest a slimmed down version. 

Essentially four categories of tasks are to be served:

- Organization of data 
- Organization of scripts
- Organization of documentation
- Organization of environment variables for external programs

The basis of the aforementioned categories is an adequate storage structure on a suitable permanent storage medium (hard disk, USB stick, cloud, etc.). We suggest a meaningful hierarchical directory structure. The root folder of a project is the basis of an organizational structure branched below.

## Defining folders manually

In the following, the folders are defined first as examples. 

```r
# define a project rootfolder
rootDir = "~/edu/mpg-envinsys-plygrnd"     # This is the rootfolder of the whole project 

# Set project specific subfolders
projectDirList   = c("data/",                # data folders the following are obligatory but you may add more
                    "data/auxdata/",  
                    "data/aerial/org/",
                    "data/lidar/org/",
                    "data/lidar/",
                    "data/grass/",
                    "data/lidar/level1/",
                    "data/lidar/level2/",
                    "data/lidar/level0/",
                    "data/data_mof", 
                    "data/tmp/",
                    "run/",                # folder for runtime data storage
                    "log/",                # logging
                    "src/",                # source code
                    "doc/",                # documentation  
                    "name_of_github_team_repository/src/",   # source code github
                    "name_of_github_team_repository/doc/")   # markdown etc.  github

                    

```

## Introduction of the envimaR helper package 
It would now be convenient if these folders defined as lists were automatically created and read in. For the needs of the course we have written a small project management package called `envimaR` that takes over these tasks. It is located on `github` and can be installed as known.

```r
devtools::install_github("envima/envimaR")
```

First I want to find out which folder structure can be used sensibly on my system. So the use of the so called `H:` drive on the pool PCs is extremely problematic due to the underlying `dfs//` network assignment and therefore to be avoided. For an automatic query on which computer I am currently working (and therefore which root directory I want to use) use the function `envimaR::alternativeEnvi`. 

```r
require(envimaR)
envimaR::alternativeEnvi(root_folder = rootDir,              # if exist this is the root dir 
                         alt_env_id = "COMPUTERNAME",        # check the environment varialbe "COMPUTERNAME"
                         alt_env_value = "PCRZP",            # if it contains the string "PCRZP" (e.g. local PC-Pools)
                         alt_env_root_folder = "F:/BEN/edu") # use the alternative rootfolder
```


Provided I want to create a project with the obligatory folder structure defined above, checking the PC I am working on, load all packages I need  and store all environment variables in a list for latter use  I may use the `createEnvi` function. To do so I first have to define a list of all packages that I want to load. 

```r
# list of packages to load
packagesToLoad = c("lidR", "link2GI", "mapview", "raster", "rgdal", "rlas", "sp", "sf")

# Automatically set root direcory, folder structure and load libraries
envrmt = envimaR::createEnvi(root_folder = rootDir,
                             folders = projectDirList,
                             path_prefix = "path_",              # prefix to all path variables that are created 
                             libs = packagesToLoad,                        # list of R-packages that should be loaded
                             alt_env_id = "COMPUTERNAME",        # check the environment varialbe "COMPUTERNAME"
                             alt_env_value = "PCRZP",            # if it contains the string "PCRZP" (e.g. local PC-Pools)
                             alt_env_root_folder = "F:/BEN/edu") # use the alternative rootfolder
                         

```

I will receive something like the following messages. Note even if red colored these are no error messages...


```bash
Loading required package: lidR
Loading required package: raster
Loading required package: sp
lidR 2.1.2 using 2 threads. Help on <gis.stackexchange.com>. Bug report on <github.com/Jean-Romain/lidR>.
Loading required package: link2GI
Loading required package: mapview
Loading required package: rgdal
rgdal: version: 1.4-7, (SVN revision 845)
 Geospatial Data Abstraction Library extensions to R successfully loaded
 Loaded GDAL runtime: GDAL 3.0.1, released 2019/06/28
 Path to GDAL shared files: 
 GDAL binary built with GEOS: TRUE 
 Loaded PROJ.4 runtime: Rel. 6.2.0, September 1st, 2019, [PJ_VERSION: 620]
 Path to PROJ.4 shared files: (autodetected)
 Linking to sp version: 1.3-1 
Loading required package: rlas
Loading required package: uavRst
```
## Wrap it up in a setup script

Finally, some useful settings have to be made. So it makes sense to have the current github versions of the non CRAN packages available and for the `raster` package you should also set an option for temporary actions.

If you put everything together in one script it looks like this:


```r
### mpg course basic setup
# install/check from github
devtools::install_github("envima/envimaR")
devtools::install_github("gisma/uavRst")
devtools::install_github("r-spatial/link2GI")

packagesToLoad = c("lidR", "link2GI", "mapview", "raster", "rgdal", "rlas", "sp", "sf")

# Source setup script
require(envimaR)
rootDir = envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd",
                                       alt_env_id = "COMPUTERNAME",
                                       alt_env_value = "PCRZP",
                                       alt_env_root_folder = "F:/BEN/edu")


# Set project specific subfolders
projectDirList   = c("data/",                # data folders the following are obligatory but you may add more
                    "data/auxdata/",  
                    "data/aerial/org/",
                    "data/lidar/org/",
                    "data/lidar/",
                    "data/grass/",
                    "data/lidar/level1/",
                    "data/lidar/level2/",
                    "data/lidar/level0/",
                    "data/data_mof", 
                    "data/tmp/",
                    "run/",                # folder for runtime data storage
                    "log/",                # logging
                    "src/",                # source code (generally used scripts)
                    "doc/")                # documentation markdown etc.

# Automatically set root direcory, folder structure and load libraries
envrmt = envimaR::createEnvi(root_folder = rootDir,
                             folders = projectDirList,
                             path_prefix = "path_",
                             libs = packagesToLoad,
                             alt_env_id = "COMPUTERNAME",
                             alt_env_value = "PCRZP",
                             alt_env_root_folder = "F:/BEN/edu")
## set raster temp path
raster::rasterOptions(tmpdir = envrmt$path_tmp)
```

Please **check** the result by navigating to the directory using your favorite file manger. In addition please check the returned list. It contains all paths as character strings in a convenient  list structure

```r
# traditionally
str(envrmt)

# more fancy
require(listviewer)
listviewer::jsonedit(envrmt)  
```

## Concluding remarks and considerations
It is very useful to save this script in the `src` folder (e.g. under `mpg_course_basic_setup.R`) and **source it before every** start of an analysis script connected with this project, i.e. read in:
```r
source(file.path(envimaR::alternativeEnvi(root_folder = "~/edu/mpg-envinsys-plygrnd",
                                       alt_env_id = "COMPUTERNAME",
                                       alt_env_value = "PCRZP",
                                       alt_env_root_folder = "F:/BEN/edu"),
                  "src/mpg_course_basic_setup.R"))
```

The script thus available provides as intended:

- a basic folder structure for data storage and processing and doc
- a list variable containing all paths 
- folder for documentation

What still is missing is the organization of environment variables for external programs. But we will soon integrate it.