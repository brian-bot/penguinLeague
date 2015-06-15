require(shiny)
source("/home/ubuntu/workspace/repos/penguinLeague/code/generalScripts/leagueBootstrap2015.R")
source("/home/ubuntu/workspace/repos/penguinLeague/code/generalScripts/getRange.R")

today <- Sys.Date()
currentPeriod <- which(sapply(periods, function(x){ (today-1) >= x$startDate & today <= x$endDate}))
finishedPeriods <- which(sapply(periods, function(x){ today > x$endDate}))
seasonPeriods <- which(sapply(periods, function(x){ (today-1) >= x$startDate }))

load(file.path(baseDataDir, "allStats.RData"))

allNonRosters <- lapply(as.list(names(seasonPeriods)), function(y){
  tr <- lapply(as.list(allTeams), function(x){
    a <- read.delim(file.path(baseRosterDir, y, paste(gsub(" ", "", tolower(x), fixed=T), ".tsv", sep="")), as.is=T)
    return(a$players)
  })
  allPlayers <- unlist(tr)
  
  bs <- allStats[[y]]$batters
  bs <- bs[ !(rownames(bs) %in% allPlayers), ]
  bs <- bs[, c("display_name", "team", "hitsbb", "r", "rbi", "hr", "sb")]
  
  ps <- allStats[[y]]$pitchers
  ps <- ps[ !(rownames(ps) %in% allPlayers), ]
  ps <- ps[, c("display_name", "team", "ip", "er", "era", "so", "w", "sv")]
  return(list(battingStats=bs, pitchingStats=ps))
})
names(allNonRosters) <- names(seasonPeriods)

penguinConfig <- readLines("/home/ubuntu/.penguinSecretConfig")

