source("/home/ubuntu/workspace/repos/penguinLeague/code/generalScripts/getRange.R")
source("/home/ubuntu/workspace/repos/penguinLeague/code/generalScripts/leagueBootstrap2015.R")

## GET ALL OF THE PLAYER NAMES THAT ARE AVAILABLE
firstDate <- as.Date("2015-04-05")
lastDate <- Sys.Date()

rangeData <- getRange(firstDate, lastDate, baseDataDir)

batterNames <- rangeData$batters$display_name
names(batterNames) <- paste(rangeData$batters$display_name, " (", rangeData$batters$team, ")", sep="")
rownames(rangeData$batters) <- batterNames

pitcherNames <- rangeData$pitchers$display_name
names(pitcherNames) <- paste(rangeData$pitchers$display_name, " (", rangeData$pitchers$team, ")", sep="")
rownames(rangeData$pitchers) <- pitcherNames

allNames <- c(batterNames, pitcherNames)

today <- Sys.Date()
currentPeriod <- which(sapply(periods, function(x){ today >= x$startDate & today <= x$endDate}))
seasonPeriods <- which(sapply(periods, function(x){ today >= x$startDate }))

penguinConfig <- readLines("/home/ubuntu/.penguinConfig")
