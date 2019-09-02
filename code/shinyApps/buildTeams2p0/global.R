baseRepoDir <- file.path(path.expand("~"), "workspace/repos/penguinLeague")
baseDataDir <- file.path(baseRepoDir, "data/2019/mlb")
source(file.path(baseRepoDir, "code/generalScripts/leagueBootstrap2019.R"))

load(file.path(baseDataDir, "rangeData.RData"))
allNames <- data.frame(fullName = c(rangeData$batters$fullName, rangeData$pitchers$fullName),
                       withId = c(rownames(rangeData$batters), rownames(rangeData$pitchers)),
                       stringsAsFactors = FALSE)
rownames(allNames) <- NULL
allNames <- allNames[ !duplicated(allNames), ]
rownames(allNames) <- allNames$withId
allNames <- allNames[ order(allNames$withId), ]

today <- Sys.Date()
currentPeriod <- which(sapply(periods, function(x){ today >= x$startDate & today <= x$endDate}))
seasonPeriods <- which(sapply(periods, function(x){ today >= x$startDate }))
if(length(seasonPeriods) == 0){
  seasonPeriods <- which(sapply(periods, function(x){ x$startDate == as.Date("2019-03-20")}))
  currentPeriod <- which(sapply(periods, function(x){ x$startDate == as.Date("2019-03-20")}))
}
penguinConfig <- readLines(file.path(path.expand("~"), ".penguinConfig"))
