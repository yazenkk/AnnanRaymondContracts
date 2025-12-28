*Interpreting the Results-1*
**admin/expermiment data + baseline survey data + audit study**


*(A) results - drivers of performance differences*
**(1a) Selection out of Contracts - Dropout Effects vs (1b) Endline Surveys - Dropout Effects
**(2) Selection into Contracts – Assigned Preferred Contract
**(3) Selection on Preference Parameters
**(4) Changes to Market Relationships and Pricing (+Audit study!)
**(5) Effort – Labor Supply Effects 
***-Treatment Effects on Effort – Labor Supply
***-Labor Supply Effects: Habit Formation, Not Intertemporal Re-allocation
***6- overall, any regrets?


*(A) results - drivers of performance differences*
clear all
log using "${main_loc}/_paper/results/performance_differences_draft.log", replace

**bring in (admin), endline & baseline surveys
***********************************************
*1) agents survey (endline)
*use "C:/Users/USER/Dropbox/contracts-w Collin/survey_data_management/Endline Rolling Data/Agent_0110.dta", clear //agents data
use "${main_loc}/survey_data_management/Endline Rolling Data/Agent_0110.dta", clear
drop caseid
rename id_key caseid
destring caseid, replace
// save "${main_loc}/instruments/endline/Sample_endline/optn3_sample_2574_wdropout.dta", replace

*2) agents survey (baseline)
merge m:1 caseid using "${main_loc}/instruments/endline/Sample_endline/optn3_sample_2574_wdropout.dta", gen(_mergeendline) 
keep if _mergeendline==3

*Restructuring dropout vars
decode enum, gen(enum_name)
tab signature, m
tab dropout_status, m
gen signature_num = (signature == "Yes") 
drop signature
rename signature_num signature
label define siglbl 0 "No" 1 "Yes"
label values signature siglbl
gen dropout_num = . 
replace dropout_num = 1 if dropout_status == "Stayed"
replace dropout_num = 0 if dropout_status == "Opted out"
drop dropout_status
rename dropout_num dropout_status
label define droplbl 0 "Opted out" 1 "Stayed"
label values dropout_status droplbl
tab signature, m
tab dropout_status, m
tab signature, nolab
tab dropout_status, nolab

*Baseline mml reverse revenue ranking
forvalues i = 1/5 {
    gen q2_`i'_1 = 6 - q2_`i'
}
**Generating ranks for profit maximization that aligns with baseline ranking
tab rank1 //endline ranking
tab rank1, nolab
*Reversing revenue rank positions: endlinerev_rank1 = rank5, ..., endlinerev_rank5 = rank1  
forvalues i = 1/5 {
    gen endlinerev_rank`i' = rank`=6-`i''
}
label define scheme_lbl 1 "Simple Linear" 2 "Flat bonus/week" 3 "Threshold" 4 "Pure Franchising" 5 "Tournament"
forvalues i = 1/5 {
    label values endlinerev_rank`i' scheme_lbl
}

gen q2_1_linear=. //simple linear
replace q2_1_linear=1 if endlinerev_rank1==1 
replace q2_1_linear=2 if endlinerev_rank2==1
replace q2_1_linear=3 if endlinerev_rank3==1
replace q2_1_linear=4 if endlinerev_rank4==1
replace q2_1_linear=5 if endlinerev_rank5==1
tab q2_1_1
tab q2_1_linear
*dis 292+276+376+836+526
gen q2_1_samelinear=.
replace q2_1_samelinear=1 if q2_1_linear==q2_1_1
replace q2_1_samelinear=0 if q2_1_linear!=q2_1_1 & !missing(q2_1_linear)
tab q2_1_samelinear
tab q2_1_samelinear, m

tab rank1 //endline ranking
tab rank1, nolab
gen q2_2_flat=. //flat bonus
replace q2_2_flat=1 if endlinerev_rank1==2 
replace q2_2_flat=2 if endlinerev_rank2==2
replace q2_2_flat=3 if endlinerev_rank3==2
replace q2_2_flat=4 if endlinerev_rank4==2
replace q2_2_flat=5 if endlinerev_rank5==2
tab q2_2_1
tab q2_2_flat
gen q2_2_sameflat=.
replace q2_2_sameflat=1 if q2_2_flat==q2_2_1
replace q2_2_sameflat=0 if q2_2_flat!=q2_2_1 & !missing(q2_2_flat)
tab q2_2_sameflat
tab q2_2_sameflat, m

tab rank1 //endline ranking
tab rank1, nolab
gen q2_3_threshold=. //threshold
replace q2_3_threshold=1 if endlinerev_rank1==3 
replace q2_3_threshold=2 if endlinerev_rank2==3
replace q2_3_threshold=3 if endlinerev_rank3==3
replace q2_3_threshold=4 if endlinerev_rank4==3
replace q2_3_threshold=5 if endlinerev_rank5==3
tab q2_3_1
tab q2_3_threshold
gen q2_3_samethreshold=.
replace q2_3_samethreshold=1 if q2_3_threshold==q2_3_1
replace q2_3_samethreshold=0 if q2_3_threshold!=q2_3_1 & !missing(q2_3_threshold)
tab q2_3_samethreshold
tab q2_3_samethreshold, m

tab rank1 //endline ranking
tab rank1, nolab
gen q2_4_franchise=. //pure franchising
replace q2_4_franchise=1 if endlinerev_rank1==4 
replace q2_4_franchise=2 if endlinerev_rank2==4
replace q2_4_franchise=3 if endlinerev_rank3==4
replace q2_4_franchise=4 if endlinerev_rank4==4
replace q2_4_franchise=5 if endlinerev_rank5==4
tab q2_4_1
tab q2_4_franchise
gen q2_4_samefranchise=.
replace q2_4_samefranchise=1 if q2_4_franchise==q2_4_1
replace q2_4_samefranchise=0 if q2_4_franchise!=q2_4_1 & !missing(q2_4_franchise)
tab q2_4_samefranchise
tab q2_4_samefranchise, m

tab rank1 //endline ranking
tab rank1, nolab
gen q2_5_tournament=. //tournament
replace q2_5_tournament=1 if endlinerev_rank1==5 
replace q2_5_tournament=2 if endlinerev_rank2==5
replace q2_5_tournament=3 if endlinerev_rank3==5
replace q2_5_tournament=4 if endlinerev_rank4==5
replace q2_5_tournament=5 if endlinerev_rank5==5
tab q2_5_1
tab q2_5_tournament
gen q2_5_sametournament=.
replace q2_5_sametournament=1 if q2_5_tournament==q2_5_1
replace q2_5_sametournament=0 if q2_5_tournament!=q2_5_1 & !missing(q2_5_tournament)
tab q2_5_sametournament
tab q2_5_sametournament, m

