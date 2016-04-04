getMlbRosters <- function(){
  require(xmlstats)
  
  a <- xmlstatsRestGET('/mlb/teams.json')
  
  res <- lapply(a, function(x){
    Sys.sleep(10)
    xmlstatsRestGET(paste0('/mlb/roster/', x$team_id, '.json'))
  })
  allRes <- lapply(res, function(x){
    xx <- lapply(x$players, function(y){
      return(as.data.frame(y))
    })
    tmp <- do.call(rbind, xx)
    tmp$team <- x$team$abbreviation
    return(tmp)
  })
  mlbRosters <- do.call(rbind, allRes)
  return(mlbRosters)
}
