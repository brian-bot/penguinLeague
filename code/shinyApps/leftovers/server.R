require(shiny)

getBatters <- function(period){
  allNonRosters[[period]][["battingStats"]]
}
getPitchers <- function(period){
  allNonRosters[[period]][["pitchingStats"]]
}

shinyServer(function(input, output) {
  
  ## PERIOD PARSING
  per <- reactive({
    gsub(" ", "", tolower(input$period), fixed=T)
  })
  
  output$battersLeft <- renderDataTable({
    getBatters[[per()]]
  })
  output$pitchersLeft <- renderDataTable({
    getPitchers[[per()]]
  })  
})
