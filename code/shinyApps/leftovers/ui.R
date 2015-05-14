require(shiny)
require(shinythemes)

shinyUI(navbarPage(
  title="PENGUIN LEAGUE LEFTOVERS", 
  inverse=TRUE,
  
  tabPanel(
    title="PL Secret Admin Layer",
    conditionalPanel(
      condition = paste0("input.pw != '", penguinConfig, "'"),
      textInput("pw", "What is the word?")
    ),
    conditionalPanel(
      condition = paste0("input.pw == '", penguinConfig, "'"),
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
  )
))
  