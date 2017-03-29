## PULL 2016 SEASON DATA
require(xmlstats)
baseRepoDir <- file.path(path.expand("~"), "workspace/repos/penguinLeague")
baseDataDir <- file.path(baseRepoDir, "data/2017")
source(file.path(baseRepoDir, "code/generalScripts/leagueBootstrap2017.R"))

## CHECK AND UPLL ALL DATA FROM THE PAST WEEK - UPDATES SHOULD BE IN PLACE BY THAT TIME
seasonStart <- as.Date("2017-04-02")
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
  if( !is.null(dateData) ){
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


## GET THE ENTIRE SEASON DATA (rangeData)
firstDate <- as.Date("2017-04-02")
lastDate <- Sys.Date()

rangeData <- getRange(firstDate, lastDate, baseDataDir)

save("rangeData", file=file.path(baseDataDir, "rangeData.RData"))

## GET MLB ROSTERS
mlbRosters <- getMlbRosters()

save("mlbRosters", file=file.path(baseDataDir, "mlbRosters.RData"))
