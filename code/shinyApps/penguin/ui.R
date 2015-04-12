require(shiny)
require(shinythemes)

shinyUI(navbarPage(
  title="PENGUIN LEAGUE",
  inverse=TRUE,
  theme=shinytheme("spacelab"),
  
  ## PERIOD OVERVIEW TAB (MAIN LANDING PAGE)
  tabPanel(
    title = "Period Overview",
    fluidPage(
      fluidRow(
        column(
          width=4,
          h1(""),
          br(),
          br(),
          img(src="penguin-159864_640.png", width='90%')
        ),
        column(
          width=8,
          uiOutput('periodLabel'),
          br(),
          dataTableOutput("pOverview")
        )
      )
    )
  ),
  ## TEAM STATS
  tabPanel(
    title = "Team Stats",
    fluidRow(
      column(
        width=4,
        selectInput(inputId='team', label='TEAM', choices=allTeams)
      ),
      column(
        width=4,
        selectInput(inputId='period', label='PERIOD', choices=paste("Period", seasonPeriods), selected=paste("Period", currentPeriod))
      )
    ),
    navlistPanel(
      tabPanel(
        title="Batting Stats",
        dataTableOutput("batStat")
      ),
      tabPanel(
        title="Pitching Stats",
        dataTableOutput("pitchStat")
      )
    )
  ),
  ## STANDINGS PAGE
  tabPanel(
    title = "Standings",
    h2("UNDER CONSTRUCTION - COMING SOON!")
  )
  
))

