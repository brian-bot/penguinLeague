require(shiny)
require(shinythemes)

shinyUI(navbarPage(
  title="PENGUIN LEAGUE TEAM SELECTION", 
  inverse=TRUE,
  
  tabPanel(
    title="PL Leftovers",
    br(),
    selectInput(inputId='period', label='PERIOD', choices=paste("Period", seasonPeriods), selected=paste("Period", currentPeriod)),
    br(),
    navlistPanel(
      tabPanel(
        title="Batting Stats",
        dataTableOutput("battersLeft")
      ),
      tabPanel(
        title="Pitching Stats",
        dataTableOutput("pitchersLeft")
      )
    )
  )
))
  