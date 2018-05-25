baseRepoDir <- file.path(path.expand("~"), "workspace/repos/penguinLeague")
baseDataDir <- file.path(baseRepoDir, "data/2018/mlb")
source(file.path(baseRepoDir, "code/generalScripts/leagueBootstrap2018.R"))

load(file.path(baseDataDir, "rangeData.RData"))
batterNames <- rangeData$batters$display_name
# names(batterNames) <- paste(rangeData$batters$display_name, " (", rangeData$batters$team, ")", sep="")
rownames(rangeData$batters) <- batterNames

pitcherNames <- rangeData$pitchers$display_name
# names(pitcherNames) <- paste(rangeData$pitchers$display_name, " (", rangeData$pitchers$team, ")", sep="")
rownames(rangeData$pitchers) <- pitcherNames

allNames <- c(batterNames, pitcherNames)
rosterNames <- rosterNames[ !(rosterNames %in% allNames) ]
allNames <- c(allNames, rosterNames)

allNames <- sort(allNames)

today <- Sys.Date()
currentPeriod <- which(sapply(periods, function(x){ today >= x$startDate & today <= x$endDate}))
seasonPeriods <- which(sapply(periods, function(x){ today >= x$startDate }))
if(length(seasonPeriods) == 0){
  seasonPeriods <- which(sapply(periods, function(x){ x$startDate == as.Date("2018-03-29")}))
  currentPeriod <- which(sapply(periods, function(x){ x$startDate == as.Date("2018-03-29")}))
}
penguinConfig <- readLines(file.path(path.expand("~"), ".penguinConfig"))
