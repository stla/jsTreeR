library(shiny)
library(jsTreeR)

#Module with jstree
jstreeUI <- function(id) {
  ns <- NS(id)
  jstreeOutput(ns('tree'))
}


jstreeServer <- function(input,output,session,nodes=reactive(NULL)) {
  output$tree <- renderJstree({
    #Destroy the tree each time
    jstreeDestroy(session, session$ns('tree'))

    #Call the tree
    jsTreeR::jstree(
      nodes = nodes(),
      search = TRUE,
      multiple = FALSE,
      theme = "proton")
  })
}


#Main ui and server functions
mainUI <- fluidPage(
  checkboxInput('list1','A',value=T),
  jstreeUI('a')
)


mainServer <- function(input,output, session) {
  #Update the data structure when the checkbox changes
  nodes <- reactive({
    if (input$list1) {
      return(list(list(text = "AAAAAAA")))
    } else {
      return(list(list(text = "BBBBBBB")))
    }
  })

  #Call module with jstree
  callModule(module=jstreeServer, id='a', nodes=nodes)
}

#Run shiny app
shinyApp(ui = mainUI, server = mainServer)
