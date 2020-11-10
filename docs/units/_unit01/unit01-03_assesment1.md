---
title: Unmarked Assignment - How do I determine tree heights?
toc: true
toc_label: In this worksheet
---

## Software and problem solving

This reader covers an brief exercise on how to handle different types of geoinformation using different software tools.

After completing this worksheet you should have an idea about the ecosystem of basic GI-software tools.


## The problem

First of all we want to start with some practical work. If we want to derive a phenomena called *"Canopy height"*, we have to think about some details. At least we have to define or understand some things:
- what exactly could be meant with  *Canopy height* in real world 
- what could be an adequate data set to derive and/or represent it? 
- How is a *Canopy height*  then looking like in this data set 

and so on.... So the general questions arise:

* What I am dealing with?
* How to deal with? 
* What kind of tool and data is adequate?

## GI-Tools

There is a whole number of high performance Closed and Open Source GIS software packages. It is beyond the scope of this unit to discuss the different strengths and weaknesses of all of them. To choose one of the main packages - ESRI, Hexagon, GRASS, QGIS, SAGA ... is somehow arbitrary. Nevertheless besides the pure habituation the main reasons to choose this ones is caused by their suitability for specific and/or raster and/or vector based analysis as well as their comprehensive and scientific motivated extensions. 

By the way most of the packages (and all open source packages) support a generic API for R and python as well as command line (shell) capabilities. Maybe you are interested in a more differentiated discussion. There is a lot of engaged people around who try to compare and evaluate GIS-Software packages. Unfortunately this is a very hard job due to extreme short update cycles, an increasing development speed and specific flavors of each package (have a look i.e. at [Geovison](http://gis-vision.de/index.php/systeme-im-vergleich) (in German). Additionally you will find a are bunch of possible discussions about to use what package for what problem and so on. But be careful in believing everything you read - the best way is: Just try it by yourself!

However at a first glance we can assume that at least most of them should be able to provide basic GIS operations with comparable results. In fact not even this assumption is quite true but nevertheless we won't take care of it.


## How to operationalize it?

Traditionally we eat what we know (and so on ;-)). So regularly we will use the software that we have started to learn. If we do not know special GIS-Software we maybe will use Google Earth or even a old fashioned map. Due to this behaviors we can observe some strange workarounds or obviously strange results. The stories about this would fill many pages. 

But let's focus on our problem. Probably your first attempt is to risk a look on the software you are hopefully familiar with. Additionally you probably try to find a tool that sound like i.e. *"make canopy height"*.

It is not really necessary to say that in most situation that are a bit more sophisticated, a *"click one button approach"* will not exist. Mainly because of the creative urges you need for your solution. Exactly this is the situation for ambitious and advanced users or researchers.

But how can we escape? One of the most practicable way is to ask somebody. This works even better if you did analyze and understand what you want. In real life is the combination of both very successful. Both approaches are supporting each other you can ask better and more focused questions if you understand what you are asking for and vice versa thinking about your questions supports your needs to understand how and what you want to do. Sounds like an easy approach. 

Again in real life you have to to it by your own. That means "Google is your friend" and "read the fu..... manuals and papers". So let's start and try it. For a brief introduction feel free to read [Spotlight Landscapes]({{ site.baseurl }}{% link _unit05/unit05-11_Exkurs_Paradigms.md %}){:target="_blank"}.



Now please have a look at the data sets at the [biosense](http://gofile.me/3Z8AJ/I97PxrE1b) server. Just to help you a little bit out. You will find some typical LiDAR data sets. Now Google for the data and how to deal with it. Then try to open it with i.e. QGIS or SAGA GIS or what you prefer. Just try to:

* Visualize the data
* Describe what you see

Basically that approach will be the way to head through the course.