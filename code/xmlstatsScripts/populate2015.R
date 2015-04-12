## PULL 2015 SEASON DATA
require(xmlstats)
baseOutputDir <- "/home/ubuntu/workspace/repos/penguinLeague/data/2015"
system('users')

## CHECK AND UPLL ALL DATA FROM THE PAST WEEK - UPDATES SHOULD BE IN PLACE BY THAT TIME
seasonStart <- as.Date("2015-04-05")
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



