#####
## GET RANGE OF MLB DATA
#####
getRange <- function(startDate, endDate, baseDir){
  require(plyr)
  require(dplyr)
  
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
      tmp <- read.delim(f, as.is=T)
      tmp <- tmp[, c("fullName", "hits", "baseOnBalls", "runs", "rbi", "homeRuns", "stolenBases")]
      return(tmp)
    })
    b[sapply(b, is.null)] <- NULL
    b <- bind_rows(b)
    # b <- do.call(rbind, b)
    bb <- ddply(b, .(fullName), summarize,
                # team = team_abbreviation[ length(team_abbreviation) ],
                hitsbb = sum(hits) + sum(baseOnBalls),
                r = sum(runs),
                rbi = sum(rbi),
                hr = sum(homeRuns),
                sb = sum(stolenBases))
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
      tmp <- strsplit(as.character(a$inningsPitched), ".", fixed=T)
      tmp <- sapply(tmp, function(x){
        if(length(x)==1){
          return(as.numeric(x))
        } else{
          return(as.numeric(x[1]) + as.numeric(x[2])/3)
        }
      })
      a$inningsPitched <- tmp
      a <- a[, c("note", "fullName", "battersFaced", "earnedRuns", "inningsPitched", "hits", "baseOnBalls", "strikeOuts")]
      return(a)
    })
    p[sapply(p, is.null)] <- NULL
    p <- bind_rows(p)
    # p <- do.call(rbind, p)
    p$win <- grepl("(W,", p$note, fixed=TRUE)
    p$save <- grepl("(S,", p$note, fixed=TRUE)
    pp <- ddply(p, .(fullName), summarize,
                # team = team_abbreviation[ length(team_abbreviation) ],
                g = sum(battersFaced > 0),
                er = sum(earnedRuns),
                ip = sum(inningsPitched),
                hitsbb = sum(hits) + sum(baseOnBalls),
                so = sum(strikeOuts),
                w = sum(win),
                sv = sum(save))
    pp$era <- pp$er / pp$ip * 9
    pp$whip <- pp$hitsbb / pp$ip
  }
  
  return(list(batters=bb, pitchers=pp))
}

