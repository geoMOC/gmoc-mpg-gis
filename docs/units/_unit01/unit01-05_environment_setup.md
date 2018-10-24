---
title: "Example: Setting up the Working Environment"
toc: true
toc_label: In this example
---



Setting up a working or project environment requires the definition of different folder pathes and the loading of necessary R packages and additional functions. If additional software like GIS should also be accessible, respective binaries and software environments must be linked, too.

For setting up a project environment, one can use a set-up script and the `link2GI` package. 

It is a good idea to name the setup script somethin like `000_setup.R` and source it into every other script of the same project (i.e. include `source(<path-to-git-repository-folder>/src/000_setup.R)`)

## Loading the libraries
The first section of the setup script handles the loading of all required libraries.

```r
# Set libraries ----------------------------------------------------------------
libs = c("link2GI",
         "raster",
         "rgdal",
         "sp")
lapply(libs, require, character.only = TRUE)
```


## Setting up the folder pathes
The next section of the setup-script handles the definition of folder pathes. One has to define the root directory of the project and all subdirectories (make sure you include the trailing "/"). This information is supplied to the `link2GI::initProj()` function. It returns a list of the folder names and creates the folders if they do not exist, yet. For more information have a look at the manual.


```r
# Set pathes -------------------------------------------------------------------
# Automatically set root direcory depending on booted system
if(Sys.info()["sysname"] == "Windows"){
  filepath_base = "C:/Users/tnauss/permanent/edu/mpg-envinsys-plygrnd"
} else {
  filepath_base = "/media/memory/permanent/edu/mpg-envinsys-plygrnd"
}

# Set project specific subfolders
project_folders = c("data/",                                 # data folders
                    "data/aerial/", "data/lidar/", "data/grass/", 
                    "data/data_mof", "data/tmp/", 
                    "run/", "log/",                          # bins and logging
                    "name_of_github_team_repository/src/",   # source code
                    "name_of_github_team_repository/doc/")   # markdown etc. 

envrmt = initProj(projRootDir = filepath_base, GRASSlocation = "data/grass",
                  projFolders = project_folders, path_prefix = "path_", 
                  global = FALSE)
```
One can now access the respecive sufolders using the list entries of the variable `envrmt`. The entries are named according to the subfolder names with the prefix "path_".

```r
print(envrmt$path_data_tmp)
```

```
## [1] "C:/Users/tnauss/permanent/edu/mpg-envinsys-plygrnd/data/tmp/"
```

If the `raster` package has been loaded, it is a good choice to set the temp directory to the one of the just defined project environment.

```r
rasterOptions(tmpdir = envrmt$path_data_tmp)
```


## Linking GIS software
If required, on can now go on in the setup script and link selected GIS software. This generaly starts looking for the respective installations (in case one does not know all the details).

```r
# Link GIS software ------------------------------------------------------------
# Find GRASS installations
grass_path = findGRASS()

# Find SAGA installations
saga_path = findSAGA()

# Find OTB installations
otb_path = findOTB()
```

## More information on the link2GI package

<div id="presentation-embed-38909962"></div>
<script src='https://slideslive.com/embed_presentation.js'></script>
<script>
    embed = new SlidesLiveEmbed('presentation-embed-38909962', {
        presentationId: '38909962',
        autoPlay: false // change to true to autoplay the embedded presentation
    });
</script>
