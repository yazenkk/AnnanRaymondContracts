/*
Master file for scripts in Annan and Raymond repo
Date created: 12/28/2025

*/


** Initialize
clear all
set graphics off


** Globals
if c(username) == "fannan" {
	global main_loc "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin"
	
	** need to insert github local and results local to run scripts on github
	
}
else if c(username) == "yazenkashlan" {
	global main_loc "/Users/yazenkashlan/CEGA Dropbox/yfkashlan@gmail.com/contracts-w Collin"

	global do_loc "/Users/yazenkashlan/Documents/GitHub/AnnanRaymondContracts"
	global results "${do_loc}/results"
}

** programs
// ssc install mmodes
// ssc install lgraph

** do files
cap log close
// do "${do_loc}/1.summarystats_and_balance_baseline.do"
// do "${do_loc}/2.managerbeliefs_preexperiment.do"
// do "${do_loc}/3.treatmenteffects_main.do"
// do "${do_loc}/4.treatmenteffects_heterogeneity.do"
// do "${do_loc}/5.interpretingresults.do"
do "${do_loc}/6.managerialpredictability.do"