br q2_1_linear q2_2_flat q2_3_threshold q2_4_franchise q2_5_tournament //newly created ending performance reversed rankings
br q2_1_linear q2_2_flat q2_3_threshold q2_4_franchise q2_5_tournament q2_1_1 q2_2_1 q2_3_1 q2_4_1 q2_5_1 //both baseline and endline
br q2_1_linear q2_2_flat q2_3_threshold q2_4_franchise q2_5_tournament q2_1_1 q2_2_1 q2_3_1 q2_4_1 q2_5_1 q2_4_samefranchise //cross-checking for consistency

gen all_consistentranks = . //checking consistency in all 5 ranks for both baseline and endline
replace all_consistentranks = 1 if q2_1_linear==q2_1_1 & q2_2_flat==q2_2_1 & q2_3_threshold==q2_3_1 & q2_4_franchise==q2_4_1 & q2_5_tournament==q2_5_1
replace all_consistentranks = 0 if !missing(q2_1_linear, q2_1_1, q2_2_flat, q2_2_1, q2_3_threshold, q2_3_1, q2_4_franchise, q2_4_1, q2_5_tournament, q2_5_1) & (q2_1_linear!=q2_1_1 | q2_2_flat!=q2_2_1 | q2_3_threshold!=q2_3_1 | q2_4_franchise!=q2_4_1 | q2_5_tournament!=q2_5_1)
tab all_consistentranks, missing
br q2_1_linear q2_2_flat q2_3_threshold q2_4_franchise q2_5_tournament q2_1_1 q2_2_1 q2_3_1 q2_4_1 q2_5_1 all_consistentranks

*Reverse dropout rank positions: dropout_rank1 = rrank5, ..., dropout_rank5 = rrank1
forvalues i = 1/5 {
    gen dropout_rank`i' = rrank`=6-`i''
}
capture label define scheme_lbl 1 "Simple Linear" 2 "Flat bonus/week" 3 "Threshold" 4 "Pure Franchising" 5 "Tournament"
forvalues i = 1/5 {
    label values dropout_rank`i' scheme_lbl
}
**Corrections**
list caseid enum_name Q5_4 if Q5_4 == 1040000 & !missing(Q5_4) //amount borrowed in the last loan request
list caseid enum_name village_name_pl ca_name_pl Q5_2 if Q5_2 <6000
replace Q5_2 = 3600 if caseid == 12630 //hh_income
replace Q5_2 = 20000 if caseid == 12398
replace Q5_2 = 10000 if caseid == 15415
replace Q5_2 = 40000 if caseid == 10547
replace Q5_2 = 36000 if caseid == 12639
replace Q5_2 = 40000 if caseid == 13016
replace Q5_2 = 15000 if caseid == 15410
replace Q5_2 = 35000 if caseid == 10576
replace Q5_2 = 24000 if caseid == 14044
replace Q5_2 = 15000 if caseid == 14039
replace Q5_2 = 15000 if caseid == 12124
replace Q5_2 = 48000 if caseid == 15545
replace Q5_2 = 48000 if caseid == 12580
replace Q5_2 = 30000 if caseid == 12630
replace Q5_2 = 20000 if caseid == 12398
replace Q5_2 = 26400 if caseid == 12879
replace Q5_2 = 48000 if caseid == 12881
replace Q5_2 = 42000 if caseid == 15297
replace Q5_2 = 30000 if caseid == 14043
replace Q5_2 = 24000 if caseid == 12294
replace Q5_2 = 27000 if caseid == 12243
replace Q5_2 = 60000 if caseid == 10827
replace Q5_2 = 60000 if caseid == 12584
replace Q5_2 = 36000 if caseid == 15095
replace Q5_2 = 48000 if caseid == 15087
replace Q5_2 = . if Q5_2 == -99
replace Q5_2 = . if caseid == 12913
replace Q5_2 = 7200 if caseid == 13119
replace Q5_2 = 36000 if caseid == 12343
replace Q5_2 = 42000 if caseid == 13567
replace Q5_2 = 25000 if caseid == 14858
replace Q5_2 = 60000 if caseid == 10827
replace Q5_2 = 60000 if caseid == 12584
replace Q5_2 = 36000 if caseid == 15095
replace Q5_2 = 48000 if caseid == 15087
replace Q5_2 = 40000 if caseid == 14837
replace Q5_2 = 25000 if caseid == 12806
replace Q5_2 = 24000 if caseid == 10543
replace Q5_2 = 24000 if caseid == 15086
replace Q5_2 = 48000 if caseid == 15543
replace Q5_2 = 20000 if caseid == 10561
replace Q5_2 = 36000 if caseid == 12895
replace Q5_2 = 20000 if caseid == 12901
replace Q5_2 = 54000 if caseid == 14880
replace Q5_2 = 18000 if caseid == 11917
replace Q5_2 = 25000 if caseid == 14596
replace Q5_2 = 36000 if caseid == 14635
replace Q5_2 = 48000 if caseid == 12593
replace Q5_2 = 18000 if caseid == 12699
replace Q5_2 = 15000 if caseid == 14445
replace Q5_2 = 60000 if caseid == 14535
replace Q5_2 = 16000 if caseid == 15396
replace Q5_2 = 16000 if caseid == 15729
replace Q5_4 = 10000 if caseid == 15285 //amt borrowed
replace Q14x_8 = 5000 if caseid == 14571
list caseid enum_name Q5_4 if Q5_4 == 1040000 & !missing(Q5_4) //
list caseid enum_name village_name_pl ca_name_pl Q5_2 if Q5_2 <6000
list caseid enum_name village_name_pl ca_name_pl Q5_2 if Q5_2 >100000 & !missing(Q5_2)

**Generating treatment dummies**
tab treatment_contract, gen(trt)
rename trt1 flatbonus
rename trt2 purefranchising
*control or intercept = simple linear
rename trt4 threshold
rename trt5 tournament
gen pooledcontract=1
replace pooledcontract=0 if  treatment_contract=="Simple Linear"
tab pooledcontract, miss
tab trt

