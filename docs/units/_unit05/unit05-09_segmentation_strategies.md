---
title: "Segmentation Strategies"
toc: true
toc_label: In this example
---
In nature conservation, forestry and landscape management, quantifiable knowledge is available over a wide area and is closely linked to remote sensing. Especially the LiDAR data are of inheritable importance as they offer the possibility to recognize microstructures and to distinguish tree individuals from each other. If a delimitation is successful, tree positions, tree heights, growth rates and horizontal and vertical distribution patterns can be calculated.
<!--more-->

## Tree segmentation - an overview
For the sake of simplification, two fundamentally different procedures can be distinguished. (1) Rasterization of the 3D point data and application of different mostly resilient segmentation algorithms (2) Evaluation of the 3D point cloud by voxelization and assignment of labels.  

As a rule, however, complex processing chains are developed which link several approaches including the additional information of image data. 

Here a distinction can and must be made between robust application on the one hand and specific optimization for special cases on the other hand.  For the goal of the course, a combination of several methods is certainly goal-oriented, but not every processing chain can be implemented.

Therefore, we first focus on the traditional segmentation algorithms based on rasterized point clouds, the so-called canopy height models.
The following two articles provide a good introduction to the established approach. The Pirotti et al. (2017) article, which deals explicitly with the comparison of algorithms implemented in `lidR`, should be mentioned here in particular. In contrast, the article by Quin et al. 2015 is a typical example of a combined approach and especially worth reading with regard to the combined teaching goal.

## Hands on

According to the overall Spotlight [LiDAR data handling & more]({{ site.baseurl }}{% link _unit05/unit05-05_best_scripting.md %}){:target="_blank"}.  It seems to be a good starting point to have a look at Jean-Romain Roussels vignettes and tutorials. There are a lot of excellent tutorials on his github pages dealing with tree segmentation and metrics computation:
* [Segementation and Metrics](https://github.com/Jean-Romain/lidR/wiki/Segment-individual-trees-and-compute-metrics){:target="_blank"}. 
* [Derived metrics at the grid level](https://jean-romain.github.io/lidRbook/aba.html){:target="_blank"}
* [Derived metrics at the tree level](https://jean-romain.github.io/lidRbook/tba.html){:target="_blank"}
* [Derived metrics at the voxel level](https://jean-romain.github.io/lidRbook/vba.html){:target="_blank"}
* [Derived metrics at the point level](https://jean-romain.github.io/lidRbook/pba.html){:target="_blank"}
* [Indiviual Tree Segementation](https://jean-romain.github.io/lidRbook/engine.html#engine-its){:target="_blank"}

## Further Readings
[Quin et al.](https://www.researchgate.net/profile/Clement_Mallet/publication/305400942_Individual_tree_segmentation_over_large_areas_using_airborne_LiDAR_point_cloud_and_very_high_resolution_optical_imagery/links/5790836308ae108aa03edfcc/Individual-tree-segmentation-over-large-areas-using-airborne-LiDAR-point-cloud-and-very-high-resolution-optical-imagery.pdf){:target="_blank"} Individual tree segmentation over large areas using airborne LiDAR point cloud and very high resolution optical imagery

[Pirotti et al.](https://www.researchgate.net/publication/319854966_A_COMPARISON_OF_TREE_SEGMENTATION_METHODS_USING_VERY_HIGH_DENSITY_AIRBORNE_LASER_SCANNER_DATA/fulltext/59be814d0f7e9b48a2987d62/A-COMPARISON-OF-TREE-SEGMENTATION-METHODS-USING-VERY-HIGH-DENSITY-AIRBORNE-LASER-SCANNER-DATA.pdf){:target="_blank"} A Comparison of Tree Segmentation Methods using very high Density Airborne Laser Scanner Data


