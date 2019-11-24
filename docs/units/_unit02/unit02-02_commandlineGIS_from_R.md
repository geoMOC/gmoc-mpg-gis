---
title: Why using R?
toc: true
toc_label: In this worksheet
---


## Why using R instead of QGIS et al.?
Why we are using the R environment and why we are not using one of the other powerful scripting languages as Python, Perl or Ruby? It is definitely  hard, if not impossible, to give an concluding answer. 

For beginners R seems at the moment both easy to learn and a very powerful tool to handle analyze and visualize a wide range of (geo)data. This integrates not only a wide range of GIS libraries and APIs as well as an increasing number of specialized packages. Additionally it offers a very flexible and advanced approach to perform (geo)statistics and modeling. Furthermore for advanced users it is easy to mix R with C++ and arbitrary other scripting languages. 

To make it as easy as possible **and** as powerful as necessary we will focus on R as the **one for all** scripting language and we think that we have not backed the wrong horse.

## IDE and OS 
If not already done we need now to organize our future workspace and project. First setup your preferred environment that you appreciate and feel comfortable with. For R there are a lot of R specific Integrated Development Environments (IDE) around ([Rstudio](http://www.rstudio.com/), [Statistiklabor](http://www.statistiklabor.de), [JGR](http://www.rforge.net/JGR), [RKWard](http://rkward.sourceforge.net/wiki/Main_Page/RKWard)). Which one you prefer is owed to personal flavor but we strongly recommend RStudio. [[courses:msc:msc-phygeo-data-analysis:lecture-notes:da-ln-01|Using RStudio]] you have all in one. A comfortable editor, perfect integration of the command line, integrated previews, version control, automatic generating documentation, debugger, help and so on. Overall seen pretty nice. 

There are some problems around the automatic installation with the [osgeo4w64](http://trac.osgeo.org/osgeo4w) installer for Windows. Up to a certain point it depends on the Windows version you are using and what software you have already installed. Furthermore you need administration privileges to make some changes in the environment settings. As you know this is not possible at university labs. 

Even more obstructive is that the integration of RStudio needs some path informations of the used modules and the R version.

  * Windows users will find help at: [HowTo install WinGis2Go](http://giswerk.org/doku.php?id=tutorials:softgis:oswingis2go)
  * Linux users may be interested in [Linux GIS Distros](http://giswerk.org/doku.php?id=tutorials:softgis:xubuntu:intro).



##  QGIS as a GUI

Next to QGIS, SAGA and GRASS are the best known "traditional" but nevertheless very powerful open source GIS software suites. Both provide a graphical user interface (GUI) (even if you need a while to get used to it). Due to their origin the complete functionality can be used from command line (cli). They can be use with the major operating systems (OS). Since SAGA version 2.10  the commands line calls are unified for both operating systems. Both GIS software are also directly supported by R using wrapper packages (if you have installed compatible versions!).  

Make sure that you have activated all necessary settings under ''Menu->Processing''. Please check if under ''Processing Options->Providers->SAGA'' the check-box for ''Activate'' is ticked. If you run a version prior to 2.10 you have to set also a tick mark at ''Enable SAGA 2.08 compatibility''. On newer systems this option is obsolete. Finally check under ''Processing Options→General'' the option ''Keep dialog after running an algorithm''. Otherwise the GUI will close after performing the task and we will hardly be able to learn from it.

There are two common ways to use SAGA (or GRASS) from R. One can use the RSAGA/rgrass7 wrapper packages and similar, but without full integration in the R surrounding, you can pass all commands as system calls to the OS-shell.

The latter approach is very straightforward and has a big advantage for beginners. There are no version conflicts and dependencies and you can copy and paste GUI generated (GDAL/toolbox) command line source code snippets into your R script. To get familiar with the scripting concept, we will start with the ''CLI''-approach. The R ''system'' resp. ''system2'' are a useful functions that passes a command string to the OS. All what we need is the correct command of the the required application.

If you are still wondering why we don't just "click" the modules ins QGIS, SAGA or Grass: keep in mind  that you probably don't want to spend the whole semester clicking around in your preferred software...

## GDAL
  
We want to deal with geodata. Even with respect to the improvements of the last years this can become a real nasty task. Not only because of dozens and dozens of different formats and versions, but also due to missing, wrong or weird meta data and conceptual problems with the used data models.

So everybody prefers to to this job as reliable but still as simple as possible. Therefore all folks (since 2013 even the guys from Clark Labs ;-)) uses the [GDAL](http://www.gdal.org) resp. the [OGR](http://www.gdal.org/ogr) libraries. Again there are two different ways: Using them as executable binaries from shell or integrate them as libraries. We will start with the first option. 

GDAL can be used not only for format conversions. To get an first overview please have a look at   [OGR-Formats](http://www.gdal.org/ogr/ogr_formats.html) and [GDAL-Formats](http://www.gdal.org/formats_list.html). You will find a bunch of additional tools and helpers. For example how to clip, project and analyze data and so on. If it is possible to do things with gdal just do in most cases it is the fastest and most reliable way to solve your problems. There are a lot of snippets at the [GDAL documentation page](http://www.gdal.org/gdal_tutorial.html). So again, we strongly recommended to visit it.

