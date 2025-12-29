*treatment effects*
**admin/experiment data + baseline survey data**


*results*

**Participation (IR): Signing, Dropout, and Retention
**Graphical Results - Dropout Rates Differential Except for Tournaments
**Graphical Results - Differences in Dropout
**Dropout Rates Differential Except for Tournaments

**Incentive Compatibility (IC): Effort and Output
**Graphical Results - Highest and Persistent Performance Effects from Tournaments
**Graphical Results - Differences in Revenues
**Treatment Effects on Revenues




log using "${main_loc}/_paper/results/treatmenteffects_main_draft.log", replace
clear

*1) gather experiment bonus payments dataset
**admin/experiment data + baseline data**
use "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - WK 1.dta", clear
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - Wk 2.dta"
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - Wk 3.dta"
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - Wk 4.dta"
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - Wk 5.dta"
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - Wk 6.dta"
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - Wk 7.dta"
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - Wk 8.dta"
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - Wk 9.dta"
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - Wk 10.dta"
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - Wk 11.dta"
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/Main Study - Wk 12.dta"


**2) merge with baseline (agent) survey
merge m:1 icx using "${main_loc}/Completed Tasks - Beatrice/fullstudy_sample.dta", gen(_mergewkly) force

tab week

****generate outcomes y
***********************
**pc - rationality of contracts?
gen didntsigncontract01=(_mergewkly == 2) if !missing(_mergewkly) //pc stage1: n~1,130 [signature rates]
gen dropout01 = (optedout == "Opted Out") if !missing(optedout) //pc stage2 [dropout rates/heterogeneity]

replace dateandtime = subinstr(dateandtime, "12/26/2023", "05/26/2025", .) if strpos(dateandtime, "12/26/2023")
gen double datetime_stata = clock(dateandtime, "MDYhms")
gen date_stata = dofc(datetime_stata)
format date_stata %td
gen trial_start = mdy(5, 3, 2025)
format trial_start %td
gen daystrialb4dropout = date_stata - trial_start //pc stage3 [retention or survival rates]
list dateandtime date_stata trial_start daystrialb4dropout in 1/5

**ic - incentives of contracts?
gen points_total=totalcommwithourshare_ghs * 10
gen points_mml=points_total - points
gen points_agents=points
replace points_total=points_mml+points_agents
gen ghs_total = points_total/10
gen ghs_mml = points_mml/10
gen ghs_agents = points_agents/10
gen revcostratio_mml=ghs_mml / ghs_agents

**ic* - compliance of contracts?
gen points_invalid_cashin = (cashintotalvalue - cashintotalvaluevalid) * 10
gen ghs_invalid_cashin =points_invalid_cashin/10

*imputations for dropouts, if necessary or do ITT by pooling datasets later
gen adj_ghs_agents = ghs_agents //replacing "opted out agents" with the mean of the control group
summarize ghs_agents if scheme == "Simple Linear", meanonly //estimating mean points for control group
replace adj_ghs_agents = r(mean) if optedout == "Opted Out" //replacing points for opted out agents
gen adj_ghs_mml = ghs_mml //mml adjusted points
summarize ghs_mml if scheme == "Simple Linear", meanonly
replace adj_ghs_mml = r(mean) if optedout == "Opted Out"
gen adj_ghs_total = ghs_total // total points
summarize ghs_total if scheme == "Simple Linear", meanonly
replace adj_ghs_total = r(mean) if optedout == "Opted Out"

***generate treaments
*********************
*br treatment_contract scheme //randomization vs payments data, respectively
replace scheme=treatment_contract if missing(scheme) //ok!
tab scheme, gen(trt)
rename trt1 flatbonus
rename trt2 purefranchising
*control or intercept = simple linear
rename trt4 threshold
rename trt5 tournament
gen pooledcontract=1
replace pooledcontract=0 if  scheme=="Simple Linear"
tab pooledcontract, miss

***to test for selection into contracts****
*******************************************
gen rassigned=scheme
tab rassigned, miss
gen preferred=q2
/*
gen preferred=""
replace preferred = "Simple Linear" if q2==1
replace preferred = "Flat bonus/week" if q2==2
replace preferred = "Threshold" if q2==3
replace preferred = "Pure Franchising" if q2==4
replace preferred = "Tournament" if q2==5
*/
gen assignedpreferred01 = (rassigned==preferred) 
sum assignedpreferred01
tab assignedpreferred01, missing

