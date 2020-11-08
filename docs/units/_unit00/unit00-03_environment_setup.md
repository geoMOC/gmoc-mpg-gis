---
title: "Setting up the Working Environment"
toc: true
toc_label: In this example
---



Setting up a working or project environment usually requires the definition and creation of different folder paths, the loading of necessary R packages and additional functions that are "always" needed. If additional software like GIS should also be accessible, respective binaries and software environments must be linked, too.

For a very straightforward setup up a project environment, one can use the functionality of the `link2GI` package. 

It is a good idea to name the setup script something like `mpg_course_basic_setup.R` and source it into every other script of the same project (i.e. include `source(<path-to-git-repository-folder>/src/000_setup.R)`)

## Loading the libraries
The first section of the setup script handles the loading of all required libraries.

```r
# load libraries
packagesToLoad = c("lidR", "link2GI", "mapview", "raster", "rgdal", "rlas", "sp", "uavRst", "sf")
lapply(packagesToLoad, require, character.only = TRUE)
```


## Setting up the folder paths
The next section of the setup-script handles the definition of folder paths. One has to define the root directory of the project and all sub-directories (make sure you include the trailing "/"). This information is supplied to the `link2GI::initProj()` function. It returns a list of the folder names and creates the folders if they do not exist, yet. For more information have a look at the manual.


```r
# Set pathes -------------------------------------------------------------------
# root directory Note the ~ is  synonym to the environment variable "HOME"
rootDir = "~/edu/mpg-envinsys-plygrnd" }

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

envrmt = initProj(projRootDir = rootDir, 
                  GRASSlocation = "data/grass",
                  projFolders = projectDirList, 
                  path_prefix = "path_", 
                  global = FALSE)
```
One can now access the respective subfolders using the list entries of the variable `envrmt`. The entries are named according to the subfolder names with the prefix "path_".

```r
str(envrmt)
```

If the `raster` package has been loaded, it is a good choice to set the temp directory to the one of the just defined project environment.

```r
rasterOptions(tmpdir = envrmt$path_data_tmp)
```


## Linking GIS software
If required, on can now go on in the setup script and link selected GIS software. The `link2GI` functions `linkXXX` search for executable files of the respective software packages at the usually used installation locations and automatically select the version with the highest version number without having set any further argument. 

Please note: Linking the GIS software requires that QGIS, SAGA and GRASS is installed in advance. For installation hints you may visit the [RQGIS installation guide](https://github.com/jannes-m/RQGIS/blob/master/vignettes/install_guide.Rmd).

```r
# Link GIS software ------------------------------------------------------------
# Find GRASS installations
grass_path = linkGRASS7()

# Find SAGA installations
saga_path = linkSAGA()

# Find OTB installations
otb_path = linkOTB()
```

For a more advanced and automated project setup have also a look at the [extended setup spotlight]({{ site.baseurl }}{% link _unit05/unit05-02_extended_setup.md %})

