*December 11, 2025
*heterogeneity*

clear all
log using "${main_loc}/_paper/results/treatmenteffects_heterogeneity_draft.log", replace
*bring in data_treatmenteffects_main (from main analysis?)
use "${main_loc}/_paper/intermediate_data/data_treatmenteffects_main.dta", clear
tab week

***get heterogneity var set***
*1.firm size
qui sum ghs_total_basel, detail
gen largefirm01_basel= ghs_total_basel>r(p50) if !missing(ghs_total_basel)
tab largefirm01_basel
*2.relationship to store: operatorandowner
*3.worker's gender: female
*4.market location: rural/urban
gen urbanrural01=.
replace urbanrural01 = 0 if classification_of_localities == "Urban"
replace urbanrural01 = 1 if classification_of_localities == "Rural"
**5.risk: at individual-level vs market-level?
*baseline measures
*gen baselinevariance_indiv = weeklySDcedis //construct SD based on past values
bys s1_1cii: egen baselinevariance_mkt = sd(ghs_total_basel) //get market volatility (or homogeneity?): based on past averages
qui sum baselinevariance_mkt, detail
gen highrisk01_basel=baselinevariance_mkt>r(p50) if !missing(baselinevariance_mkt)
tab highrisk01_basel
*endline measures
*q: how easy is it to predict the sales for the next....

*6.frequently interact w/ managers: interactwmanager
*7.bundled services
gen retailnonmtnmomos=(s3_2=="Yes") if !missing(s3_2) //do other momo providers
gen retailnonfinancial=(s6_2=="Yes") if !missing(s6_2) //do nonfinancial, bundled stores
winsor2 s7_4, suffix(_wb) cuts(5 95)
gen numberagents_locality=s7_4_wb



*results*
**1) Firm size (large/small)
reg ghs_total flatbonus purefranchising threshold tournament largefirm01_basel c.flatbonus#c.largefirm01_basel c.purefranchising#c.largefirm01_basel c.threshold#c.largefirm01_basel c.tournament#c.largefirm01_basel i.strata ghs_total_basel, cluster(s1_1cii)
**2) Relationship to store (owner-and-operator)
reg ghs_total flatbonus purefranchising threshold tournament operatorandowner c.flatbonus#c.operatorandowner c.purefranchising#c.operatorandowner c.threshold#c.operatorandowner c.tournament#c.operatorandowner i.strata ghs_total_basel, cluster(s1_1cii)
**3) Agent’s gender (female)
reg ghs_total flatbonus purefranchising threshold tournament female c.flatbonus#c.female c.purefranchising#c.female c.threshold#c.female c.tournament#c.female i.strata ghs_total_basel, cluster(s1_1cii)
**4) Market - Location (urban/rural)
reg ghs_total flatbonus purefranchising threshold tournament urbanrural01 c.flatbonus#c.urbanrural01 c.purefranchising#c.urbanrural01 c.threshold#c.urbanrural01 c.tournament#c.urbanrural01 i.strata ghs_total_basel, cluster(s1_1cii)
**5) Market - baseline # of agents: competition vs learning potential
reg ghs_total flatbonus purefranchising threshold tournament numberagents_locality c.flatbonus#c.numberagents_locality c.purefranchising#c.numberagents_locality c.threshold#c.numberagents_locality c.tournament#c.numberagents_locality i.strata ghs_total_basel, cluster(s1_1cii)
**6) Risk - market level volatility (or homegeneity)
reg ghs_total flatbonus purefranchising threshold tournament highrisk01_basel c.flatbonus#c.highrisk01_basel c.purefranchising#c.highrisk01_basel c.threshold#c.highrisk01_basel c.tournament#c.highrisk01_basel i.strata ghs_total_basel, cluster(s1_1cii)
**7) Interaction: frequently interact w/ managers
reg ghs_total flatbonus purefranchising threshold tournament interactwmanager c.flatbonus#c.interactwmanager c.purefranchising#c.interactwmanager c.threshold#c.interactwmanager c.tournament#c.interactwmanager i.strata ghs_total_basel, cluster(s1_1cii)
**8) Bundled: retial non-mtn momo
reg ghs_total flatbonus purefranchising threshold tournament retailnonmtnmomos c.flatbonus#c.retailnonmtnmomos c.purefranchising#c.retailnonmtnmomos c.threshold#c.retailnonmtnmomos c.tournament#c.retailnonmtnmomos i.strata ghs_total_basel, cluster(s1_1cii)
**9) Bundled: retail non-financial services
reg ghs_total flatbonus purefranchising threshold tournament retailnonfinancial c.flatbonus#c.retailnonfinancial c.purefranchising#c.retailnonfinancial c.threshold#c.retailnonfinancial c.tournament#c.retailnonfinancial i.strata ghs_total_basel, cluster(s1_1cii)
**10) Agent preference (assigned/preferred)
*reg ghs_total flatbonus purefranchising threshold tournament assignedpreferred01 c.flatbonus#c.assignedpreferred01 c.purefranchising#c.assignedpreferred01 c.threshold#c.assignedpreferred01 c.tournament#c.assignedpreferred01 i.strata ghs_total_basel, cluster(s1_1cii)


log close