*controls vars set
******************
gen operatorandowner=(s1_2=="I am the operator and owner") if !missing(s1_2)
gen commissions_lastmonth=sa_2
gen age_yrs=s0_2
gen female=(s2_3=="Female") if !missing(s2_3)
gen educ_postsecondary = (s2_1=="Vocational/technical" |  s2_1=="Tertiary" | s2_1=="Graduate (Master?s degree and above)") if !missing(s2_1)
gen interactwmanager=(q8c=="Frequent" | q8c=="Always") if !missing(q8c)
gen hhsize=s2_4
gen hhincome_annual=s2_5 //to winsorize
gen currentschemeadequate=(sa_3=="Yes") if !missing(sa_3)
gen workexperience_yrs=s2_6
gen capital_momo=s8_9 //to winsorize
gen employees_store=s8_6 //to winsorize


**3) append with baseline week0 admin records for ts analysis
append using "${main_loc}/survey_data_management/Main Study/Weekly Intervention Data/_week0data.dta"
tab week

gen contracts=1 //control "Simple Linear"
replace contracts =2 if scheme=="Flat bonus/week"
replace contracts =3 if scheme=="Pure Franchising"
replace contracts =4 if scheme=="Threshold"
replace contracts =5 if scheme=="Tournament"
gen post=(week>0) if !missing(week)