**Revenues**
**baseline**
tab s6_3x
replace s6_3x = . if s6_3x >=33000 //baseline momo commissions
rename s6_3x baseline_momo_bonus
tab s6_3
replace s6_3 = . if s6_3 ==99999 |s6_3 ==0 | s6_3 ==9 // core mtn momo revenue
rename s6_3 baseline_corecico_revenue
tab s6_4
replace s6_4 = . if s6_4==99999 //momo_income
rename s6_4 baseline_momo_income
tab s6_8 //total business income in last 7 days
replace s6_8 = . if s6_8 >=99999 | s6_8>=9999999 | s6_8==99999
rename s6_8 baseline_totbusiness_income
tab s6_5 //noncore mtn momo sales revenue
replace s6_5 = . if s6_5 >=99999
rename s6_5 baseline_noncore_sales
tab s6_6 //non mtn momo sales revenue
rename s6_6 baseline_nonmtnmomo_sales
tab s6_7 //non momo sales
replace s6_7 = . if s6_7==0
rename s6_7 baseline_nonmomo_sales 
**endline**
tab Q2_5 // core mtn momo revenue/month
replace Q2_5 = . if Q2_5 == 0 | Q2_5 > 8000000
rename Q2_5 endline_corecico_revenue
tab Q3_5 //momo business income/month
replace Q3_5 = . if Q3_5 > 27000
rename Q3_5 endline_momo_income
tab Q4_5 //noncore mtn momo sales revenue
replace Q4_5 = . if Q4_5==99999
rename Q4_5 endline_noncoresales
tab Q5_5 //non mtn momo sales revenue
replace Q5_5 = . if Q5_5 ==9999 | Q5_5==99999 | Q5_5>=999999
rename Q5_5 endline_nonmtnmomosales
tab Q6_5 //non momo sales
replace Q6_5 =. if Q6_5 == 0 
rename Q6_5 endline_nonmomo_sales
tab Q8_5 //non momo business income earned previous month
replace Q8_5 =. if Q8_5==300000
rename Q8_5 endline_nonmomo_income

*controls vars set
gen operatorandowner = (s1_2 == 1) if !missing(s1_2) 
gen age_yrs=s0_2
recode s2_3 (1 = 0) (2 = 1)
gen female=(s2_3==1) if !missing(s2_3)
gen educ_postsecondary = (s2_1==4 |  s2_1==5 | s2_1==6) if !missing(s2_1)
gen interactwmanager=(q8c==3 | q8c==4) if !missing(q8c)
gen hhsize=s2_4
winsor2 sa_2 s2_5 s8_9 s8_6, suffix(_wb) cuts(5 95) 
gen hhincome_annual=s2_5_wb
recode sa_3 (1 = 0) (2 = 1)
gen currentschemeadequate=(sa_3==0) if !missing(sa_3)
gen workexperience_yrs=s2_6
gen capital_momo=s8_9_wb 
gen employees_store=s8_6_wb 
gen rassigned=treatment_contract
tab rassigned, miss
gen preferred=""
replace preferred = "Simple Linear" if q2==1
replace preferred = "Flat bonus/week" if q2==2
replace preferred = "Threshold" if q2==3
replace preferred = "Pure Franchising" if q2==4
replace preferred = "Tournament" if q2==5
gen assignedpreferred01 = (rassigned==preferred) 
sum assignedpreferred01
tab assignedpreferred01, missing
gen baseline_bonus=sa_2_wb
gen stayed01=.
replace stayed01=1 if dropout_status==1 & !missing(dropout_status) //prob (stay!)
replace stayed01=0 if dropout_status==0 & !missing(dropout_status)
gen contracts=1 //control "Simple Linear"
replace contracts =2 if treatment_contract=="Flat bonus/week"
replace contracts =3 if treatment_contract=="Pure Franchising"
replace contracts =4 if treatment_contract=="Threshold"
replace contracts =5 if treatment_contract=="Tournament"


saveold "${main_loc}/_paper/intermediate_data/data_interpretingresults.dta", replace


*1) selection out of contracts? no!!
*survey data evidence? 
**are signatures/stayers performance comparable to nonsignatures/nonstayers? 
**dropouts equally-performed? yes
*key result -- dropout differential but no differences in performance
*************************************
tab dropout_status
tab dropout_status, nolab
 *reg dropout_status flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)
**pooled sample, any diffs in performance? (1)
 reg endline_corecico_revenue dropout_status i.strata baseline_corecico_revenue, cluster(s1_1cii)
 reg endline_corecico_revenue c.dropout_status##(flatbonus purefranchising threshold tournament) i.strata baseline_corecico_revenue, cluster(s1_1cii)
 reg endline_momo_income dropout_status i.strata baseline_corecico_revenue, cluster(s1_1cii)
 reg endline_momo_income c.dropout_status##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
 reg endline_noncoresales dropout_status i.strata baseline_corecico_revenue, cluster(s1_1cii)
 reg endline_noncoresales c.dropout_status##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
 reg endline_nonmtnmomosales dropout_status i.strata baseline_corecico_revenue, cluster(s1_1cii)
 reg endline_nonmtnmomosales c.dropout_status##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)

**conditional on dropout sample, any diffs in performance? no //report (2)
sum endline_momo_income endline_corecico_revenue endline_nonmomo_income endline_nonmomo_sales if dropout_status == 0 & treatment_contract=="Simple Linear"
 reg endline_momo_income flatbonus purefranchising threshold tournament i.strata baseline_momo_income if dropout_status == 0, cluster(s1_1cii)
 reg endline_corecico_revenue flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue if dropout_status == 0, cluster(s1_1cii) 
 reg endline_nonmomo_income flatbonus purefranchising threshold tournament i.strata baseline_totbusiness_income if dropout_status == 0, cluster(s1_1cii) 
 reg endline_nonmomo_sales flatbonus purefranchising threshold tournament i.strata baseline_nonmomo_sales if dropout_status == 0, cluster(s1_1cii) 
 
**dropouts report constant or increase in performance when asked? no // report (3)
*result -- no differences in (subjective) performance
tab N2b
gen dropout_sameperform=(N2b==2) if !missing(N2b)
gen dropout_increaperform=(N2b==3) if !missing(N2b)
*admin definition //use
reg dropout_sameperform flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue if dropout_status == 0, cluster(s1_1cii)
reg dropout_increaperform flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue if dropout_status == 0, cluster(s1_1cii)
**survey definition*
reg dropout_sameperform flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg dropout_increaperform flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)

**signatures equally-performed? yes (1b)
tab signature
tab signature, nolab
reg endline_momo_income signature i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.signature##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue signature i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.signature##(flatbonus purefranchising threshold tournament) i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_nonmomo_income signature i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_nonmomo_income c.signature##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_nonmtnmomosales signature i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_nonmtnmomosales c.signature##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
**conditional on signature sample, any diffs in performance? no (2b)
sum endline_momo_income endline_corecico_revenue endline_nonmomo_income endline_nonmomo_sales if signature == 0 & treatment_contract=="Simple Linear"
 reg endline_momo_income flatbonus purefranchising threshold tournament i.strata baseline_momo_income if signature == 0, cluster(s1_1cii)
 reg endline_corecico_revenue flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue if signature == 0, cluster(s1_1cii) 
 reg endline_nonmomo_income flatbonus purefranchising threshold tournament i.strata baseline_totbusiness_income if signature == 0, cluster(s1_1cii) 
 reg endline_nonmomo_sales flatbonus purefranchising threshold tournament i.strata baseline_nonmomo_sales if signature == 0, cluster(s1_1cii) 
 
 
