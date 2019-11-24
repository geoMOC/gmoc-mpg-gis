---
title: "Best Practice Scripts & Functions in R"
toc: true
toc_label: In this example
---

How to organize programming in general and the creation of scripts or functions in particular is the best thing to do, opinions differ a lot. In order not to overstretch the arch, the following sources are worthwhile a visit - complexitiy is ascending...<!--more-->
- [r-bloggers](https://www.r-bloggers.com/r-code-best-practices/){:target="_blank"} best practices introduction
- [Efficient R programming](https://csgillespie.github.io/efficientR/coding-style.html){:target="_blank"} Coding style
- [USGS](https://owi.usgs.gov/blog/intro-best-practices/){:target="_blank"} best practices introduction

The probably supreme rule is to remain consistent in the naming of functions, variables, etc.. You will see in the example scripts that this is not as easy as it looks like... But never You will notice in the example scripts that this is easier said than done, but hope dies last.

For the beginning it is a recommendation to start a script with a header that includes informations about script type  author, scripts purpose, inputs and outputs if appropriate used/usable data and legal stuff. In addition it is very helpful to keep inline with a structure that addresses your workflow. That means something like a fixed structure loading packages, sourcing files, defining variables and so on.

A basic first corpus may look like below. Please note just write meaningful stufff into the header it is not a punishment but for clarification. 


```r
#------------------------------------------------------------------------------
# Type: control script for XXXXXX
#
# Author: Chris Reudenbach, creuden@gmail.com
#
# Description:  script creates a canopy height model CHM from generic LiDAR 
#              las data sets using the lidR package
#
# Input:       Airborne LiDAR (ALS) data set from the Hessian Authorithy
#
# Output:      Canopy Height Model as a raster file
#
# Copyright: Chris Reudenbach, Thomas Nauss 2017,2018,2019, GPL (>= 3)
# Version:   25-11-2019
#------------------------------------------------------------------------------


# 0 - load packages
#---------------------


# 1 - source files
#---------------------


# 2 - define variables
#---------------------


# 3 - start code 
#--------------------


```




Please revisit due to a growing set of examples during the course.