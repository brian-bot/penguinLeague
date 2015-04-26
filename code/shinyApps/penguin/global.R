require(shiny)
source("/home/ubuntu/workspace/repos/penguinLeague/code/generalScripts/leagueBootstrap2015.R")
source("/home/ubuntu/workspace/repos/penguinLeague/code/generalScripts/getRange.R")

today <- Sys.Date()
currentPeriod <- which(sapply(periods, function(x){ (today-1) >= x$startDate & today <= x$endDate}))
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

allRosters <- lapply(as.list(names(seasonPeriods)), function(y){
  tr <- lapply(as.list(allTeams), function(x){
    a <- read.delim(file.path(baseRosterDir, y, paste(gsub(" ", "", tolower(x), fixed=T), ".tsv", sep="")), as.is=T)
    rownames(a) <- a$players
    
    ## BATTER STATS
    bs <- a[a$position %in% posMap[batMask], ]
    bs <- merge(bs, allStats[[y]]$batters, by='row.names', all.x=F, all.y=F)
    bs <- bs[, c("players", "team", "position", "hitsbb", "r", "rbi", "hr", "sb")]
    bs$position <- factor(bs$position, levels=posMap[batMask])
    bs <- bs[order(bs$position), ]
    
    ## PTICHER STATS
    ps <- a[a$position %in% posMap[!batMask], ]
    ps <- merge(ps, allStats[[y]]$pitchers, by='row.names', all.x=F, all.y=F)
    ps <- ps[, c("players", "team", "position", "ip", "er", "era", "so", "w", "sv")]
    ps$position <- factor(ps$position, levels=posMap[!batMask])
    ps <- ps[order(ps$position), ]
    
    return(list(battingStats=bs, pitchingStats=ps))
  })
  names(tr) <- allTeams
  tr
})
names(allRosters) <- names(seasonPeriods)


## PRE-COMPUTE ALL STATS FOR ALL seasonPeriods
leagueBatters <- lapply(allRosters, function(y){
  lb <- lapply(y, function(x){
    tmp <- x$battingStats[ !grepl("BENCH", x$battingStats$position), c("r", "hitsbb", "hr", "rbi", "sb")]
    cs <- colSums(tmp)
    cs
  })
  do.call(rbind, lb)
})
leaguePitchers <- lapply(allRosters, function(y){
  lp <- lapply(y, function(x){
    tmp <- x$pitchingStats[ !grepl("BENCH", x$pitchingStats$position), c("ip", "er", "so", "w", "sv")]
    cs <- colSums(tmp)
    cs["era"] <- cs["er"] / cs["ip"] * 9
    cs[c("w", "sv", "so", "era")]
  })
  do.call(rbind, lp)
})

leagueStats <- lapply(as.list(names(seasonPeriods)), function(y){
  tmp <- as.data.frame(cbind(leagueBatters[[y]], leaguePitchers[[y]]))
  tmpNames <- names(tmp)
  
  rankStats <- tmp
  rankStats$era <- -1*rankStats$era
  pts <- rank(rankStats$hitsbb) + rank(rankStats$r) + rank(rankStats$rbi) + rank(rankStats$hr) + rank(rankStats$sb) + rank(rankStats$era) + rank(rankStats$so) + rank(rankStats$w) + rank(rankStats$sv)
  
  tmp$team <- rownames(tmp)
  tmp$points <- pts
  tmp[, c("team", "points", tmpNames)]
})
names(leagueStats) <- paste("period", seasonPeriods, sep="")

# sapply(leagueStats, "[[", "points")



