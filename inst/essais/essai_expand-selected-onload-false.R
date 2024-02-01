library(jsTreeR)

nodes <- list(
  list(
    text = "RootA",
    state = list(selected = TRUE, undetermined = FALSE),
    type = "root",
    children = list(
      list(
        text = "ChildA1",
        state = list(selected = TRUE, undetermined = FALSE),
        type = "child",
        children = list(list(text = "ChildA12",
                             state = list(selected = TRUE, undetermined = FALSE),
                             type = "child"))
      ),
      list(text = "ChildA2",
           state = list(selected = TRUE, undetermined = FALSE),
           type = "child")
    )
  ),
  list(
    text = "RootB",
    state = list(selected = TRUE, undetermined = FALSE),
    type = "root",
    children = list(
      list(text = "ChildB1",
           state = list(selected = TRUE, undetermined = FALSE),
           type = "child"),
      list(text = "ChildB2",
           state = list(selected = TRUE, undetermined = FALSE),
           type = "child")
    )
  )
)

types <- list(root = list(icon = FALSE), child = list(icon = FALSE))

jstree(nodes,
       types = types,
       checkboxes = TRUE,
       coreOptions = list(expand_selected_onload = FALSE)
)