**4) evaluation - raw graphical evidence 
**(a) participation: individual rationality 
*******************************************
lgraph dropout01 week, by(contracts) xline(1, lp(dash)) legend(on order(1 "Simple Linear" 2 "Flat bonus/week" 3 "Pure Franchising" 4 "Threshold" 5 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Actual) Dropout Across Schemes") ytitle("Average: Dropout Indicator" "") xtitle("Week")

eststo Dropout_Overall: mean dropout01
eststo Dropout_Flatbonus: mean dropout01 if scheme=="Flat bonus/week"
eststo Dropout_Franchising: mean dropout01 if scheme=="Pure Franchising"
eststo Dropout_Simplelinear: mean dropout01 if scheme=="Simple Linear"
eststo Dropout_Threshold: mean dropout01 if scheme=="Threshold"
eststo Dropout_Tournament: mean dropout01 if scheme=="Tournament"
coefplot Dropout_Simplelinear Dropout_Flatbonus Dropout_Threshold Dropout_Franchising Dropout_Tournament, vertical xlabel("") xtitle("") ytitle("Average: Dropout Indicator") title("(Residualized) Actual Dropout") recast(bar) barwidth(0.15) fcolor(*.5) ciopts(recast(rcap)) citop citype(normal) level(90) graphregion(color(white)) legend(pos(4) col(1) size(small) region(col(white))) ylab(, nogrid)
gr export "${main_loc}/_paper/results/figures/actual_dropouts_avg.eps", replace

*remove e-levy effect: March 31, 2025
reg dropout01 i.week i.strata
predict res_dropout01, residuals
lgraph res_dropout01 week, by(contracts) xline(1, lp(dash)) legend(on order(1 "Simple Linear" 2 "Flat bonus/week" 3 "Franchising" 4 "Threshold" 5 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Residualized) Dropout") ytitle("Average: Dropout Indicator" " ") xtitle("Week")
gr export "${main_loc}/_paper/results/figures/res_dropout.eps", replace

eststo Revenue_Overall: mean res_dropout01
eststo Revenue_Flatbonus: mean res_dropout01 if scheme=="Flat bonus/week"
eststo Revenue_Franchising: mean res_dropout01 if scheme=="Pure Franchising"
eststo Revenue_Simplelinear: mean res_dropout01 if scheme=="Simple Linear"
eststo Revenue_Threshold: mean res_dropout01 if scheme=="Threshold"
eststo Revenue_Tournament: mean res_dropout01 if scheme=="Tournament"
coefplot Revenue_Simplelinear Revenue_Flatbonus Revenue_Threshold Revenue_Franchising Revenue_Tournament, vertical xlabel("") xtitle("") ytitle("Average: Dropout Indicator") title("(Residualized) Actual Dropout") recast(bar) barwidth(0.15) fcolor(*.5) ciopts(recast(rcap)) citop citype(normal) level(90) graphregion(color(white)) legend(pos(4) col(1) size(small) region(col(white))) ylab(, nogrid)
gr export "${main_loc}/_paper/results/figures/actual_dropouts_avg_res.eps", replace


**(b) performance: incentive compactibility
*******************************************
lgraph ghs_total week, by(contracts) xline(1, lp(dash)) legend(on order(1 "Simple Linear" 2 "Flat bonus/week" 3 "Pure Franchising" 4 "Threshold" 5 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Actual) Performance Across Schemes") ytitle("Average: Joint Revenue (GHS)" "") xtitle("Week")
*lgraph  ghs_mml week, by(contracts) xline(1, lp(dash)) legend(on order(1 "Simple Linear" 2 "Flat bonus/week" 3 "Pure Franchising" 4 "Threshold" 5 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Actual) Performance: MTN Revenue") ytitle("Average: MTN Revenue (GHS)")  xtitle("Week")
*lgraph ghs_agents week, by(contracts) xline(1, lp(dash)) legend(on order(1 "Simple Linear" 2 "Flat bonus/week" 3 "Pure Franchising" 4 "Threshold" 5 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Actual) Performance: Agent Revenue") ytitle("Average: Agent Revenue (GHS)")  xtitle("Week")

eststo Revenue_Overall: mean ghs_total
eststo Revenue_Flatbonus: mean ghs_total if scheme=="Flat bonus/week"
eststo Revenue_Franchising: mean ghs_total if scheme=="Pure Franchising"
eststo Revenue_Simplelinear: mean ghs_total if scheme=="Simple Linear"
eststo Revenue_Threshold: mean ghs_total if scheme=="Threshold"
eststo Revenue_Tournament: mean ghs_total if scheme=="Tournament"
coefplot Revenue_Simplelinear Revenue_Flatbonus Revenue_Franchising Revenue_Threshold Revenue_Tournament, vertical xlabel("") xtitle("") ytitle("Average: Joint Revenue (GHS)") title("(Actual) Performance Across Schemes") recast(bar) barwidth(0.15) fcolor(*.5) ciopts(recast(rcap)) citop citype(normal) level(90) graphregion(color(white)) legend(pos(4) col(1) size(small) region(col(white))) ylab(, nogrid)
gr export "${main_loc}/_paper/results/figures/actual_performance_total_avg.eps", replace

*remove e-levy effect: March 31, 2025
reg ghs_total i.week
predict res_ghs_total, residuals
reg ghs_mml i.week i.strata
predict res_ghs_mml, residuals
reg ghs_agents i.week i.strata
predict res_ghs_agents, residuals

lgraph res_ghs_total week, by(contracts) xline(1, lp(dash)) legend(on order(1 "Simple Linear" 2 "Flat bonus/week" 3 "Franchising" 4 "Threshold" 5 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Residualized) Total Revenue") ytitle("Average: Joint Revenue/Wk (GHS)" " ") xtitle("Week")
gr export "${main_loc}/_paper/results/figures/res_ghs_total.eps", replace
lgraph res_ghs_mml week, by(contracts) xline(1, lp(dash)) legend(on order(1 "Simple Linear" 2 "Flat bonus/week" 3 "Franchising" 4 "Threshold" 5 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Residualized) Performance: MTN Revenue") ytitle("Average: MTN Revenue/Wk (GHS)" " ") xtitle("Week")
gr export "${main_loc}/_paper/results/figures/res_ghs_mml.eps", replace
lgraph res_ghs_agents week, by(contracts) xline(1, lp(dash)) legend(on order(1 "Simple Linear" 2 "Flat bonus/week" 3 "Franchising" 4 "Threshold" 5 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Residualized) Performance: Agent Revenue") ytitle("Average: Agent Revenue/Wk (GHS)" " ") xtitle("Week")
gr export "${main_loc}/_paper/results/figures/res_ghs_agents.eps", replace

eststo Revenue_Overall: mean res_ghs_total
eststo Revenue_Flatbonus: mean res_ghs_total if scheme=="Flat bonus/week"
eststo Revenue_Franchising: mean res_ghs_total if scheme=="Pure Franchising"
eststo Revenue_Simplelinear: mean res_ghs_total if scheme=="Simple Linear"
eststo Revenue_Threshold: mean res_ghs_total if scheme=="Threshold"
eststo Revenue_Tournament: mean res_ghs_total if scheme=="Tournament"
coefplot Revenue_Simplelinear Revenue_Flatbonus Revenue_Threshold Revenue_Franchising Revenue_Tournament, vertical xlabel("") xtitle("") ytitle("Average: Joint Revenue (GHS)") title("(Residualized) Actual Total Revenue") recast(bar) barwidth(0.15) fcolor(*.5) ciopts(recast(rcap)) citop citype(normal) level(90) graphregion(color(white)) legend(pos(4) col(1) size(small) region(col(white))) ylab(, nogrid)
gr export "${main_loc}/_paper/results/figures/actual_performance_total_avg_res.eps", replace


**5) evaluation - treatment effects 
drop if week==0

*egen svar=group(scheme week)
*sample 70, by(svar) //draw 70% pseudorandom sample without replacement within strata svar [not necessary: exper is small frac of manager's portfolio]

*baseline y (note: aleady part of weekly payments records)
gen points_total_basel=(weeklyaveragescedis+w_ghs)*10
gen points_mml_basel=w_ghs*10
gen points_agents_basel=weeklyaveragescedis*10
gen revcostratio_mml_basel=w_ghs/weeklyaveragescedis

gen ghs_total_basel=points_total_basel/10
gen ghs_mml_basel=points_mml_basel/10
gen ghs_agents_basel=points_agents_basel/10

*generate retention (-dropout)
gen stayed01=.
replace stayed01=1 if dropout01==0 //prob (stay!)
replace stayed01=0 if dropout01==1


*(a) participation?
eststo clear
*uncond: baseline y=productivity
reg didntsigncontract01 flatbonus purefranchising threshold tournament i.strata, cluster(s1_1cii)
reg daystrialb4dropout flatbonus purefranchising threshold tournament i.strata, cluster(s1_1cii)
reg dropout01 flatbonus purefranchising threshold tournament i.strata, cluster(s1_1cii) //report
*cond: baseline y=productivity (do always!)
reg didntsigncontract01 flatbonus purefranchising threshold tournament i.strata ghs_total_basel, cluster(s1_1cii)
reg daystrialb4dropout flatbonus purefranchising threshold tournament i.strata ghs_total_basel, cluster(s1_1cii)
eststo: reg dropout01 flatbonus purefranchising threshold tournament i.strata ghs_total_basel, cluster(s1_1cii) //report


label var dropout01 "Dropout Indicator"
sum dropout01 if e(sample) == 1 & contracts==1
estadd local mean_depvar = string(`r(mean)', "%15.3fc"), replace
estadd local sd_depvar = string(`r(sd)', "%15.3fc"), replace

** generate table
forval fold = 1/2 {
	if `fold' == 1 local save_loc "${results}/tables" // save in two locations
	if `fold' == 2 local save_loc "${results_db}/tables"
	
	esttab using "`save_loc'/table1_IR.tex", 			 	 ///
		keep(flatbonus purefranchising threshold tournament) ///
		style(tex)											///
		nogaps												///
		nobaselevels 										///
		noconstant											///
		label            									///
		varwidth(50)										///
		wrap 												///
		cells (b(fmt(3) star) se(fmt(3) par)) 				///
		star(* 0.10 ** 0.05 *** 0.01) 						///
		stats(N 											///
			  mean_depvar 									///
			  sd_depvar, 									///
			  fmt(%9.0f %9.3f %9.3f) 						///
			  labels("Observations"					 		///
					 "Mean of dependent variable" ///
					 "SD of dependent variable")) ///
		replace
}


*(b) performance?
eststo clear
**total output ~ total surplus?
*******************************
*stage 0: ignore attrition:
eststo: reg ghs_total flatbonus purefranchising threshold tournament i.strata ghs_total_basel, cluster(s1_1cii)
reg ghs_total flatbonus purefranchising threshold tournament i.strata ghs_total_basel i.week, cluster(s1_1cii) 

label var ghs_total "Total Revenue/wk" 
sum ghs_total if e(sample) == 1 & contracts==1
estadd local mean_depvar = string(`r(mean)', "%15.3fc"), replace
estadd local sd_depvar = string(`r(sd)', "%15.3fc"), replace

//doesn't matter
/*
**short vs medium run**
**short: franchising winner
**medium & overall: tournament winner
**suggests learning effects?
reg ghs_total flatbonus purefranchising threshold tournament i.strata ghs_total_basel if week<=3, cluster(s1_1cii)
reg ghs_total flatbonus purefranchising threshold tournament i.strata ghs_total_basel if week>3, cluster(s1_1cii)
	xtile ghs_totalquart9 = ghs_total_basel, nq(9)
	leebounds ghs_total flatbonus, level(90) cieffect tight(ghs_totalquart9) 
	leebounds ghs_total purefranchising, level(90) cieffect tight(ghs_totalquart9)
	leebounds ghs_total threshold, level(90) cieffect tight(ghs_totalquart9) 
	leebounds ghs_total tournament, level(90) cieffect tight(ghs_totalquart9)
	*manually program the trimming to allow for conditioning
*/
*stage 1: post double-lasso: (i) improve power & resolves imbalances if any + (ii) rct but trt correlated w/ error due to attrition-key feature of our setup
pdslasso ghs_total flatbonus purefranchising threshold tournament (i.strata ghs_total_basel assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso

*stage 2: tripple-lasso ~ post double-lasso + ipw: full attrition correction
*quietly logit stayed01 i.strata ghs_total_basel i.contracts assignedpreferred01 hhincome_annual capital_momo //lasso-select
quietly logit stayed01 i.strata ghs_total_basel i.contracts assignedpreferred01 i.contracts#c.ghs_total_basel i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_total
reg ghs_total flatbonus purefranchising threshold tournament i.strata ghs_total_basel assignedpreferred01 hhincome_annual capital_momo [pweight = 1/phat_total], cluster(s1_1cii) //lasso-select 
reg ghs_total flatbonus purefranchising threshold tournament i.strata ghs_total_basel [pweight = 1/phat_total], cluster(s1_1cii) //base


**mtn revenues?
****************
*stage 0: ignore attrition
eststo: reg ghs_mml flatbonus purefranchising threshold tournament i.strata ghs_mml_basel, cluster(s1_1cii)
label var ghs_mml "MTN Revenue/wk"
sum ghs_mml if e(sample) == 1 & contracts==1
estadd local mean_depvar = string(`r(mean)', "%15.3fc"), replace
estadd local sd_depvar = string(`r(sd)', "%15.3fc"), replace

reg ghs_mml flatbonus purefranchising threshold tournament i.strata ghs_mml_basel i.week, cluster(s1_1cii) //doesn't matter
/*
**short vs medium run**
**short: franchising winner
**medium & overall: tournament winner
**suggests learning effects?
reg ghs_mml flatbonus purefranchising threshold tournament i.strata ghs_mml_basel if week<=3, cluster(s1_1cii)
reg ghs_mml flatbonus purefranchising threshold tournament i.strata ghs_mml_basel if week>3, cluster(s1_1cii)
	xtile ghs_mmlquart9 = ghs_mml_basel, nq(9)
	leebounds ghs_mml flatbonus, level(90) cieffect tight(ghs_mmlquart9) 
	leebounds ghs_mml purefranchising, level(90) cieffect tight(ghs_mmlquart9) 
	leebounds ghs_mml threshold, level(90) cieffect tight(ghs_mmlquart9) 
	leebounds ghs_mml tournament, level(90) cieffect tight(ghs_mmlquart9)
*/
*stage 1: post double-lasso
pdslasso ghs_mml flatbonus purefranchising threshold tournament (i.strata ghs_mml_basel assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
*stage 2: tripple-lasso:
*quietly logit stayed01 i.strata ghs_mml_basel i.contracts assignedpreferred01 hhincome_annual capital_momo //lasso-select
quietly logit stayed01 i.strata ghs_mml_basel i.contracts assignedpreferred01 i.contracts#c.ghs_agents_basel i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_mml
reg ghs_mml flatbonus purefranchising threshold tournament i.strata ghs_mml_basel assignedpreferred01 hhincome_annual capital_momo [pweight = 1/phat_mml], cluster(s1_1cii) //lasso-select
reg ghs_mml flatbonus purefranchising threshold tournament i.strata ghs_mml_basel [pweight = 1/phat_mml], cluster(s1_1cii) //base


**agent revenues (earnings)?
*****************************
*stage 0: ignore attrition
eststo: reg ghs_agents flatbonus purefranchising threshold tournament i.strata ghs_agents_basel, cluster(s1_1cii)
label var ghs_agents "Agent Revenue/wk"
sum ghs_agents if e(sample) == 1 & contracts==1
estadd local mean_depvar = string(`r(mean)', "%15.3fc"), replace
estadd local sd_depvar = string(`r(sd)', "%15.3fc"), replace

/*
**short vs medium run**
**short: franchising winner
**medium & overall: tournament winner
**suggest learning effects?
reg ghs_agents flatbonus purefranchising threshold tournament i.strata ghs_agents_basel if week<=3, cluster(s1_1cii)
reg ghs_agents flatbonus purefranchising threshold tournament i.strata ghs_agents_basel if week>3, cluster(s1_1cii)
	xtile ghs_agentsquart9 = ghs_agents_basel, nq(9)
	leebounds ghs_agents flatbonus, level(90) cieffect tight(ghs_agentsquart9) 
	leebounds ghs_agents purefranchising, level(90) cieffect tight(ghs_agentsquart9) 
	leebounds ghs_agents threshold, level(90) cieffect tight(ghs_agentsquart9) 
	leebounds ghs_agents tournament, level(90) cieffect tight(ghs_agentsquart9) 
	*manually program the trimming to allow for conditioning
*/
*stage 1: post double-lasso:
pdslasso ghs_agents flatbonus purefranchising threshold tournament (i.strata ghs_agents_basel assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
*stage 2: tripple-lasso:
*quietly logit stayed01 i.strata ghs_agents_basel i.contracts assignedpreferred01 hhincome_annual capital_momo //lasso-select
quietly logit stayed01 i.strata ghs_agents_basel i.contracts assignedpreferred01 i.contracts#c.ghs_agents_basel i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_agents
reg ghs_agents flatbonus purefranchising threshold tournament i.strata ghs_agents_basel assignedpreferred01 hhincome_annual capital_momo [pweight = 1/phat_agents], cluster(s1_1cii) //lasso-select
reg ghs_agents flatbonus purefranchising threshold tournament i.strata ghs_agents_basel [pweight = 1/phat_agents], cluster(s1_1cii) //base


**rev/cost ratio = ghs_mml/ghs_agents?
**************************************
*stage 0: ignore attrition
reg revcostratio_mml flatbonus purefranchising threshold tournament i.strata revcostratio_mml_basel, cluster(s1_1cii)
reg revcostratio_mml flatbonus purefranchising threshold tournament i.strata revcostratio_mml_basel i.week, cluster(s1_1cii) //doesn't matter
	/*
reg revcostratio_mml flatbonus purefranchising threshold tournament i.strata revcostratio_mml_basel if week<=3, cluster(s1_1cii)
reg revcostratio_mml flatbonus purefranchising threshold tournament i.strata revcostratio_mml_basel if week>3, cluster(s1_1cii)
	xtile ghs_revcostmmlquart9 = revcostratio_mml_basel, nq(9)
	leebounds revcostratio_mml flatbonus, level(90) cieffect tight(ghs_revcostmmlquart9) 
	leebounds revcostratio_mml purefranchising, level(90) cieffect tight(ghs_revcostmmlquart9) 
	leebounds revcostratio_mml threshold, level(90) cieffect tight(ghs_revcostmmlquart9) 
	leebounds revcostratio_mml tournament, level(90) cieffect tight(ghs_revcostmmlquart9) 
	*/
*stage 1: post double-lasso:
pdslasso revcostratio_mml flatbonus purefranchising threshold tournament (i.strata revcostratio_mml_basel assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
*stage 2: tripple-lasso:
*quietly logit stayed01 i.strata ghs_agents_basel i.contracts assignedpreferred01 hhincome_annual capital_momo //lasso-select
quietly logit stayed01 i.strata ghs_agents_basel i.contracts assignedpreferred01 i.contracts#c.ghs_agents_basel i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_revcostratio_mml
reg revcostratio_mml flatbonus purefranchising threshold tournament i.strata ghs_agents_basel assignedpreferred01 hhincome_annual capital_momo [pweight = 1/phat_revcostratio_mml], cluster(s1_1cii) //lasso-select
reg revcostratio_mml flatbonus purefranchising threshold tournament i.strata ghs_agents_basel [pweight = 1/phat_revcostratio_mml], cluster(s1_1cii) //base


** generate table
forval fold = 1/2 {
	if `fold' == 1 local save_loc "${results}/tables" // save in two locations
	if `fold' == 2 local save_loc "${results_db}/tables"
	
	esttab using "`save_loc'/table2_IC.tex", 			 	 ///
		keep(flatbonus purefranchising threshold tournament) ///
		style(tex)											///
		nogaps												///
		nobaselevels 										///
		noconstant											///
		label            									///
		varwidth(50)										///
		wrap 												///
		cells (b(fmt(3) star) se(fmt(3) par)) 				///
		star(* 0.10 ** 0.05 *** 0.01) 						///
		stats(N 											///
			  mean_depvar 									///
			  sd_depvar, 									///
			  fmt(%9.0f %9.3f %9.3f ) ///
			  labels("Observations"					 		///
					 "Mean of dependent variable" ///
					 "SD of dependent variable")) ///
		replace
}


*(c) ic* = performance*?
**invalid or noncompliance behavior?
**source - admin data based on in-house mml analytics, standard practice to verify compliance before payments
*key result (positive story) - flat & threshold: are 19.3% significantly more compliant than sq (interesting!)
***************************************************************************************************************
sum ghs_invalid_cashin if contracts==1 //sq control mean
*stage 0: ignore attrition:
reg ghs_invalid_cashin flatbonus purefranchising threshold tournament i.strata ghs_total_basel, cluster(s1_1cii)
reg ghs_invalid_cashin flatbonus purefranchising threshold tournament i.strata ghs_total_basel i.week, cluster(s1_1cii) //doesn't matter
/*
reg ghs_invalid_cashin flatbonus purefranchising threshold tournament i.strata ghs_total_basel if week<=3, cluster(s1_1cii)
reg ghs_invalid_cashin flatbonus purefranchising threshold tournament i.strata ghs_total_basel if week>3, cluster(s1_1cii)
	leebounds ghs_agents flatbonus, level(90) cieffect tight() 
	leebounds ghs_agents purefranchising, level(90) cieffect tight() 
	leebounds ghs_agents threshold, level(90) cieffect tight() 
	leebounds ghs_agents tournament, level(90) cieffect tight() 
	*manually program the trimming to allow for conditioning
*/
*stage 1: post double-lasso:
pdslasso ghs_invalid_cashin flatbonus purefranchising threshold tournament (i.strata ghs_total_basel assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
*stage 2: tripple-lasso:
*quietly logit stayed01 i.strata ghs_total_basel i.contracts assignedpreferred01 hhincome_annual capital_momo //lasso-select
quietly logit stayed01 i.strata ghs_total_basel i.contracts assignedpreferred01 i.contracts#c.ghs_total_basel i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_invalid
reg ghs_invalid_cashin flatbonus purefranchising threshold tournament i.strata ghs_total_basel assignedpreferred01 hhincome_annual capital_momo [pweight = 1/phat_invalid], cluster(s1_1cii) //lasso-select
reg ghs_invalid_cashin flatbonus purefranchising threshold tournament i.strata ghs_total_basel [pweight = 1/phat_invalid], cluster(s1_1cii)


saveold "${main_loc}/_paper/intermediate_data/data_treatmenteffects_main.dta", replace
*interpreting rsults: 3) selection into contracts? 
*admin data evidence? generally "null"
*implement it there too...
reg ghs_total c.assignedpreferred01##(flatbonus purefranchising threshold tournament) i.strata ghs_total_basel, cluster(s1_1cii)
reg ghs_mml c.assignedpreferred01##(flatbonus purefranchising threshold tournament) i.strata ghs_mml_basel, cluster(s1_1cii)
reg ghs_agents c.assignedpreferred01##(flatbonus purefranchising threshold tournament) i.strata ghs_agents_basel, cluster(s1_1cii)

log close













