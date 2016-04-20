## PULL 2016 SEASON DATA
require(xmlstats)
baseOutputDir <- "/home/brianmbot/workspace/repos/penguinLeague/data/2016"

## CHECK AND UPLL ALL DATA FROM THE PAST WEEK - UPDATES SHOULD BE IN PLACE BY THAT TIME
seasonStart <- as.Date("2016-04-03")
lastDate <- Sys.Date()-1
firstDate <- max(lastDate-7, seasonStart)

for( d in firstDate:lastDate ){
  if( d != firstDate ){
    system("sleep 10")
  }
  class(d) <- "Date"
  
  dateData <- getMlbDate(d)
  ## WRITE OUT FILES FOR EACH DAY
  bFile <- file.path(baseOutputDir, "batters", paste(d, ".tsv", sep=""))
  pFile <- file.path(baseOutputDir, "pitchers", paste(d, ".tsv", sep=""))
  if( !is.null(dateData) ){
    write.table(dateData$batters, file=bFile, quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)
    write.table(dateData$pitchers, file=pFile, quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)
  }
}

## GET THE BY-PERIOD STATS (allStats)
source("/home/brianmbot/workspace/repos/penguinLeague/code/generalScripts/leagueBootstrap2016.R")
source("/home/brianmbot/workspace/repos/penguinLeague/code/generalScripts/getRange.R")
source("/home/brianmbot/workspace/repos/penguinLeague/code/xmlstatsScripts/getMlbRosters.R")

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

save("allStats", file=file.path(baseOutputDir, "allStats.RData"))


## GET THE ENTIRE SEASON DATA (rangeData)
firstDate <- as.Date("2016-04-03")
lastDate <- Sys.Date()

rangeData <- getRange(firstDate, lastDate, baseOutputDir)

save("rangeData", file=file.path(baseOutputDir, "rangeData.RData"))

## GET MLB ROSTERS
mlbRosters <- getMlbRosters()

save("mlbRosters", file=file.path(baseOutputDir, "mlbRosters.RData"))