**#####################################**
**admin data evidence?
*bring in admin data #2 - Foster MML
preserve
use "${main_loc}/survey_data_management/Admin Data Request/Post ISSER Data Request Updated", clear
	merge m:1 icx using "${main_loc}/survey_data_management/Endline Rolling Data/_intermediate_agent_endldata.dta"
keep if _merge==3

gen cico_value =cash_in_value + cash_out_value
gen cico_volume = cash_in_volume + cash_out_volume
gen cico_bonus = cash_in_comm + cash_out_comm
swindex cico_value cico_volume airtime_value airtime_volume, gen(output)
winsor2 cico_value cico_volume cico_bonus airtime_value airtime_volume output, suffix(_w) cuts(0 95) 

tab treatment_contract
/*
gen contracts=1 //control "Simple Linear"
replace contracts =2 if treatment_contract=="Flat bonus/week"
replace contracts =3 if treatment_contract=="Pure Franchising"
replace contracts =4 if treatment_contract=="Threshold"
replace contracts =5 if treatment_contract=="Tournament"
collapse (sum) cico_value cico_volume cico_bonus airtime_value airtime_volume output, by(icx weekno treatment_contract contracts dropout_status strata s1_1cii) 
*/

*dropouts: any performance differences?
*if droupout -- REPORT?
***************
tab dropout_status
tab dropout_status, nolab //dropout=0

sum cico_bonus cico_value airtime_value output if inrange(weekno, 19, 30) & dropout_status==0 & treatment_contract=="Simple Linear"
reg cico_bonus flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30) & dropout_status==0, cluster(s1_1cii) //during trial period
reg cico_value flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30) & dropout_status==0, cluster(s1_1cii) //during trial period
*reg cico_volume flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30) & dropout_status==0, cluster(s1_1cii) //during trial period
reg airtime_value flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30) & dropout_status==0, cluster(s1_1cii) //during trial period
*reg airtime_volume flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30) & dropout_status==0, cluster(s1_1cii) //during trial period
reg output flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30) & dropout_status==0, cluster(s1_1cii) //during trial period
restore
**#####################################**




*2) labor supply responses? yes!!
*survey data evidence? 
**surveys data -- labor supply responses?
*key result -- strong evidence of ls increases, + persistent (!)
****************************************************************
gen operating_hours = .
replace operating_hours = 1 if Q1x >= 8 & !missing(Q1x)
replace operating_hours = 0 if Q1x < 8 & !missing(Q1x)
tab operating_hours
gen operating_days = .
replace operating_days = 1 if Q1xx >= 5 & !missing(Q1xx)
replace operating_days = 0 if Q1xx < 5 & !missing(Q1xx)
tab operating_days
*Steps taken to increase sales revenue / attract customers
tab Q1xxz1_1 //open shop early 
tab Q1xxz1_2 //work longer hours/day or work many days/week
tab Q1xxz1_3 //invested more liquidity to ensure transactions are not declined
tab Q1xxz1_4 //offered customers discount
tab Q1xxz1_5 //increased adverts
tab Q1xxz1_6 //posted tariffs or disclosed fees
tab Q1xxz1_7 //improved customer service
tab Q1xxz1_specify //others

tab Q1xxz2 //efforts / investments with other momo
tab Q1xxz3 //efforts / investments with non-momo
tab Q2_8 //added another line of business 

**laborsupply?
	*ssc install swindex
	swindex Q1x Q1xx Q1xxz1_1, gen(ls) //hrs.day + days.week + open.early
	sum ls if treatment_contract=="Simple Linear"
	
*stage 0: ignore attrition
reg ls flatbonus purefranchising threshold tournament i.strata , cluster(s1_1cii) 
reg Q1x flatbonus purefranchising threshold tournament i.strata , cluster(s1_1cii) 
reg Q1xx flatbonus purefranchising threshold tournament i.strata , cluster(s1_1cii) 
reg Q1xxz1_1 flatbonus purefranchising threshold tournament i.strata , cluster(s1_1cii) 
**capital/liquidity?
tab Q1xxz1_3, nolab
reg Q1xxz1_3 flatbonus purefranchising threshold tournament i.strata , cluster(s1_1cii) 
**other channels?
reg Q1xxz1_4 flatbonus purefranchising threshold tournament i.strata , cluster(s1_1cii) 
reg Q1xxz1_5 flatbonus purefranchising threshold tournament i.strata , cluster(s1_1cii) 
reg Q1xxz1_6 flatbonus purefranchising threshold tournament i.strata , cluster(s1_1cii) 
reg Q1xxz1_7 flatbonus purefranchising threshold tournament i.strata , cluster(s1_1cii) 

