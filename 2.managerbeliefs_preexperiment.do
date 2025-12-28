*pre-experiment: manager beliefs*
**baseline survey data**


*figs*
**(1) Pre-Experiment: Incentives that Induce Agent Effort and Output
**(2) Pre-Experiment: Managers Rank Expenditure-equivalent Schemes in Order of Revenue Max to MTN (IC)
**(3) Pre-Experiment: Managers Rank Expenditure-equivalent Schemes in Order of Dropout Rates (IR) (endline-only!)
**(4) Pre-Experiment: Managers Preferred Scheme if Had Option to Choose 1; No Objective Imposed
**(5) Pre-Experiment: Managers Described What’ll Consider Optimal Contract in Words (wordcloud!)
**(6) Pre-Experiment: Managers Reasons for Their Rankings
**2b/3b/4b - heterogeneity in beliefs: (i) hierarchy, (iii) geography-regional var, (iii) manager xtics



clear all
log using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/_paper/results/managerial_beliefs_draft.log", replace
*start w/ baseline survey - managers
use "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Manager/Manager.dta", clear //n=456
gen rct_sample = (s1_1a==1 | s1_1a==2 | s1_1a==3 | s1_1a==9 | s1_1a==5 | s1_1a==6 | s1_1a==7 | s1_1a==14 | s1_1a==15) // 9 regions, n=378
tab rct_sample
*keep if rct_sample==1

*1) Managers-only monetary vs non-monetary incentives?
eststo Commissions_Paid: mean q9_1 
eststo Good_Working_Conditions: mean q9_2 
eststo Regular_Manager_Visits: mean q9_3 
eststo Get_Realtime_Support: mean q9_4 
eststo Nonfinancial_Prizes: mean q9_5 
eststo Flexibility_Agents_Operate: mean q9_6 
eststo Other_Factors: mean q9_7 
coefplot Commissions_Paid Good_Working_Conditions Regular_Manager_Visits Get_Realtime_Support Nonfinancial_Prizes Flexibility_Agents_Operate Other_Factors, vertical xlabel("") xtitle("") ytitle("Fraction: Managers" " ", size(medium)) title("Question - Drivers of Agent Effort & Output?") recast(bar) barwidth(0.90) fcolor(*.5) ciopts(recast(rcap)) citop citype(normal) level(95) graphregion(color(white)) ylab(, nogrid) legend(pos(4) col(1) region(col(white)) size(small)) ylab(0(.20)1, nogrid)
gr export "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/_paper/results/figures/managers_money_and_nonmoney_incentives_matter.eps", replace


*2a) Managers-only ranking rev. max?
* reverse the ranks

forval i=1/5 {
	recode q2_`i' (1=5) (2=4) (3=3) (4=2) (5=1), gen(q2r_`i')
}

eststo Simplelinear_Current: mean q2r_1
eststo Flatbonus: mean q2r_2
eststo Threshold: mean q2r_3
eststo Franchising: mean q2r_4
eststo Tournament: mean q2r_5
coefplot Simplelinear_Current Flatbonus Threshold Franchising Tournament, vertical xlabel("") xtitle("") ytitle("Average Rank (Highest=Best)" " ", size(medium)) title("Managers - Rank in Order Max. Revenues to MTN") recast(bar) barwidth(0.90) fcolor(*.5) ciopts(recast(rcap)) citop citype(normal) level(95) graphregion(color(white)) ylab(, nogrid) legend(pos(4) col(1) region(col(white)) size(vsmall)) ylab(, nogrid)
gr export "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/_paper/results/figures/managers_overallaveragerank_maximizingrevs.eps", replace

**2b) Confidence in understanding \& rankings-max rev? 5.3/6.
sum q3
tab q3


**3) why your choices-max rev?
tab q4
tab q4, gen(whychoice)
*Managers-only, pool
eststo Complexity: mean whychoice1 
eststo Power_of_Incentives: mean whychoice2
eststo Understanding_Simple: mean whychoice3
eststo Other_Risk_Equity: mean whychoice4
eststo Simplicity: mean whychoice5
coefplot Complexity Simplicity Power_of_Incentives Understanding_Simple Other_Risk_Equity, vertical xlabel("") xtitle("") ytitle("Fraction: Managers" " ", size(medium)) title("Managers - Reasons for Rankings") recast(bar) barwidth(0.90) fcolor(*.5) ciopts(recast(rcap)) citop citype(normal) level(95) graphregion(color(white)) ylab(, nogrid) legend(pos(4) col(1) region(col(white)) size(small)) ylab(, nogrid)
gr export "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/_paper/results/figures/managers_why_choices_base.eps", replace


