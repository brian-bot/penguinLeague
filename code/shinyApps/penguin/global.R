require(shiny)
baseRepoDir <- file.path(path.expand("~"), "workspace/repos/penguinLeague")
baseDataDir <- file.path(baseRepoDir, "data/2017")
source(file.path(baseRepoDir, "code/generalScripts/leagueBootstrap2017.R"))