*stage 1: post double-lasso: (i) improve power + (ii) rct but trt correlated w/ error due to attrition-key feature of our setup
**laborsupply?
pdslasso ls flatbonus purefranchising threshold tournament (i.strata baseline_bonus assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
pdslasso Q1x flatbonus purefranchising threshold tournament (i.strata baseline_bonus assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
pdslasso Q1xx flatbonus purefranchising threshold tournament (i.strata baseline_bonus assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso 
pdslasso Q1xxz1_1 flatbonus purefranchising threshold tournament (i.strata baseline_bonus assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso 
**capital/liquidity?
pdslasso Q1xxz1_3 flatbonus purefranchising threshold tournament (i.strata baseline_bonus assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso 
**other channels?
pdslasso Q1xxz1_4 flatbonus purefranchising threshold tournament (i.strata baseline_bonus assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso 
pdslasso Q1xxz1_5 flatbonus purefranchising threshold tournament (i.strata baseline_bonus assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
pdslasso Q1xxz1_6 flatbonus purefranchising threshold tournament (i.strata baseline_bonus assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso 
pdslasso Q1xxz1_7 flatbonus purefranchising threshold tournament (i.strata baseline_bonus assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso 

*stage 2: tripple lasso
*laboursupply?
quietly logit stayed01 i.strata ls i.contracts assignedpreferred01 i.contracts#c.baseline_bonus i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_ls
reg ls flatbonus purefranchising threshold tournament i.strata baseline_bonus assignedpreferred01 female [pweight = 1/phat_ls], cluster(s1_1cii) //lasso-select
reg ls flatbonus purefranchising threshold tournament i.strata baseline_bonus [pweight = 1/phat_ls], cluster(s1_1cii)
quietly logit stayed01 i.strata Q1x i.contracts assignedpreferred01 i.contracts#c.baseline_bonus i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_Q1x
reg Q1x flatbonus purefranchising threshold tournament i.strata baseline_bonus assignedpreferred01 female [pweight = 1/phat_ls], cluster(s1_1cii) //lasso-select
reg Q1x flatbonus purefranchising threshold tournament i.strata baseline_bonus [pweight = 1/phat_Q1x], cluster(s1_1cii)
quietly logit stayed01 i.strata Q1xx i.contracts assignedpreferred01 i.contracts#c.baseline_bonus i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_Q1xx
reg Q1xx flatbonus purefranchising threshold tournament i.strata assignedpreferred01 female [pweight = 1/phat_ls], cluster(s1_1cii) //lasso-select
quietly logit stayed01 i.strata Q1xxz1_1 i.contracts assignedpreferred01 i.contracts#c.baseline_bonus i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_Q1xxz1_1
reg Q1xxz1_1 flatbonus purefranchising threshold tournament i.strata baseline_bonus assignedpreferred01 [pweight = 1/phat_ls], cluster(s1_1cii) //lasso-select
reg Q1xxz1_1 flatbonus purefranchising threshold tournament i.strata baseline_bonus [pweight = 1/phat_Q1xxz1_1], cluster(s1_1cii)
**capital/liquidity?
quietly logit stayed01 i.strata Q1xxz1_3 i.contracts assignedpreferred01 i.contracts#c.baseline_bonus i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_Q1xxz1_3
reg Q1xxz1_3 flatbonus purefranchising threshold tournament i.strata baseline_bonus assignedpreferred01 [pweight = 1/phat_ls], cluster(s1_1cii) //lasso-select
reg Q1xxz1_3 flatbonus purefranchising threshold tournament i.strata baseline_bonus [pweight = 1/phat_Q1xxz1_3], cluster(s1_1cii)
**other channels?
quietly logit stayed01 i.strata Q1xxz1_4 i.contracts assignedpreferred01 i.contracts#c.baseline_bonus i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_Q1xxz1_4
reg Q1xxz1_4 flatbonus purefranchising threshold tournament i.strata assignedpreferred01 [pweight = 1/phat_Q1xxz1_4], cluster(s1_1cii) //lasso-select
quietly logit stayed01 i.strata Q1xxz1_5 i.contracts assignedpreferred01 i.contracts#c.baseline_bonus i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_Q1xxz1_5
reg Q1xxz1_5 flatbonus purefranchising threshold tournament i.strata assignedpreferred01 [pweight = 1/phat_Q1xxz1_5], cluster(s1_1cii) //lasso-select
quietly logit stayed01 i.strata Q1xxz1_6 i.contracts assignedpreferred01 i.contracts#c.baseline_bonus i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_Q1xxz1_6
reg Q1xxz1_6 flatbonus purefranchising threshold tournament i.strata assignedpreferred01 [pweight = 1/phat_Q1xxz1_6], cluster(s1_1cii) //lasso-select
quietly logit stayed01 i.strata Q1xxz1_7 i.contracts assignedpreferred01 i.contracts#c.baseline_bonus i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_Q1xxz1_7
reg Q1xxz1_7 flatbonus purefranchising threshold tournament i.strata assignedpreferred01 [pweight = 1/phat_Q1xxz1_7], cluster(s1_1cii) //lasso-select


**##############################################**
**admin data evidence -- labor supply responses, dynamics?
*bring in admin data #3 - Foster MML
preserve
use "${main_loc}/survey_data_management/Admin Data Request/2nd update post trial admin data", clear 
merge m:1 icx using "${main_loc}/survey_data_management/Endline Rolling Data/_intermediate_agent_endldata.dta" 
keep if _merge==3
gen double work_starttime = clock(work_start_time, "hms")
gen double work_endtime   = clock(work_end_time, "hms")
format work_starttime work_endtime %tcHH:MM:SS
gen double work_duration = (work_endtime - work_starttime) / (1000*60*60)
br work_duration
sum work_duration  
br starting_balance ending_balance 
gen start_early = (work_starttime <= clock("08:00:00", "hms"))
gen close_late    = (work_endtime   >= clock("17:00:00", "hms"))
label define yesno 0 "No" 1 "Yes"
label values start_early yesno
label values close_late yesno
tab start_early
tab start_early, nolab
tab close_late
tab close_late, nolab 
gen openearly_closelate = (start_early == 1 & close_late == 1)
label define openearly_lbl 0 "No" 1 "Yes"
label values openearly_closelate openearly_lbl
tab openearly_closelate
tab openearly_closelate, nolab
gen date_s = date(date, "MDY")
format date_s %td
gen tag = 1
bysort icx weekno: gen days_worked = sum(tag)
bysort icx weekno (date_s): replace days_worked = days_worked[_N]

swindex work_duration days_worked openearly_closelate, gen(laboursupply)

tab dropout_status
tab dropout_status, nolab //dropout=0

**generating baseline outcomes 
generate base_workduration = work_duration if inrange(weekno, 1, 18)
gen base_startbalance = starting_balance if inrange(weekno, 1, 18)
gen base_endbalance = ending_balance if inrange(weekno, 1, 18)
gen base_inflowvalue_agent = external_inflow_value_agent if inrange(weekno, 1, 18)
gen base_inflowvolume_agent = external_inflow_vol_agent if inrange(weekno, 1, 18)
gen base_inflowvalue_other = external_inflow_val_other if inrange(weekno, 1, 18)
gen base_inflowvolume_other = external_inflow_vol_other if inrange(weekno, 1, 18)
gen base_outflowvalue_agent = external_outflow_val_agent if inrange(weekno, 1, 18)
gen base_outflowvolume_agent = external_outflow_vol_agent if inrange(weekno, 1, 18)
gen base_outflowvalue_other = external_outflow_val_other if inrange(weekno, 1, 18)
gen base_outflowvolume_other = external_outflow_vol_other if inrange(weekno, 1, 18)

*stage 0: ignore attrition
**********
*laboursupply ls? - REPORT ITT
reg work_duration flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) //during trial period
reg openearly_closelate flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii)
reg days_worked flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii)
reg laboursupply flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii)
reg work_duration flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 31, 35), cluster(s1_1cii) //after trial period - smoothing labor or habit formation?
reg openearly_closelate flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 31, 35), cluster(s1_1cii)
reg days_worked flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 31, 35), cluster(s1_1cii)
reg laboursupply flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 31, 35), cluster(s1_1cii)
**capital/liquidity?
reg starting_balance flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) 
reg ending_balance flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) 
reg laboursupply flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) 
*external inflow
reg external_inflow_value_agent flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii)
reg external_inflow_vol_agent flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) 
reg external_inflow_val_other flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) 
reg external_inflow_vol_other flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) 
*external outflow
reg external_outflow_val_agent flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) 
reg external_outflow_vol_agent flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) 
reg external_outflow_val_other flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) 
reg external_outflow_vol_other flatbonus purefranchising threshold tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) 