**4a) most preferred scheme if had to choose 1, among all?
tab q2, gen(mostpreferred)
eststo Simplelinear_Current: mean mostpreferred1 
eststo Flatbonus: mean mostpreferred2 
eststo Threshold: mean mostpreferred3 
eststo Franchising: mean mostpreferred4 
eststo Tournament: mean mostpreferred5 
coefplot Simplelinear_Current Flatbonus Threshold Franchising Tournament, vertical xlabel("") xtitle("") ytitle("Fraction: Managers" " ", size(medium)) title("Managers - Preferred Scheme if to Choose 1?") recast(bar) fcolor(*.5) ciopts(recast(rcap)) barwidth(0.90) citop citype(normal) level(95) graphregion(color(white)) ylab(, nogrid) legend(pos(4) col(1) region(col(white)) size(small)) ylab(, nogrid)
gr export "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/_paper/results/figures/managers_mostpreferredscheme.eps", replace

**4b) pct most preferred *differs* from on ranked top rev. max
local varlist "q2_1 q2_2 q2_3 q2_4 q2_5"
gen str satisfied_var = ""
foreach v of local varlist {
    replace satisfied_var = "`v'" if `v' == 1 & satisfied_var == ""
}
gen top_revmax=.
replace top_revmax=1 if satisfied_var=="q2_1"
replace top_revmax=2 if satisfied_var=="q2_2"
replace top_revmax=3 if satisfied_var=="q2_3"
replace top_revmax=4 if satisfied_var=="q2_4"
replace top_revmax=5 if satisfied_var=="q2_5"

gen mostpreferred_differs01=(q2 != top_revmax)
sum mostpreferred_differs01 //56.9% of managers it *differs*
tab mostpreferred_differs01


*bring in endline ranking dropout, can only do n=279! tracked overtime? 
*but +43 new mangers @endline*
preserve
*endline, refined (or use all 279+43)?
use "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Endline Rolling Data/Manager_0110.dta", clear 
bys s1_6a s1_6b s1_1a s1_1b s1_1c  s1_1cii : gen cliff=_N 
tab cliff
keep if cliff==1
saveold "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Endline Rolling Data/Manager_0110_279baselineONLY.dta", replace
restore


bys s1_6a s1_6b s1_1a s1_1b s1_1c  s1_1cii : gen cliff=_n
tab cliff
drop if cliff==2
*merging w/ n=279
merge 1:1 s1_6a s1_6b s1_1a s1_1b s1_1c  s1_1cii using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Endline Rolling Data/Manager_0110_279baselineONLY.dta" 

*6a) Managers-only ranking dropout rates?
*reverse dropout rank positions: dropout_rank1 = rrank5, ..., dropout_rank5 = rrank1*
forvalues i = 1/5 {
    gen dropout_rank`i' = rrank`=6-`i''
}
capture label define scheme_lbl 1 "Simple Linear" 2 "Flat bonus/week" 3 "Threshold" 4 "Pure Franchising" 5 "Tournament"
forvalues i = 1/5 {
    label values dropout_rank`i' scheme_lbl
}
*
sum dropout_rank*
eststo Simplelinear_Current: mean dropout_rank1
eststo Flatbonus: mean dropout_rank2
eststo Threshold: mean dropout_rank4
eststo Franchising: mean dropout_rank3
eststo Tournament: mean dropout_rank5
coefplot Simplelinear_Current Flatbonus Threshold Franchising Tournament, vertical xlabel("") xtitle("") ytitle("Average Rank (Highest=Worst)" " ", size(medium)) title("Managers - Rank in Order Dropout Rates") recast(bar) barwidth(0.90) fcolor(*.5) ciopts(recast(rcap)) citop citype(normal) level(95) graphregion(color(white)) ylab(, nogrid) legend(pos(4) col(1) region(col(white)) size(vsmall)) ylab(, nogrid)
gr export "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/_paper/results/figures/managers_overallaveragerank_dropouts.eps", replace

*6b) Confidence in understanding \& rankings-dropouts? 3.7/4.
sum Q3PB
tab Q3PB


**7) why your choices-dropout rates?
tab Q4PB
tab Q4PB, gen(whychoice_dropout)
*Managers-only, pool
eststo Complex: mean whychoice_dropout1
eststo Simplicity: mean whychoice_dropout2
eststo Incentives_Pays_Lower: mean whychoice_dropout3
eststo Too_Risky: mean whychoice_dropout4
eststo Understanding_Simple: mean whychoice_dropout5
eststo Lack_of_Understanding: mean whychoice_dropout6
eststo Others: mean whychoice_dropout7
coefplot Complexity Simplicity Incentives_Pays_Lower Understanding_Simple Lack_of_Understanding Too_Risky Others, vertical xlabel("") xtitle("") ytitle("Fraction: Managers" " ", size(medium)) title("Managers - Reasons for Rankings") recast(bar) barwidth(0.90) fcolor(*.5) ciopts(recast(rcap)) citop citype(normal) level(95) graphregion(color(white)) ylab(, nogrid) legend(pos(4) col(1) region(col(white)) size(small)) ylab(, nogrid)
gr export "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/_paper/results/figures/managers_why_choices_droupouts.eps", replace


*8) wordcloud
tab q6 //describe optimal contract in words
* [https://www.freewordcloudgenerator.com/generatewordcloud#google_vignette]


log close





