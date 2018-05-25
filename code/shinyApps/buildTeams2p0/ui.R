require(shiny)

shinyUI(navbarPage(
  title="PENGUIN LEAGUE TEAM SELECTION", 
  inverse=TRUE,
  
  tabPanel(
    title="Build Teams",
    sidebarLayout(
      sidebarPanel(
        conditionalPanel(
          condition = paste0("input.pw != '", penguinConfig, "'"),
          textInput("pw", "Who is this?")
        ),
        conditionalPanel(
          condition = paste0("input.pw == '", penguinConfig, "'"),
          uiOutput("whichRoster"),
          br(),
          wellPanel(uiOutput("selections"))
        )
      ),
      
      mainPanel(
        conditionalPanel(
          condition = paste0("input.pw == '", penguinConfig, "'"),
          uiOutput("tabHeader"),
          actionButton('dl', 'Save Roster'),
          br(),
          span(strong(uiOutput("saveYesMess"), style="color:blue")),
          span(strong(uiOutput("saveErrMess"), style="color:red")),
          span(strong(uiOutput("dupMess"), style="color:red")),
          br(),
          dataTableOutput("playerTable")
        )
      )
    )
  )
))


