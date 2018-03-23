#####
## TEAMS
#####
allTeams <- c(
  "Curmudgeons",
  "Mean Wieners",
  "Vass Deferens",
  "Tae Kwon Joes",
  "Wonderbots",
  "Terminoeckers",
  "T and A",
  "Boys of Summer",
  "Nuclear Arms",
  "Overwhelming Underdogs")

#####
## POSITION MAPPING
#####
posMap <- c("C", "1B", "2B", "3B", "SS", "MI", "CI", "OF", "DH", "BAT BENCH", "SP", "RP", "PITCH BENCH")
names(posMap) <- c("posC", "pos1b", "pos2b", "pos3b", "posSs", "posMi", "posCi", "posOf", "posDh", "posBatBench", "posSp", "posRp", "posPitchBench")
batMask <- !(posMap %in% c("SP", "RP", "PITCH BENCH"))

#####
## INFO ON THE LEAGUE SCHEDULE
#####
periods <- list(
  list(startDate = as.Date("2018-03-29"),
       endDate = as.Date("2018-04-18"),
       matchups = list(
         c(1, 2),
         c(3, 4),
         c(5, 6),
         c(7, 8),
         c(9, 10))),
  list(startDate = as.Date("2018-04-19"),
       endDate = as.Date("2018-05-08"),
       matchups = list(
         c(1, 3),
         c(2, 4),
         c(5, 8),
         c(6, 9),
         c(7, 10))),
  list(startDate = as.Date("2018-05-09"),
       endDate = as.Date("2018-05-28"),
       matchups = list(
         c(1, 4),
         c(2, 5),
         c(3, 10),
         c(6, 8),
         c(7, 9))),
  list(startDate = as.Date("2018-05-29"),
       endDate = as.Date("2018-06-18"),
       matchups = list(
         c(1, 5),
         c(2, 6),
         c(3, 9),
         c(4, 7),
         c(8, 10))),
  list(startDate = as.Date("2018-06-19"),
       endDate = as.Date("2018-07-08"),
       matchups = list(
         c(1, 6),
         c(2, 7),
         c(3, 8),
         c(4, 10),
         c(5, 9))),
  list(startDate = as.Date("2018-07-09"),
       endDate = as.Date("2018-08-01"),
       matchups = list(
         c(1, 7),
         c(2, 8),
         c(3, 6),
         c(4, 9),
         c(5, 10))),
  list(startDate = as.Date("2018-08-02"),
       endDate = as.Date("2018-08-21"),
       matchups = list(
         c(1, 8),
         c(2, 9),
         c(3, 7),
         c(4, 5),
         c(6, 10))),
  list(startDate = as.Date("2018-08-22"),
       endDate = as.Date("2018-09-10"),
       matchups = list(
         c(1, 9),
         c(2, 10),
         c(3, 5),
         c(4, 8),
         c(6, 7))),
  list(startDate = as.Date("2018-09-11"),
       endDate = as.Date("2018-09-30"),
       matchups = list(
         c(1, 10),
         c(2, 3),
         c(4, 6),
         c(5, 7),
         c(8, 9))))
names(periods) <- paste("period", 1:length(periods), sep="")
