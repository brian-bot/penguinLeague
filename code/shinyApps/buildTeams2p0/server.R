require(shiny)

readRosterFile <- function(path){
  a <- read.delim(path, as.is=T)
  rownames(a) <- a$players
  return(a)
}

## SHINY SERVER LOGIC
shinyServer(function(input, output, session){
  
  vals <- reactiveValues()
  
  ## ROSTER FILE FOR SELECTED TEAM / PERIOD
  rosterFile <- reactive({
    file.path(baseDataDir, "penguinRosters", paste("period", input$whichPeriod, sep=""), paste(gsub(" ", "", tolower(input$penguinTeam)), ".tsv", sep=""))
  })
  
  ## HEADER TEXT
  output$tabHeader <- renderUI({
    tagList(
      h2(paste("Roster for", input$penguinTeam))
    )
  })
  
  ## UI FOR TEAM AND PERIOD
  output$whichRoster <- renderUI({
    tagList(
      selectInput(inputId='penguinTeam', label='Penguin Team', choices=allTeams),
      selectInput(inputId='whichPeriod', label='Period', choices=seasonPeriods, selected=currentPeriod)
    )
  })
  
  ## ALL OF THE SELECT OPTIONS PRE-POPULATED WITH CURRENT ROSTER
  output$selections <- renderUI({
    if( is.null(input$penguinTeam) | is.null(input$whichPeriod) ){
      return(NULL)
    }
    path <- rosterFile()
    if( file.exists(path) ){
      rost <- readRosterFile(path)
      
      posList <- lapply(as.list(posMap), function(x){
        tmp <- allNames[allNames %in% rost$players[rost$position == x]]
        if( length(tmp) == 0 ){
          return(NULL)
        } else{
          return(tmp)
        }
      })
      names(posList) <- posMap
    } else{
      posList <- list()
    }
    
    tagList(
      selectInput(inputId='posC', label='C', choices=allNames, multiple=TRUE, 
                  selected=posList[["C"]]),
      selectInput(inputId='pos1b', label='1B', choices=allNames, multiple=TRUE, 
                  selected=posList[["1B"]]),
      selectInput(inputId='pos2b', label='2B', choices=allNames, multiple=TRUE, 
                  selected=posList[["2B"]]),
      selectInput(inputId='pos3b', label='3B', choices=allNames, multiple=TRUE, 
                  selected=posList[["3B"]]),
      selectInput(inputId='posSs', label='SS', choices=allNames, multiple=TRUE, 
                  selected=posList[["SS"]]),
      selectInput(inputId='posMi', label='MI', choices=allNames, multiple=TRUE, 
                  selected=posList[["MI"]]),
      selectInput(inputId='posCi', label='CI', choices=allNames, multiple=TRUE, 
                  selected=posList[["CI"]]),
      selectInput(inputId='posOf', label='OF', choices=allNames, multiple=TRUE, 
                  selected=posList[["OF"]]),
      selectInput(inputId='posDh', label='DH', choices=allNames, multiple=TRUE, 
                  selected=posList[["DH"]]),
      selectInput(inputId='posBatBench', label='Batter Bench', choices=allNames, multiple=TRUE, 
                  selected=posList[["BAT BENCH"]]),
      selectInput(inputId='posSp', label='Starting Pitcher', choices=allNames, multiple=TRUE, 
                  selected=posList[["SP"]]),
      selectInput(inputId='posRp', label='Relief Pitcher', choices=allNames, multiple=TRUE, 
                  selected=posList[["RP"]]),
      selectInput(inputId='posOp', label='Other Pitcher', choices=allNames, multiple=TRUE, 
                  selected=posList[["OP"]]),
      selectInput(inputId='posPitchBench', label='Pitcher Bench', choices=allNames, multiple=TRUE, 
                  selected=posList[["PITCH BENCH"]])
    )
  })
  
  ## PLAYER TABLE GENERATION
  getPlayerTable <- reactive({
    rosterFile()
    
    players <- character()
    position <- character()
    for( pos in names(posMap) ){
      players <- c(players, input[[pos]])
      position <- c(position, rep(posMap[[pos]], length(input[[pos]])))
    }
    
    ## CHECK FOR DUPS
    vals$succMess <- character()
    vals$writeMess <- character()
    if( any(duplicated(players)) ){
      vals$mess <- paste("These players are listed more than once:", paste(players[duplicated(players)], collapse=", "))
    } else{
      vals$mess <- character()
    }
    if(length(players) > 0){
      data.frame(position = position,
                 players = players)
    } else{
      NULL
    }
  })
  
  ## PLAYER TABLE DISPLAY
  output$playerTable <- renderDataTable({
    getPlayerTable()
  }, options=list(ordering=FALSE, paging=FALSE, searching=FALSE))
  
  ## DOWNLOAD / SAVE OF TEAM ROSTER
  observe({
    if( input$dl > 0 ){
      isolate({
        thisTeam <- input$penguinTeam
        d <- getPlayerTable()
        if( length(vals$mess) == 0 ){
          write.table(d, file=rosterFile(), row.names=F, col.names=T, quote=F, sep="\t")
          vals$succMess <- "Roster successfully saved!"
        } else{
          vals$writeMess <- "Cannot save roster - resolve duplicates"
        }
      })
    }
  })
  
  output$saveErrMess <- renderUI({
    h3(vals$writeMess)
  })
  
  output$saveYesMess <- renderUI({
    h3(vals$succMess)
  })
  
  output$dupMess <- renderUI({
    h4(vals$mess)
  })
  
})



