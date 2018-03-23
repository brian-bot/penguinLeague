## PULL 2016 SEASON DATA
require(xmlstats)
baseRepoDir <- file.path(path.expand("~"), "workspace/repos/penguinLeague")
baseDataDir <- file.path(baseRepoDir, "data/2018")
source(file.path(baseRepoDir, "code/generalScripts/leagueBootstrap2018.R"))

## CHECK AND UPLL ALL DATA FROM THE PAST WEEK - UPDATES SHOULD BE IN PLACE BY THAT TIME
seasonStart <- as.Date("2018-03-29")
lastDate <- Sys.Date()-1
firstDate <- max(lastDate-7, seasonStart)

for( d in firstDate:lastDate ){
  if( d != firstDate ){
    system("sleep 10")
  }
  class(d) <- "Date"
  
  dateData <- getMlbDate(d)
  ## WRITE OUT FILES FOR EACH DAY
  bFile <- file.path(baseDataDir, "batters", paste(d, ".tsv", sep=""))
  pFile <- file.path(baseDataDir, "pitchers", paste(d, ".tsv", sep=""))
  if( !is.null(dateData$batters) ){
    write.table(dateData$batters, file=bFile, quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)
    write.table(dateData$pitchers, file=pFile, quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)
  }
}

## GET THE BY-PERIOD STATS (allStats)
source(file.path(baseRepoDir, "code/generalScripts/getRange.R"))
source(file.path(baseRepoDir, "code/xmlstatsScripts/getMlbRosters.R"))

today <- Sys.Date()
currentPeriod <- which(sapply(periods, function(x){ (today-1) >= x$startDate & (today-1) <= x$endDate}))
finishedPeriods <- which(sapply(periods, function(x){ today > x$endDate}))
seasonPeriods <- which(sapply(periods, function(x){ (today-1) >= x$startDate }))

allStats <- lapply(as.list(seasonPeriods), function(y){
  if( length(currentPeriod) == 1 ){
    if( y == currentPeriod ){
      perData <- getRange(periods[[y]]$startDate, today, baseDataDir)
    } else{
      perData <- getRange(periods[[y]]$startDate, periods[[y]]$endDate, baseDataDir)
    }
  } else{
    perData <- getRange(periods[[y]]$startDate, periods[[y]]$endDate, baseDataDir)
  }
  rownames(perData$batters) <- perData$batters$display_name
  rownames(perData$pitchers) <- perData$pitchers$display_name
  return(perData)
})

save("allStats", file=file.path(baseDataDir, "allStats.RData"))

## GET MLB ROSTERS
mlbRosters <- getMlbRosters()

save("mlbRosters", file=file.path(baseDataDir, "mlbRosters.RData"))

## GET THE ENTIRE SEASON DATA (rangeData)
firstDate <- as.Date("2018-03-29")
lastDate <- Sys.Date()

if(firstDate < lastDate){
  rangeData <- getRange(firstDate, lastDate, baseDataDir)
  save("rangeData", file=file.path(baseDataDir, "rangeData.RData"))
}

## TOUCH RESTART FILES SO THEY RELOAD
system(paste0('touch ', file.path(baseRepoDir, 'code/shinyApps/buildTeams/restart.txt')))
system(paste0('touch ', file.path(baseRepoDir, 'code/shinyApps/penguin/restart.txt')))


## COPY OVER ROSTERS BEFORE NEW PERIOD STARTS
if( currentPeriod %in% 1:8 ){
  if( today == (periods[[currentPeriod]]$endDate-2) ){
    theseFiles <- list.files(file.path(baseDataDir, "penguinRosters", paste("period", currentPeriod, sep="")))
    for(i in theseFiles){
      file.copy(file.path(baseDataDir, "penguinRosters", paste("period", currentPeriod, sep=""), i), 
                file.path(baseDataDir, "penguinRosters", paste("period", currentPeriod+1, sep=""), i))
    }
  }
}
