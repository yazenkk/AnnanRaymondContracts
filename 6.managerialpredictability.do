*Interpreting the Results-2*
**admin/expermiment data + baseline survey data + audit study**


*(B) results - managerial predictability and drivers*
**(1) Managerial Predictability: Beliefs vs Actual Outcomes*
**-Corr (Actual A^c, Predicted^ic)
**table!
**(2) Drivers of Managerial Predictability
**(3) The ”Ivory Tower” Trade-off




*(B) results - managerial predictability and drivers*
clear all
log using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/_paper/results/managerial_predictability_draft.log", replace
*start w/ baseline survey - managers
use "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Manager/Manager.dta", clear //n=456
gen rct_sample = (s1_1a==1 | s1_1a==2 | s1_1a==3 | s1_1a==9 | s1_1a==5 | s1_1a==6 | s1_1a==7 | s1_1a==14 | s1_1a==15) // 9 regions, n=378
tab rct_sample
*keep if rct_sample==1

* reverse the ranks
forval i=1/5 {
	recode q2_`i' (1=5) (2=4) (3=3) (4=2) (5=1), gen(q2r_`i')
}


*predictors: x=hierarchy measure
tab s1_2
gen hierarchy=""
gen hierarchy_r=.
replace hierarchy="5C-Suite" if s1_2==1
replace hierarchy_r=5 if s1_2==1
replace hierarchy="4Senior" if s1_2==2
replace hierarchy_r=4 if s1_2==2
replace hierarchy="3Mid" if s1_2==3
replace hierarchy_r=3 if s1_2==3
replace hierarchy="2Entry" if s1_2==4
replace hierarchy_r=2 if s1_2==4
replace hierarchy="1Other" if s1_2==5
replace hierarchy_r=1 if s1_2==5
tab hierarchy
tab hierarchy_r

*ciplot q2r_*, by(hierarchy) xlabel(, angle(40)) legend(position(7) col(1))

tab s0_0
tab s0_0x
gen manager_type=""
gen manager_type_r=.
replace manager_type="1Canvassers" if s0_0==1
replace manager_type_r=1 if s0_0==1
replace manager_type="2Ambassadors" if s0_0==2
replace manager_type_r=2 if s0_0==2
replace manager_type="3AADs" if s0_0==3
replace manager_type_r=3 if s0_0==3
replace manager_type="4TSCs" if s0_0==4
replace manager_type_r=4 if s0_0==4
replace manager_type="5ASMsPLUS" if s0_0==5 | s0_0==6 | s0_0==7 //includes 4 SAMs, 1 Commercial Head & 1 n/s GM
replace manager_type_r=5 if s0_0==5 | s0_0==6 | s0_0==7
*replace manager_type="6HQPLUS" if s0_0==11 | s0_0==13 | s0_0==14 | s0_0==15 | s0_0==16 //includes 3-Finance, 7-Compliance & Fraud, 1-CS, 4-Operations & 20-HQ Others [s0_0x]
*replace manager_type="7CEOs" if s0_0==8 | s0_0==9 //includes 1-CEO, 1-CSDO
replace manager_type="6HQPLUS" if s0_0==11 | s0_0==13 | s0_0==14 | s0_0==15 | s0_0==16 | s0_0==8 | s0_0==9 //combines HQPLUS + CEOs for stat. power
replace manager_type_r=6 if s0_0==11 | s0_0==13 | s0_0==14 | s0_0==15 | s0_0==16 | s0_0==8 | s0_0==9

*ciplot q2r_*, by(manager_type) xlabel(, angle(40)) legend(position(7) col(1))

tab hierarchy manager_type //correlates well as expected!

