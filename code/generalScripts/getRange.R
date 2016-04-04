#####
## GET RANGE OF MLB DATA
#####
getRange <- function(startDate, endDate, baseDir){
  require(plyr)
  
  d0 <- as.Date(startDate)
  d1 <- as.Date(endDate)
  these <- d0:d1
  class(these) <- "Date"
  
  ## BATTERS
  bFiles <- file.path(baseDir, "batters", paste(these, ".tsv", sep=""))
  bFiles <- bFiles[file.exists(bFiles)]
  if(length(bFiles)==0){
    bb <- data.frame()
  } else{
    b <- lapply(bFiles, function(f){
      read.delim(f, as.is=T)
    })
    b <- do.call(rbind, b)
    bb <- ddply(b, .(display_name), summarize,
                team = team_abbreviation[ length(team_abbreviation) ],
                hitsbb = sum(hits) + sum(walks),
                r = sum(runs),
                rbi = sum(rbi),
                hr = sum(home_runs),
                sb = sum(stolen_bases))
  }
  
  ## PITCHERS
  pFiles <- file.path(baseDir, "pitchers", paste(these, ".tsv", sep=""))
  pFiles <- pFiles[file.exists(pFiles)]
  if(length(pFiles)==0){
    pp <- data.frame()
  } else{
    p <- lapply(as.list(pFiles), function(f){
      a <- read.delim(f, as.is=T)
      ## FIX INNINGS PITCHED
      tmp <- strsplit(as.character(a$innings_pitched), ".", fixed=T)
      tmp <- sapply(tmp, function(x){
        if(length(x)==1){
          return(as.numeric(x))
        } else{
          return(as.numeric(x[1]) + as.numeric(x[2])/3)
        }
      })
      a$innings_pitched <- tmp
      a
    })
    p <- do.call(rbind, p)
    pp <- ddply(p, .(display_name), summarize,
                team = team_abbreviation[ length(team_abbreviation) ],
                er = sum(earned_runs),
                ip = sum(innings_pitched),
                hitsbb = sum(hits_allowed) + sum(walks),
                so = sum(strike_outs),
                w = sum(win),
                sv = sum(save))
    pp$era <- pp$er / pp$ip * 9
    pp$whip <- pp$hitsbb / pp$ip
  }
  
  return(list(batters=bb, pitchers=pp))
}