*stage 1: post double-lasso
**********
**laborsupply?
pdslasso laboursupply flatbonus purefranchising threshold tournament (i.strata base_workduration assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
**capital/liquidity?
pdslasso starting_balance flatbonus purefranchising threshold tournament (i.strata base_startbalance assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
pdslasso ending_balance flatbonus purefranchising threshold tournament (i.strata base_endbalance assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
*external inflow
pdslasso external_inflow_value_agent flatbonus purefranchising threshold tournament (i.strata base_inflowvalue_agent assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
pdslasso external_inflow_vol_agent flatbonus purefranchising threshold tournament (i.strata base_inflowvolume_agent assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
pdslasso external_inflow_val_other flatbonus purefranchising threshold tournament (i.strata base_inflowvalue_other assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
pdslasso external_inflow_vol_other flatbonus purefranchising threshold tournament (i.strata base_inflowvolume_other assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
*external outflow
pdslasso external_outflow_val_agent flatbonus purefranchising threshold tournament (i.strata base_outflowvalue_agent assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
pdslasso external_outflow_vol_agent flatbonus purefranchising threshold tournament (i.strata base_outflowvolume_agent assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
pdslasso external_outflow_val_other flatbonus purefranchising threshold tournament (i.strata base_outflowvalue_other assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso
pdslasso external_outflow_vol_other flatbonus purefranchising threshold tournament (i.strata base_outflowvolume_other assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store), partial(i.strata) cluster(s1_1cii) rlasso

*stage 2: tripple lasso
************
*laboursupply?
quietly logit stayed01 i.strata laboursupply i.contracts assignedpreferred01 i.contracts#c.base_workduration i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_laboursupply
reg laboursupply flatbonus purefranchising threshold tournament i.strata base_workduration assignedpreferred01 [pweight = 1/phat_laboursupply], cluster(s1_1cii) //lasso-select
reg laboursupply flatbonus purefranchising threshold tournament i.strata base_workduration [pweight = 1/phat_laboursupply], cluster(s1_1cii)
**capital/liquidity?
quietly logit stayed01 i.strata starting_balance i.contracts assignedpreferred01 i.contracts#c.base_startbalance i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_startbalance
reg starting_balance flatbonus purefranchising threshold tournament i.strata base_endbalance [pweight = 1/phat_startbalance], cluster(s1_1cii) //lasso-select
quietly logit stayed01 i.strata ending_balance i.contracts assignedpreferred01 i.contracts#c.base_endbalance i.contracts#c.assignedpreferred01 operatorandowner age_yrs female educ_postsecondary interactwmanager hhsize hhincome_annual currentschemeadequate workexperience_yrs capital_momo employees_store //full
quietly predict phat_endbalance
reg ending_balance flatbonus purefranchising threshold tournament i.strata base_endbalance assignedpreferred01 [pweight = 1/phat_startbalance], cluster(s1_1cii) //lasso-select


**ls dynamics?
*residualize laboursupply ls - REPORT ITT
reg laboursupply i.weekno i.strata if inrange(weekno, 19, 36)
predict res_laboursupply if inrange(weekno, 19, 36), residuals
gen weekno_durpost=weekno-18 if inrange(weekno, 19, 36)

lgraph res_laboursupply weekno_durpost if inrange(weekno, 19, 36) & treatment_contract=="Simple Linear" | treatment_contract=="Flat bonus/week", by(contracts) xline(12, lp(dash)) legend(on order(1 "Simple Linear" 2 "Flat bonus/week") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Residualized) Labor Supply") ytitle("Average: Labor Supply Index (Anderson 2008)" " ") xtitle("Week")
gr export "${main_loc}/_paper/results/figures/laborsupplysqflat_dynamics_admindata.eps", replace
lgraph res_laboursupply weekno_durpost if inrange(weekno, 19, 36) & treatment_contract=="Simple Linear" | treatment_contract=="Tournament", by(contracts) xline(12, lp(dash)) legend(on order(1 "Simple Linear" 2 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Residualized) Labor Supply") ytitle("Average: Labor Supply Index (Anderson 2008)" " ") xtitle("Week")
gr export "${main_loc}/_paper/results/figures/laborsupplysqtour_dynamics_admindata.eps", replace
lgraph res_laboursupply weekno_durpost if inrange(weekno, 19, 36) & treatment_contract=="Simple Linear" | treatment_contract=="Tournament" | treatment_contract=="Flat bonus/week", by(contracts) xline(12, lp(dash)) legend(on order(1 "Simple Linear"  2 "Flat bonus/week" 3 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Residualized) Labor Supply") ytitle("Average: Labor Supply Index (Anderson 2008)" " ") xtitle("Week")
gr export "${main_loc}/_paper/results/figures/laborsupplysqflattour_dynamics_admindata.eps", replace
*all graphs
lgraph res_laboursupply weekno_durpost if inrange(weekno, 19, 36), by(contracts) xline(12, lp(dash)) legend(on order(1 "Simple Linear" 2 "Flat bonus/week" 3 "Franchising" 4 "Threshold" 5 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Residualized) Labor Supply") ytitle("Average: Labor Supply Index (Anderson 2008)" " ") xtitle("Week")
lgraph res_laboursupply weekno if inrange(weekno, 19, 36), by(contracts) xline(31, lp(dash)) legend(on order(1 "Simple Linear" 2 "Flat bonus/week" 3 "Franchising" 4 "Threshold" 5 "Tournament") pos(4) col(1) size(vsmall)) graphregion(color(white)) title("(Residualized) Labor Supply") ytitle("Average: Labor Supply Index (Anderson 2008)" " ") xtitle("Week")
*all effects - ITT
reg laboursupply flatbonus purefranchising threshold c.tournament i.strata if inrange(weekno, 19, 30), cluster(s1_1cii) //during trial [clusterig matter]
reg laboursupply flatbonus purefranchising threshold c.tournament i.strata if inrange(weekno, 31, 36), cluster(s1_1cii) //after tiral - labor ss habit formation (not labor smoothing)

reg laboursupply flatbonus purefranchising threshold c.tournament i.strata if inrange(weekno, 19, 30) & dropout_status==0, cluster(s1_1cii)
reg laboursupply flatbonus purefranchising threshold c.tournament i.strata if inrange(weekno, 31, 36) & dropout_status==0, cluster(s1_1cii)
restore
**##############################################**




*3) selection into contracts?
*survey data evidence? 
*two major surv outcomes?
reg endline_corecico_revenue c.assignedpreferred01##() i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.assignedpreferred01##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.assignedpreferred01##() i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.assignedpreferred01##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)

**###############################**
*admin data evidence? 
**generally "null", some mixed 
preserve
use "${main_loc}/_paper/intermediate_data/data_treatmenteffects_main.dta", clear
*interpreting rsults: 3) selection into contracts? 
*admin data evidence? generally "null"
*implement it there too...
reg ghs_total c.assignedpreferred01##(flatbonus purefranchising threshold tournament) i.strata ghs_total_basel, cluster(s1_1cii)
reg ghs_mml c.assignedpreferred01##(flatbonus purefranchising threshold tournament) i.strata ghs_mml_basel, cluster(s1_1cii)
reg ghs_agents c.assignedpreferred01##(flatbonus purefranchising threshold tournament) i.strata ghs_agents_basel, cluster(s1_1cii)
restore
**###############################**





*4) selection on agent preference parameters?
*survey data evidence? 
*x_base=end=preference parameters?
******************************
gen riskaverse1=(NR1==1 | NR2 ==1 | NR3==1) if !missing(NR1 | NR2 | NR3)
tab QNR4
gen riskaverse2=(QNR4<=7) if !missing(QNR4) //median (relative)
gen impatient1=(NT1==1 | NT2 ==1 | NT3==1) if !missing(NT1 | NT2 | NT3)
tab QNT4
gen impatient2=(QNT4<=7) if !missing(QNT4) //median (relative)
gen volatileMarket_end=(NMR2==1 | NMR2==2) if NMR2 !=999 & !missing(NMR2)
tab CA1
gen competeaverse1=(CA1<=7) if !missing(CA1) //median (relative)
tab RE1
gen reciprocal1=(RE1>=8) if !missing(RE1) //median (relative)
tab RE2
gen reciprocal2=(RE2>=7) if !missing(RE2) //median (relative)
tab COG1xx
gen cognition_high1=(COG1xx>=6) if !missing(COG1xx) //median (relative)
tab COG2xx
gen cognition_high2=(COG1xx>=5) if !missing(COG2xx) //median (relative)


*two major surv outcomes?
reg endline_corecico_revenue c.riskaverse1##() i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.riskaverse1##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.impatient1##() i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.impatient1##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.competeaverse1##() i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.competeaverse1##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.reciprocal1##() i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.reciprocal1##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.cognition_high2##()  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.cognition_high2##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.volatileMarket_end##()  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_corecico_revenue c.volatileMarket_end##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)

reg endline_momo_income c.riskaverse1##() i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.riskaverse1##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.impatient1##() i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.impatient1##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.competeaverse1##() i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.competeaverse1##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.reciprocal1##() i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.reciprocal1##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.cognition_high2##()  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.cognition_high2##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.volatileMarket_end##()  i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg endline_momo_income c.volatileMarket_end##(flatbonus purefranchising threshold tournament)  i.strata baseline_corecico_revenue, cluster(s1_1cii)





*5a) market relationships?
*survey data evidence? 
**agent market relations?
gen agent_managerrel_improved=(NS2a==3) if !missing(NS2a)
gen agent_customerrel_improved=(NS3b==3) if !missing(NS3b)
gen agent_agentrel_improved=(NS4a==3) if !missing(NS4a)
reg agent_managerrel_improved flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg agent_customerrel_improved flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg agent_agentrel_improved flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)

*in increasing order
reg NS2a flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg NS3b flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg NS4a flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)
*in increasing order
reg NS1a flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg NS3a flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg NS4a flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)




*5b) price & nonprice changes?
*audit data evidence? 
**bring in Audit study data
*key result (positive story) - limited price & no price changes; if anything, better for non-sq schemes
********************************************************************************************************
*use "C:/Users/USER/Dropbox/contracts-w Collin/survey_data_management/Field data/Audit Daily Data/final_data_2725.dta", clear 
use "${main_loc}/survey_data_management/Field data/Audit Daily Data/final_data_2725.dta", clear

*@Beatrice - help merge w/ baseline survey to control for usual agent characteristics?

tab signature, miss
tab dropout_as_of_week8, miss

gen present01=(sb_q6==1) if !missing(sb_q6)
tab present01, miss
*keep if present01==1

tab sb_q6, miss
tab autR, miss
*br sb_q6 autR //autR missing if agent is absent
*replace autR=2 if missing(autR) & sb_q6==2 //agent marked absent after two consecutive attempts by auditor

*br typ typ_1 typ_2 typ_3 typ_4 typ_5 typ_6
rename sb_q9 sb_q9_1 //successful01 x t
rename sb_q9_ sb_q9_2
rename sb_q9_C sb_q9_3
rename sb2_q9 sb_q9_4
rename sbr2_q9_ sb_q9_5
rename sb2_q9_C sb_q9_6

*sb_q7 //1x transaction-type invariant

rename sb_q14 sb_q14_1 //discussedfees01 x t
rename sb_q14_ sb_q14_2
rename sb_q14_C ssb_q14_3
rename ssb_q14_3 sb_q14_4
rename sbr2_q14_ sb_q14_5
rename sb2_q14_C sb_q14_6

rename sb_q27 sb_q27_1 //overcharge01 x t
rename sb_q27_ sb_q27_2 
rename sb_q27_C sb_q27_3
rename sb2_q27 sb_q27_4
rename sbr2_q27_ sb_q27_5
rename sb2_q27_C sb_q27_6

rename sb_q28 sb_q28_1 //overchargeghs x t
rename sb_q28_ sb_q28_2
rename sb2_q28 sb_q28_3
rename sbr2_q28_  sb_q28_4
rename sb_q28_C sb_q28_5
rename sb2_q28_C sb_q28_6


duplicates tag id_key autR enum, gen(flag)
sort id_key autR enum deviceid
*browse if flag

duplicates tag id_key autR enum, gen(flag2)
sort id_key autR enum deviceid
*browse if flag2

reshape long sb_q9 sb_q14 sb_q27 sb_q28, i(id_key autR enum) j(typ_) string 
tab typ_ //where: _1 = co, _2=sim, _3=openacct, 1_1=ci, 2_1=otc, 2_2=airtime

*gen present01=(sb_q6==1) if !missing(sb_q6)
gen success01=(sb_q9==1) if !missing(sb_q9)
gen postedfees01=(sb_q7==1) if !missing(sb_q7)
gen discussedfees01=(sb_q14==1) if !missing(sb_q14)
gen overcharge01=(sb_q27==1) if !missing(sb_q27)
gen overchargeghs=sb_q28 if !missing(sb_q28)
	replace overchargeghs=0 if overcharge01==0
tab treatment_contract, gen(trt) //1=flat, 2=franchise, 3=simplelinear, 4=threshold, 5=tournament
gen treatment_pooled=(treatment_contract !="Simple Linear") if !missing(treatment_contract)
egen xcommunityid=group(reg_pl district_pl com_pl)
egen xagentid=group(deviceid)
egen typeXautRXenum=group(typ autR enum)
egen typeid=group(typ)

*think of these as levers/dimensions to change effort?*
*stayed - traditional analysis
gen stayed01=(dropout_as_of_week8=="No") if !missing(dropout_as_of_week8)

tab stayed01
tab present01

egen xFEs=group(typ autR)
reg overcharge01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum, cluster(xcommunityid)
reg overcharge01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum if stayed01==1, cluster(xcommunityid)
reg overcharge01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum if stayed01==0, cluster(xcommunityid)

reg overchargeghs trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum, cluster(xcommunityid)
reg overchargeghs trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum if stayed01==1, cluster(xcommunityid)
reg overchargeghs trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum if stayed01==0, cluster(xcommunityid)

reg present01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum, cluster(xcommunityid)
reg present01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum if stayed01==1, cluster(xcommunityid)
reg present01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum if stayed01==0, cluster(xcommunityid)

reg success01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum, cluster(xcommunityid)
reg success01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum if stayed01==1, cluster(xcommunityid)
reg success01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum if stayed01==0, cluster(xcommunityid)

reg discussedfees01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum, cluster(xcommunityid)
reg discussedfees01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum if stayed01==1, cluster(xcommunityid)
reg discussedfees01 trt1 trt2 trt4 trt5 i.strata i.sa_q2 i.typeid i.enum if stayed01==0, cluster(xcommunityid)



*6- overall, any regrets?
**subjectively elicited WTA: wta_ghs to rejoin same -- all agents decomposed by contracts?
*bring in data_interpretingresults (from hetero analysis above?)
***********************
use "${main_loc}/_paper/intermediate_data/data_interpretingresults.dta", clear
tab N3
gen rejoinYEs=(N3==1) if !missing(N3)
tab N4
replace N4=. if N4==99999 | N4==-99
winsor2 N4, suffix(_w) cuts(0 95)
tab N4_w

*reg rejoinYEs flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)
reg N4_w flatbonus purefranchising threshold tournament i.strata baseline_corecico_revenue, cluster(s1_1cii)

*cibar rejoinYEs, over(contracts) level(90) 
*cibar N4_w, over(contracts) level(90) 
eststo WTA_Flatbonus: mean N4_w if treatment_contract=="Flat bonus/week"
eststo WTA_Franchising: mean N4_w if treatment_contract=="Pure Franchising"
eststo WTA_Simplelinear: mean N4_w if treatment_contract=="Simple Linear"
eststo WTA_Threshold: mean N4_w if treatment_contract=="Threshold"
eststo WTA_Tournament: mean N4_w if treatment_contract=="Tournament"
coefplot WTA_Simplelinear WTA_Flatbonus WTA_Franchising WTA_Threshold WTA_Tournament, vertical xlabel("") xtitle("") ytitle("Average: Amount reported (GHS)" " ") title("Min. WTA to Rejoin Same Contract Post-Experiment") recast(bar) barwidth(0.15) fcolor(*.5) ciopts(recast(rcap)) citop citype(normal) level(90) graphregion(color(white)) legend(pos(4) col(1) size(small) region(col(white))) ylab(, nogrid)
gr export "${main_loc}/_paper/results/figures/min_wta_amount_avg.eps", replace


**tbd (changes to most preferred as agent?): what of Q1PA=q2 this too?
tab Q1PA 
tab q2

log close


/*
**try a simple labor supply model, e**
**https://law.yale.edu/sites/default/files/area/center/corporate/spring2022_paper_marinescuioana_2-17-22.pdf
**https://docs.iza.org/dp16393.pdf 
use "${main_loc}/_paper/intermediate_data/data_treatmenteffects_main.dta", clear
merge m:1 icx using "${main_loc}/_paper/intermediate_data/data_interpretingresults.dta", force gen(_merge_expervendline)

**laborsupply?
	*ssc install swindex
	swindex Q1x Q1xx Q1xxz1_1, gen(ls) //hrs.day + days.week + open.early
	sum ls if treatment_contract=="Simple Linear"
	
gen lnwage= ln(ghs_agents)
gen lnQ1x= ln(Q1x) 
gen lnQ1xx= ln(Q1xx) 

*ls Q1x Q1xx Q1xxz1_1 //hrs.day + days.week + open.early
sum ls lnQ1x lnQ1xx Q1xxz1_1 ghs_agents if treatment_contract=="Simple Linear"
*OLS
reg ls ghs_agents i.strata ghs_agents_basel, cluster(s1_1cii) //3.6%
reg Q1x ghs_agents i.strata ghs_agents_basel, cluster(s1_1cii) // dis (220/2.5)*0.0065=0.572
reg Q1xx ghs_agents i.strata ghs_agents_basel, cluster(s1_1cii) //dis (220/1.8)*0.0018=.220
reg Q1xxz1_1 ghs_agents i.strata ghs_agents_basel, cluster(s1_1cii) //1.2%
reghdfe ls ghs_agents ghs_agents_basel, absorb(strata) cluster(s1_1cii) 
reghdfe Q1x ghs_agents ghs_agents_basel, absorb(strata) cluster(s1_1cii) 
reghdfe Q1xx ghs_agents ghs_agents_basel, absorb(strata) cluster(s1_1cii) 
reghdfe Q1xxz1_1 ghs_agents ghs_agents_basel, absorb(strata) cluster(s1_1cii) 

*IV 
reg ghs_agents flatbonus purefranchising threshold tournament i.strata ghs_agents_basel, cluster(s1_1cii)
predict what, resid
reg ls what i.strata ghs_agents_basel, cluster(s1_1cii) 
reg Q1x what i.strata ghs_agents_basel, cluster(s1_1cii) 
reg Q1xx what i.strata ghs_agents_basel, cluster(s1_1cii) 
reg Q1xxz1_1 what i.strata ghs_agents_basel, cluster(s1_1cii) 
*/









