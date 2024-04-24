# jsTreeR 2.6.0 (2024-04-25)

- The `jstree` function has a new argument `coreOptions`, allowing to pass a 
list of jsTree core options. For advanced usage.

- There was a JavaScript error occurring in Shiny apps when the browser window
was resized while using a jsTree grid in the app. It has been fixed.

- When a `jstree` had some reactive dependencies in a Shiny app, it was not 
re-rendered when these dependencies were updated.


# jsTreeR 2.5.0 (2023-12-19)

The Shiny input value `ID_full` now indicates the undetermined states regarding 
the checkboxes.


# jsTreeR 2.4.0 (2023-11-07)

- New option `checkWithText`; it is a `TRUE`/`FALSE` option about the behavior 
of the checkboxes: it controls whether the checkboxes must be (un)checked when
clicking on the text of a node (thanks @ismirsehregal for the feature request).

- The Shiny input value `ID_selected_tree` (see `?jstree-shiny`) has been 
renamed to `ID_checked_tree`, and there are new Shiny values provided when 
the checkboxes are enabled. Their description is given in `?jstree-shiny`.

- New feature for grids: when `search=TRUE`, there is now one search box for 
each column of the grid (thanks @ismirsehregal for the feature request and for 
the help).


# jsTreeR 2.3.3 (2023-10-10)

- Upgraded jsTree to 3.3.16.

- Added new JavaScript events related to nodes: opened, closed, and selected.


# jsTreeR 2.3.2 (2023-07-15)

- The `.onAttach` instance has been replaced with a `.onLoad` instance.


# jsTreeR 2.3.1 (2023-03-14)

- New example showing how to disable the context menu for some nodes (thanks @ismirsehregal).


# jsTreeR 2.3.0 (2023-02-09)

- New function `jstreeUpdate`, to update a tree in a Shiny app.


# jsTreeR 2.2.0 (2022-10-21)

- Fixed bug #11: the search bar was not destroyed by a call to `jstreeDestroy`.


# jsTreeR 2.1.0 (2022-06-07)

- New example showing how to use some images as icons (thanks @ismirsehregal).

- Upgrade of 'SuperTinyIcons'.


# jsTreeR 2.0.0 (2022-06-08)

- The package now provides the 'tree navigator' Shiny module, which allows to 
render a files and folders navigator in the server side file system.

- New Shiny input value accessible in `input$ID_selected_tree`. This is like 
`input$ID_selected` but it also provides the ascendants of the selected nodes. 

- Upgraded 'jsTree' library to the development version.


# jsTreeR 1.6.0 (2022-02-28)

New Shiny input value accessible in `input$ID_selected_paths`. This is like 
`input$ID_selected` but it gives the paths to the selected nodes instead of 
only the text field. This is useful when some nodes have the same string in 
the text field. 


# jsTreeR 1.5.0 (2022-01-10)

Added the new function `jstreeDestroy` which destroys a tree. It is necessary 
to call this function if you want to change the nodes of a tree.


# jsTreeR 1.4.0 (2021-09-19)

* Allow alternative ways to populate the tree: using a callback function, 
or using AJAX, possibly with lazy loading.
* Upgraded 'jstree' library to version 3.3.12.


# jsTreeR 1.3.1 (2021-08-14)

Added an example of custom context menu.


# jsTreeR 1.3.0 (2021-08-01)

* The `jstree` function has a new argument `selectLeavesOnly` for usage in 
Shiny; if `TRUE`, only the selected leaves are retained in the selection.
* Added some Shiny examples.
* Upgraded 'jstree' library to version 3.3.11.
* Dependency to the 'fontawesome' package.
* Dependency to the 'jquerylib' package.


# jsTreeR 1.2.0 (2021-01-16)

* Always exclude `.git` and `.Rproj.user` folders in the gadget.
* New Shiny example: filtering countries.


# jsTreeR 1.1.0 (2020-10-02)

* Removed an unwanted `print` statement in `folderGadget`.
* Added `trash` option to `folderGadget`; it adds a trash to the gadget, 
allowing to restore deleted elements.
* Added new context menu item 'Explore here' in `folderGadget`; it closes the 
gadget and relaunches it at the selected folder.


# jsTreeR 1.0.0 (2020-09-22)

* Better Shiny example 'SuperTinyIcons'.
* Removed `jsonlite` dependency.
* Allow to pass a list of options to the `contextMenu` argument.
* The Shiny value of the tree is now updated when the user 
creates/deletes/renames/pastes a node.
* New Shiny value `jsTreeMoved` triggered when a node is moved.
* New Shiny value `jsTreeRenamed` triggered when a node is renamed.
* New Shiny value `jsTreeCopied` triggered when a node is copied.
* New Shiny value `jsTreeDeleted` triggered when a node is deleted.
* New Shiny value `jsTreeCreated` triggered when a node is created.
* New function `folderGadget`, which launches a Shiny gadget allowing to 
manipulate one or more folders.



# jsTreeR 0.1.0 (2020-08-26)

First release.
