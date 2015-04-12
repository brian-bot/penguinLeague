#####
## TEAMS
#####
allTeams <- c(
  "Terminoeckers",
  "Overwhelming Underdogs",
  "Tae Kwon Joes",
  "Vass Deferens",
  "Nuclear Arms",
  "Boys of Summer",
  "T and A",
  "Mud City Manglers",
  "Mean Wieners",
  "Wonderbots")

#####
## POSITION MAPPING
#####
posMap <- c("C", "1B", "2B", "3B", "SS", "OF", "DH", "BAT BENCH", "SP", "RP", "PITCH BENCH")
names(posMap) <- c("posC", "pos1b", "pos2b", "pos3b", "posSs", "posOf", "posDh", "posBatBench", "posSp", "posRp", "posPitchBench")
batMask <- !(posMap %in% c("SP", "RP", "PITCH BENCH"))

#####
## INFO ON THE LEAGUE SCHEDULE
#####
periods <- list(
  list(startDate = as.Date("2015-04-05"),
       endDate = as.Date("2015-04-25"),
       matchups = list(
         c(1, 2),
         c(3, 4),
         c(5, 6),
         c(7, 8),
         c(9, 10))),
  list(startDate = as.Date("2015-04-26"),
       endDate = as.Date("2015-05-15"),
       matchups = list(
         c(1, 3),
         c(2, 4),
         c(5, 8),
         c(6, 9),
         c(7, 10))),
  list(startDate = as.Date("2015-05-16"),
       endDate = as.Date("2015-06-04"),
       matchups = list(
         c(1, 4),
         c(2, 5),
         c(3, 10),
         c(6, 8),
         c(7, 9))),
  list(startDate = as.Date("2015-06-05"),
       endDate = as.Date("2015-06-23"),
       matchups = list(
         c(1, 5),
         c(2, 6),
         c(3, 9),
         c(4, 7),
         c(8, 10))),
  list(startDate = as.Date("2015-06-24"),
       endDate = as.Date("2015-07-12"),
       matchups = list(
         c(1, 6),
         c(2, 7),
         c(3, 8),
         c(4, 10),
         c(5, 9))),
  list(startDate = as.Date("2015-07-17"),
       endDate = as.Date("2015-08-05"),
       matchups = list(
         c(1, 7),
         c(2, 8),
         c(3, 6),
         c(4, 9),
         c(5, 10))),
  list(startDate = as.Date("2015-08-06"),
       endDate = as.Date("2015-08-25"),
       matchups = list(
         c(1, 8),
         c(2, 9),
         c(3, 7),
         c(4, 5),
         c(6, 10))),
  list(startDate = as.Date("2015-08-26"),
       endDate = as.Date("2015-09-14"),
       matchups = list(
         c(1, 9),
         c(2, 10),
         c(3, 5),
         c(4, 8),
         c(6, 7))),
  list(startDate = as.Date("2015-09-15"),
       endDate = as.Date("2015-10-04"),
       matchups = list(
         c(1, 10),
         c(2, 3),
         c(4, 6),
         c(5, 7),
         c(8, 9))))
names(periods) <- paste("period", 1:length(periods), sep="")

#####
## PATH VARIABLES TO BE USED TO PULL DATA (ROSTERS AND STATS)
#####
baseRosterDir <- "/home/ubuntu/workspace/repos/penguinLeague/data/2015/penguinRosters"
baseDataDir <- "/home/ubuntu/workspace/repos/penguinLeague/data/2015"

