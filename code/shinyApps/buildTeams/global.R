source("/home/ubuntu/workspace/repos/penguinLeague/code/generalScripts/getRange.R")
source("/home/ubuntu/workspace/repos/penguinLeague/code/generalScripts/leagueBootstrap2017.R")

load(file.path(baseDataDir, "mlbRosters.RData"))
rosterNames <- as.character(mlbRosters$display_name)
names(rosterNames) <- paste(mlbRosters$display_name, " (", mlbRosters$team, ")", sep="")

if(file.exists(file.path(baseDataDir, "rangeData.RData"))){
  load(file.path(baseDataDir, "rangeData.RData"))
  batterNames <- rangeData$batters$display_name
  names(batterNames) <- paste(rangeData$batters$display_name, " (", rangeData$batters$team, ")", sep="")
  rownames(rangeData$batters) <- batterNames
  
  pitcherNames <- rangeData$pitchers$display_name
  names(pitcherNames) <- paste(rangeData$pitchers$display_name, " (", rangeData$pitchers$team, ")", sep="")
  rownames(rangeData$pitchers) <- pitcherNames
  
  allNames <- c(batterNames, pitcherNames)
  rosterNames <- rosterNames[ !(rosterNames %in% allNames) ]
  allNames <- c(allNames, rosterNames)
} else{
  allNames <- rosterNames
}

allNames <- sort(allNames)

today <- Sys.Date()
currentPeriod <- which(sapply(periods, function(x){ today >= x$startDate & today <= x$endDate}))
seasonPeriods <- which(sapply(periods, function(x){ today >= x$startDate }))
if(length(currentPeriod) == 0){
  currentPeriod <- 1
}
penguinConfig <- readLines("/home/ubuntu/.penguinConfig")