*predictors: x_base= manager attributes?
**************************
tab hierarchy, gen(hierarchy)
tab manager_type, gen(manager_type)
gen hQPLUS=(manager_type=="6HQPLUS") if !missing(manager_type)
gen lower=(s0_0==1 | s0_0==2 | s0_0==3)
gen mid=(s0_0==4)
gen senior=(s0_0==5 | s0_0==6 | s0_0==7 | s0_0==11 | s0_0==13 | s0_0==14 | s0_0==15 | s0_0==16 | s0_0==8 | s0_0==9)
gen freq_interactwAgents=q8c
gen familiar_motivatingAgents=s1_4
gen involved_compensatingAgents=(s1_5==1) if !missing(s1_5)
gen educ=s2_1
gen married=(s2_2==1) if !missing(s2_2)
gen female=(s2_3==2) if !missing(s2_3)
gen hhsize=s2_4
gen experience_yr=s2_6
gen experience_sales_yr=s2_7
gen experience_mtn_yr=s2_8
gen know_currentscheme = !missing(s3_1)
gen bonus_linked_Agentperform=(s3_3==1) if !missing(s3_3)
gen bonus_linked_Agentperform_yr2024=(s3_4==1) if !missing(s3_4)
gen people_managing=s3_9 if s3_9 !=99999 
gen busymarket_managing=(s4_5==1) if !missing(s4_5)

/*
*managerial predictability: defined -> predicted best01 vs worst01 vs both01 (1)
gen tournamentBest01=(q2r_5==5) if !missing(q2r_5)
gen flatWorst01=(q2r_2==1) if !missing(q2r_2)
gen tBestANDfWorst01=(tournamentBest01==1) & (flatWorst01==1)
sum tournamentBest01 flatWorst01 tBestANDfWorst01

*drivers of predictability 1?
reghdfe tournamentBest01 i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform	people_managing i.busymarket_managing i.educ i.married i.female hhsize, noabsorb vce(cluster eid)

reghdfe flatWorst01 i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform	people_managing i.busymarket_managing i.educ i.married i.female hhsize, noabsorb vce(cluster eid)

reghdfe tBestANDfWorst01 i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	 experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform	people_managing i.busymarket_managing i.educ i.married i.female hhsize, noabsorb vce(cluster eid)
	*result:
	**what matters 4: hq manager level (hierarchy) & educ level; + interact w/ agents & bonuses linked; + 0
*/
	
*managerial predictability: defined -> rank differences {predicted v actual} (2), full n=456!
*do for: q2r_ (performance)
****************************
preserve
gen id = _n
reshape long q2r_, i(id) j(contract_id) //note: contract_id: 1=sq, 2=flat, 3=threshold, 4=franchising, 5=tournament
*br q2r_ contract_id q2 q2_1 q2_2 q2_3 q2_4 q2_5
*rct: r1=tournament, r2=sq, r3=franchising, r4=threshold, r5=flat
gen rctr_=.
replace rctr_=5 if contract_id==5 //tournament
replace rctr_=4 if contract_id==1 //sq
replace rctr_=3 if contract_id==4 //franchising
replace rctr_=2 if contract_id==3 //threshold
replace rctr_=1 if contract_id==2 //flat

gen rank_diff_predict_rct = abs(q2r_ - rctr_)
reg rank_diff_predict_rct i.contract_id
predict res_rank_diff_predict_rct, res
label var res_rank_diff_predict_rct "rank difference between predictions and actual, residualized by contract FE"


*drivers of predictability?
*two-way clustering: by manager & by enumerator
**col1**
reghdfe rank_diff_predict_rct i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing i.educ i.married i.female hhsize, noabsorb vce(cluster id eid)
	*result:
	**weak predictability for complex contracts: contract=3/franch and =5/tourn relative to sq
	**what matters 4: hq manager level (hierarchy), interact w/ agents, bonuses linked & educ level

*calc accuracy: overall (rank) correl. & r^2
**col2**
reghdfe rctr_ q2r_ , noabsorb vce(cluster id eid) //report
/*
reghdfe q2r_ rctr_ i.contract_id, noabsorb vce(cluster id eid)
reghdfe q2r_ rctr_ i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing i.educ i.married i.female hhsize, noabsorb vce(cluster id eid)
	
**variation in divergence [prediction–performance gaps]
su res_rank_diff_predict_rct
local sd = round(r(sd), 0.001)
hist res_rank_diff_predict_rct, caption(sd = `sd', position(12) ring(0))
*/
restore

	
*bring in endline preferences, can only do n=279! tracked overtime? 
*but +43 new mangers @endline*
preserve
*endline, refined?
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


