baseRepoDir <- file.path(path.expand("~"), "workspace/repos/penguinLeague")
baseDataDir <- file.path(baseRepoDir, "data/2019/mlb")
source(file.path(baseRepoDir, "code/generalScripts/leagueBootstrap2019.R"))

load(file.path(baseDataDir, "rangeData.RData"))
batterNames <- rangeData$batters$fullName
# names(batterNames) <- paste(rangeData$batters$display_name, " (", rangeData$batters$team, ")", sep="")
rownames(rangeData$batters) <- batterNames

pitcherNames <- rangeData$pitchers$fullName
# names(pitcherNames) <- paste(rangeData$pitchers$display_name, " (", rangeData$pitchers$team, ")", sep="")
rownames(rangeData$pitchers) <- pitcherNames

allNames <- union(batterNames, pitcherNames)
names(allNames) <- allNames
allNames <- sort(allNames)

today <- Sys.Date()
currentPeriod <- which(sapply(periods, function(x){ today >= x$startDate & today <= x$endDate}))
seasonPeriods <- which(sapply(periods, function(x){ today >= x$startDate }))
if(length(seasonPeriods) == 0){
  seasonPeriods <- which(sapply(periods, function(x){ x$startDate == as.Date("2019-03-20")}))
  currentPeriod <- which(sapply(periods, function(x){ x$startDate == as.Date("2019-03-20")}))
}
penguinConfig <- readLines(file.path(path.expand("~"), ".penguinConfig"))
