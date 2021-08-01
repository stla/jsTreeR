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