*predictores: x_base=end=preference parameters?
******************************
gen riskaverse1=(NR1==1 | NR2 ==1 | NR3==1) if !missing(NR1 | NR2 | NR3)
tab NR4
gen riskaverse2=(NR4<=7) if !missing(NR4) //median (relative)

gen impatient1=(NT1==1 | NT2 ==1 | NT3==1) if !missing(NT1 | NT2 | NT3)
tab NT4
gen impatient2=(NT4<=7) if !missing(NT4) //median (relative)

gen volatileMarket=(NMR2==1 | NMR2==2) if NMR2 !=999 & !missing(NMR2)

tab CA1
gen competeaverse1=(CA1<=7) if !missing(CA1) //median (relative)
tab RE1
gen reciprocal1=(RE1>=8) if !missing(RE1) //median (relative)
tab RE2
gen reciprocal2=(RE2>=7) if !missing(RE2) //median (relative)


**report manager endline knowledge test results //report
********************************************************
tab QN6
gen understand=(QN6==1) if !missing(QN6)
gen dontunderstand=(QN6==2) if !missing(QN6)
eststo Understand: mean understand
eststo Dont: mean dontunderstand
coefplot Understand Dont, vertical xlabel("") xtitle("") ytitle("Fraction: Managers" " ", size(medium)) title("Managers - Understand Different Contracts at Endline") recast(bar) barwidth(0.90) fcolor(*.5) ciopts(recast(rcap)) citop citype(normal) level(95) graphregion(color(white)) ylab(, nogrid) legend(pos(4) col(1) region(col(white)) size(small)) ylab(, nogrid)
gr export "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/_paper/results/figures/managers_understand_differentcontracts_endl.eps", replace


/*
*managerial predictability: defined -> predicted best01 vs worst01 vs both01 (1), only n=279!
reghdfe tournamentBest01 i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform	people_managing i.busymarket_managing i.educ i.married i.female hhsize ///
	NR1 NT4 NMR2 CA1 RE1, noabsorb vce(cluster eid)

reghdfe flatWorst01 i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform	people_managing i.busymarket_managing i.educ i.married i.female hhsize ///
	NR1 NT4 NMR2 CA1 RE1, noabsorb vce(cluster eid)

reghdfe tBestANDfWorst01 i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	 experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform	people_managing i.busymarket_managing i.educ i.married i.female hhsize ///
	NR1 NT4 NMR2 CA1 RE1, noabsorb vce(cluster eid)
	*result:
	**what matters 4: hq manager level (hierarchy) & educ level; + interact w/ agents & bonuses linked; + 0
*/

*predictability: defined -> rank differences {predicted vs actual} (2), only n=279!
*do for: q2r_ (performance) 
****************************
preserve
gen id = _n
reshape long q2r_, i(id) j(contract_id) //not: contract_id: 1=sq, 2=flat, 3=threshold, 4=franchising, 5=tournament
*br q2r_ contract_id q2 q2_1 q2_2 q2_3 q2_4 q2_5 dropout_rank1 dropout_rank2 dropout_rank3 dropout_rank4 dropout_rank5
*rct: r1=tournament, r2=sq, r3=franchising, r4=threshold, r5=flat
gen rctr_=.
replace rctr_=5 if contract_id==5 //tournament
replace rctr_=4 if contract_id==1 //sq
replace rctr_=3 if contract_id==4 //franchising
replace rctr_=2 if contract_id==3 //threshold
replace rctr_=1 if contract_id==2 //flat

gen rank_diff_predict_rct = abs(q2r_ - rctr_)
reg rank_diff_predict_rct i.contract_id
predict res_rank_diff_predict_rct, res
label var res_rank_diff_predict_rct "rank difference between predictions and actual, residualized by contract FE"

