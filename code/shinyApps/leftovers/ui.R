require(shiny)
require(shinythemes)


shinyUI(fluidPage(
  selectInput(inputId='period', label='PERIOD', choices=paste("Period", seasonPeriods), selected=paste("Period", currentPeriod)),
  br(),
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
))
