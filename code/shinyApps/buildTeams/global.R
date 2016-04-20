source("/home/brianmbot/workspace/repos/penguinLeague/code/generalScripts/getRange.R")
source("/home/brianmbot/workspace/repos/penguinLeague/code/generalScripts/leagueBootstrap2016.R")

load(file.path(baseDataDir, "rangeData.RData"))
load(file.path(baseDataDir, "mlbRosters.RData"))

batterNames <- rangeData$batters$display_name
names(batterNames) <- paste(rangeData$batters$display_name, " (", rangeData$batters$team, ")", sep="")
rownames(rangeData$batters) <- batterNames

pitcherNames <- rangeData$pitchers$display_name
names(pitcherNames) <- paste(rangeData$pitchers$display_name, " (", rangeData$pitchers$team, ")", sep="")
rownames(rangeData$pitchers) <- pitcherNames

allNames <- c(batterNames, pitcherNames)

rosterNames <- as.character(mlbRosters$display_name)
names(rosterNames) <- paste(mlbRosters$display_name, " (", mlbRosters$team, ")", sep="")
rosterNames <- rosterNames[ !(rosterNames %in% allNames) ]

allNames <- c(allNames, rosterNames)
allNames <- sort(allNames)

today <- Sys.Date()
currentPeriod <- which(sapply(periods, function(x){ today >= x$startDate & today <= x$endDate}))
seasonPeriods <- which(sapply(periods, function(x){ today >= x$startDate }))

penguinConfig <- readLines("/home/brianmbot/.penguinConfig")