*drivers of predictability?
*two-way clustering: by manager & by enumerator
***col3 (a) \& (b)**
reghdfe rank_diff_predict_rct i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing i.educ i.married i.female hhsize, noabsorb vce(cluster id eid)

reghdfe rank_diff_predict_rct i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing  i.volatileMarket i.educ i.married i.female hhsize ///
	i.riskaverse1 i.impatient1 i.competeaverse1 i.reciprocal1, noabsorb vce(cluster id eid)
	*result:
	**weak predictability for contract=3/franch and =5/tourn relative to sq
	**what matters 4: hq manager level (hierarchy), interact w/ agents, bonuses linked & educ level

*calc accuracy: overall (rank) correl. & r^2
**col4**
reghdfe rctr_ q2r_, noabsorb vce(cluster id eid)
/*
reghdfe q2r_ rctr_ i.contract_id, noabsorb vce(cluster id eid)
reghdfe q2r_ rctr_ i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	i.involved_compensatingAgents experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing i.educ i.married i.female hhsize, noabsorb vce(cluster id eid)
	
reghdfe q2r_ rctr_ i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	i.involved_compensatingAgents experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing i.educ i.married i.female hhsize ///
	i.riskaverse1 i.impatient1 i.volatileMarket i.competeaverse1 i.reciprocal1, noabsorb vce(cluster id eid)

*variation in divergence [prediction–performance gaps]
su res_rank_diff_predict_rct
local sd = round(r(sd), 0.001)
hist res_rank_diff_predict_rct, caption(sd = `sd', position(12) ring(0))
*/
restore


*do for: dropout_rank (dropouts), only n=279!
*********************************
preserve
keep if  _merge==3
gen id_drop = _n
reshape long q2r_ dropout_rank, i(id_drop) j(contract_id) //not: contract_id: 1=sq, 2=flat, 3=threshold, 4=franchising, 5=tournament
*br q2r_ contract_id q2 q2_1 q2_2 q2_3 q2_4 q2_5 dropout_rank
*rct: r1=tournament, r2=sq, r3=franchising, r4=threshold, r5=flat
gen rctr_=.
replace rctr_=5 if contract_id==5 //tournament
replace rctr_=4 if contract_id==1 //sq
replace rctr_=3 if contract_id==4 //franchising
replace rctr_=2 if contract_id==3 //threshold
replace rctr_=1 if contract_id==2 //flat

gen rctr_drop_=.
replace rctr_drop_=2 if contract_id==5 //tournament //set equal to sq = 2
replace rctr_drop_=2 if contract_id==1 //sq
replace rctr_drop_=4 if contract_id==4 //franchising
replace rctr_drop_=5 if contract_id==3 //threshold
replace rctr_drop_=3 if contract_id==2 //flat

gen rank_diff_predict_rct = abs(q2r_ - rctr_)
gen rank_diff_predict_rct_drop = abs(dropout_rank - rctr_drop_)

*drivers of predictability?
*two-way clustering: by manager & by enumerator
*performance=ic
**col5 (a) \& (b)**
reghdfe rank_diff_predict_rct i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing i.educ i.married i.female hhsize, noabsorb vce(cluster id_drop eid)

reghdfe rank_diff_predict_rct i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing  i.volatileMarket i.educ i.married i.female hhsize ///
	i.riskaverse1 i.impatient1 i.competeaverse1 i.reciprocal1, noabsorb vce(cluster id_drop eid)

*calc accuracy: overall (rank) correl. & r^2
**col6**
reghdfe rctr_ q2r_, noabsorb vce(cluster id_drop eid)
/*
reghdfe q2r_ rctr_ i.contract_id, noabsorb vce(cluster id eid)
reghdfe q2r_ rctr_ i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	i.involved_compensatingAgents experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing i.educ i.married i.female hhsize, noabsorb vce(cluster id_drop eid)
	
reghdfe q2r_ rctr_ i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	i.involved_compensatingAgents experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing i.educ i.married i.female hhsize ///
	i.riskaverse1 i.impatient1 i.volatileMarket i.competeaverse1 i.reciprocal1, noabsorb vce(cluster id_drop eid)
*/

