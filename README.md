# __jsTreeR__

<!-- badges: start -->
[![R-CMD-check](https://github.com/stla/jsTreeR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/stla/jsTreeR/actions/workflows/R-CMD-check.yaml)
[![](https://www.r-pkg.org/badges/version/jsTreeR?color=orange)](https://cran.r-project.org/package=jsTreeR)
[![](https://img.shields.io/badge/devel%20version-2.1.0-blue.svg)](https://github.com/stla/jsTreeR)
<!-- badges: end -->

A wrapper of the JavaScript library [jsTree](https://www.jstree.com/). 
This package is similar to [shinyTree](https://github.com/shinyTree/shinyTree) 
but it allows more options. It also provides a Shiny gadget allowing to 
manipulate one or more folders.


## Installation

Install from CRAN:

```r
install.packages("jsTreeR")
```

Or install the latest development version (on GitHub):

```r
remotes::install_github("stla/jsTreeR")
```


## Getting started

Please check the [Shiny examples](https://github.com/stla/jsTreeR/tree/master/inst/examples) (see `?jstreeExamples`).


![](https://raw.githubusercontent.com/stla/jsTreeR/master/inst/screenshots/jsTreeR_dragAndDrop-update.gif)

![](https://raw.githubusercontent.com/stla/jsTreeR/master/inst/screenshots/jsTreeR_search.gif)

![](https://raw.githubusercontent.com/stla/jsTreeR/master/inst/screenshots/jsTreeR_grid.png)

#### The 'folder gadget':

![](https://raw.githubusercontent.com/stla/jsTreeR/master/inst/screenshots/jsTreeR_folderGadget.gif)

#### The 'tree navigator' Shiny module:

![](https://raw.githubusercontent.com/stla/jsTreeR/master/inst/screenshots/jsTreeR_treeNavigator.gif)

The 'tree navigator' has not all the features of the 'folder gadget', it only 
allows to navigate in the server side file system and to select some files. 
But the 'folder gadget' loads all the structure of the root folder(s), while 
the 'tree navigator' loads the contents of a clicked folder only when this one 
is clicked by the user. And as a Shiny module, it is possible to build around 
it a more elaborated Shiny app.

___

# Copies of license agreements

The 'jsTreeR' package as a whole is distributed under GPL-3 (GNU GENERAL
PUBLIC LICENSE version 3).

It includes other open source software components. The following is a list of
these components:

- **jQuery**, https://github.com/jquery/jquery
- **jsTree**, https://github.com/vakata/jstree
- **jstree-bootstrap-theme**, https://github.com/orangehill/jstree-bootstrap-theme
- **jsTreeGrid**, https://github.com/deitch/jstree-grid
- **PDFObject**, https://github.com/pipwerks/PDFObject
- **SuperTinyIcons**, https://github.com/edent/SuperTinyIcons

Full copies of the license agreements used by these components are included in
the file [LICENSE.note](https://github.com/stla/jsTreeR/blob/master/LICENSE.note.md).
