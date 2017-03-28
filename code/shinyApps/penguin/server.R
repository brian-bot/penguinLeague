require(shiny)

getBatters <- function(team, period){
  allRosters[[period]][[team]][["battingStats"]]
}
getPitchers <- function(team, period){
  allRosters[[period]][[team]][["pitchingStats"]]
}

shinyServer(function(input, output, session) {
  
  # observe({
  #   invalidateLater(14400000, session)
  #   system('touch restart.txt')
  # })
  
  ## PERIOD PARSING
  per <- reactive({
    gsub(" ", "", tolower(input$period), fixed=T)
  })
  output$periodLabel <- renderUI({
    tagList(h2(paste(input$period, "Overview")))
  })
  
  ## PERIOD OVERVIEW TABLE
  output$pOverview <- renderDataTable({
    leagueStats[[per()]][ unlist(periods[[per()]]$matchups), ]
  }, options = list(info = FALSE, paginate = FALSE, filter = FALSE, searching = FALSE, ordering = FALSE))
  
  ## BATTING AND PITCHING STATS
  output$batStat <- renderDataTable({
    getBatters(input$team, per())
  }, options = list(info = FALSE, paginate = FALSE, filter = FALSE, searching = FALSE))
  output$pitchStat <- renderDataTable({
    getPitchers(input$team, per())
  }, options = list(info = FALSE, paginate = FALSE, filter = FALSE, searching = FALSE))
  
  ## STANDINGS
  output$standings <- renderDataTable({
    standings
  }, options = list(info = FALSE, paginate = FALSE, filter = FALSE, searching = FALSE, ordering = FALSE))
  
})