*dropout=pc
**col7 (a) \& (b)**
reghdfe rank_diff_predict_rct_drop i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing i.educ i.married i.female hhsize, noabsorb vce(cluster id_drop eid)

reghdfe rank_diff_predict_rct_drop i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing  i.volatileMarket i.educ i.married i.female hhsize ///
	i.riskaverse1 i.impatient1 i.competeaverse1 i.reciprocal1, noabsorb vce(cluster id_drop eid)
	*result:
	**weak predictability for contract=3/franch and =5/tourn relative to sq
	**what matters 4: hq manager level (hierarchy), interact w/ agents, bonuses linked & educ level

*calc accuracy: overall (rank) correl. & r^2
**col9**
reghdfe rctr_drop_ dropout_rank, noabsorb vce(cluster id_drop eid) //report
/*
reghdfe dropout_rank rctr_drop_ i.contract_id, noabsorb vce(cluster id_drop eid)
reghdfe dropout_rank rctr_drop_ i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	i.involved_compensatingAgents experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing i.educ i.married i.female hhsize, noabsorb vce(cluster id_drop eid)
	
reghdfe dropout_rank rctr_drop_ i.contract_id i.manager_type_r i.freq_interactwAgents i.familiar_motivatingAgents i.q3 ///
	i.involved_compensatingAgents experience_yr experience_sales_yr i.know_currentscheme ///
	i.bonus_linked_Agentperform people_managing i.busymarket_managing i.educ i.married i.female hhsize ///
	i.riskaverse1 i.impatient1 i.volatileMarket i.competeaverse1 i.reciprocal1, noabsorb vce(cluster id_drop eid)
*/
restore

	*summary of results-performance=ic?
	*(1) expectedly - managerial 'hierarchy matters' but unexpectedly - lowerlevel managers (field-based) are less predictive of incentive effects relative to higherlevel managers (hQ-based) - perhaps b/c higherlevel managers were once lowerlever and then got 'promoted' (and so they have more signals/information about both lower- and upper-level incentive decisions and potential agent behaviors)
		     **The "HQ Advantage" is Real: HQ & Senior Managers are the only group that is statistically significantly more accurate than entry-level Canvassers (−0.343, p<0.05).This suggests that the "view from the top"—or perhaps the selection effect of who gets promoted—results in a much better understanding of which compensation schemes actually drive revenue.**
	*(2) freq. of interactions w/ agents & familiarity w/ agent motivating incentives matter (more predictive)
	*(3) mangers that had their bonuses ever linked to agents performance were more predictive of incentive effects
	*(0a) in general though - the franchising and tournament incentive effects are hard to predict by managers 
	     **In summary: complexity kills accuracy. when moving from linear/simple schemes (Status Quo, Flat, Franchising) to non-linear/competitive ones (Threshold, Tournament), managers' ability to identify the "best" option degrades significantly.**
	*(0b) preference parameters don't seem to matter at all.
	
	*summary - dropout=pc (& ic)?
	*Results suggest an "Ivory Tower" effect where upper management understands the math of incentives but misjudges the human reaction (attrition) to them.
	*Complexity consistently confuses: Tournaments and Thresholds increase prediction error for both performance and dropouts. Managers struggle to assess the impact of non-linear schemes on both the top line (sales) and the bottom line (retention).
	*A compelling dichotomy -- Cognitive sophistication (Education/HQ) is required to understand the incentive effects from contracts (Revenue), but peer proximity (Canvassers) is required to understand the participation constraint (Dropouts).
	*Individual manager personality traits like Risk Aversion or Impatience do not significantly matter as in ic
	***the prediction error is driven by structural distance (role and hierarchy), not by inherent personality differences.
log close






