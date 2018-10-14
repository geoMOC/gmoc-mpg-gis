---
title: "Unmarked Assignment: Data Collection and Working Environment"
toc: true
toc_label: In this worksheet
---

This worksheet focuses on getting remote sensing data and its I/O in R.

After completing this worksheet, you should have a structured working environment and be able to read and write raster geo-data in R.

## Things you need for this worksheet
  * [R](https://cran.r-project.org/) — the interpreter can be installed on any operation system.
  * [RStudio](https://www.rstudio.com/) — we recommend to use R Studio for (interactive) programming with R.
  * [Git](https://git-scm.com/downloads) environment for your operating system. For Windows users with little experience on the command line we recommend [GitHub Desktop](https://desktop.github.com/).
  * Remote sensing data provided by the course instructors.

## Remote sensing data I/O
Please create the working environment for this course following the mandatory settings provided by the [info on assignments]({{ site.baseurl }}/unit01/unit01-04_notes_on_assignments#mandatory-working-environment).

Download the remote sensing data required for this course using the link provided by the course instructors. 

Please write an R markdown script with html output which describes how to read and write the provided remote sensing datasets in R. 

Save your Rmd file in your course repository, knitr it, update (i.e. commit) your local repository and publish (i.e. push) it to the GitHub classroom. Make sure that the created html file is also part of your GitHub repository.

The R package [*raster*](https://cran.r-project.org/web/packages/raster/index.html) is a good starting point for raster data I/O.
{: .notice--info}