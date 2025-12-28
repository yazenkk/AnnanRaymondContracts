*summary statistics and randomization balance*
**baseline survey data**

*a) maps*
**(1) Spread of Agents Across Markets. w/ Ad Slogan: ”MTN Ev- erywhere You Go”
**(2) Spread of Managers Across Markets. w/ Ad Slogan: ”MTN Ev- erywhere You Go”

*b) summaries*
**(1) agents (n=6005 -> 6025) vs 
**(2) managers (n=456) vs 
**(3) markets (n=692)


*c) randomization - non-uniform assignments*
**markets (n=xx-z)**


*d) balance tests*
**(1) agents vs 
**(2) managers vs 
**(3) markets
**joint f-tests**



clear all
log using "C:\Users\USER\Dropbox\contracts-w Collin\_paper\results\summary_baselinebalance_draft.log", replace
*log using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/_paper/results/summary_baselinebalance_draft.log", replace

*a) maps*
****************
**(1) Spread of Agents Across Markets. w/ Ad Slogan: ”MTN Ev- erywhere You Go”
shell start "" "C:\Users\USER\Dropbox\contracts-w Collin\Reports\Baseline\Survey Maps\Agents Distribtion.png"
*shell start "" "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/Reports/Baseline/Survey Maps/Agents Distribtion.png"
**(2) Spread of Managers Across Markets. w/ Ad Slogan: ”MTN Ev- erywhere You Go”
shell start "" "C:\Users\USER\Dropbox\contracts-w Collin\Reports\Baseline\Survey Maps\Manager Distribution.png"
*shell start "" "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/Reports/Baseline/Survey Maps/Manager Distribution.png"



*b) summaries*
******************
***(i) AGENTS-baseline survey data (summaries)*** 
*************************************************
*use "C:\Users\USER\Dropbox\contracts-w Collin\survey_data_management\Field data\Agent\Agent.dta", clear 
use "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Agent/Agent.dta", clear 

*(1) demographic outcomes
tab s2_3 // Gender
sum i.s2_3, detail 

mean s0_2 if classification_of_localities == "Rural" // age	   
mean s0_2 if classification_of_localities == "Urban"  
histogram s0_2, frequency addlabel title("Agents Age Distribution")

sum i.s2_1 // education
tab s2_1 
tab s2_1 classification_of_localities, col 
 
sum i.s2_2  // marital status
tab s2_2 
tab s2_2 classification_of_localities, col 

sum s2_4 //Household size 
recode s2_4 (-4=4)
mean s2_4 if classification_of_localities == "Rural" 
mean s2_4 if classification_of_localities == "Urban" 
mmodes s2_4 // mode

tab s2_5 //Household annual income
recode s2_5 (99999=.)
recode s2_5 (9999999=.)
*gen household_income_USD = s2_5 / 15.51
format household_income_USD %12.2f 
*winsor2 household_income_USD, suffix(_wb) cuts(5 95)
sum household_income_USD_wb, detail
mean household_income_USD_wb if classification_of_localities == "Rural" 
mean household_income_USD_wb if classification_of_localities == "Urban" 

tab s8_21 //Household monthly expenses
recode s8_21 (99999=.)
*gen household_expenses_USD = s8_21 / 15.51
format household_expenses_USD %12.2f 
*winsor2 household_expenses_USD, suffix(_wb) cuts(5 95)
sum household_expenses_USD_wb, detail  
mean household_expenses_USD_wb if classification_of_localities == "Rural"
mean household_expenses_USD_wb if classification_of_localities == "Urban" 

sum s0_2 i.s2_1 i.s2_2 i.s2_3 s2_4 household_income_USD_wb household_expenses_USD_wb

*(2) preferences and compensation adequacy
tab sa_2 //On Momo commissions
*list eid s1_1cii s0_3i sa_2 if sa_2 >= 10000
recode sa_2 (99999=.)
*gen momo_commissions_USD = sa_2 / 15.51 
sum momo_commissions_USD, detail 
mean momo_commissions_USD if classification_of_localities == "Rural" 
mean momo_commissions_USD if classification_of_localities == "Urban" 

tab sa_3 // Adequacy of the current scheme 
sum i.sa_3 
tab sa_3 classification_of_localities, col 

tab q2
sum i.q2 // Agents prefered scheme 
tab q2 classification_of_localities, col 

*Baseline mml reverse revenue ranking
forvalues i = 1/5 {
    gen q2_`i'_1 = 6 - q2_`i'
}


sum q2_1_1 // mean rank of simple linear
sum q2_2_1 // mean rank for flat bonus
sum q2_3_1 // mean rank for threshold
sum q2_4_1 // mean rank for pure franchising 
sum q2_5_1 // mean rank for tournament 
mean q2_1_1 if classification_of_localities == "Rural" // rural mean for simple linear 
mean q2_1_1 if classification_of_localities == "Urban" // urban mean for simple linear 
mean q2_2_1 if classification_of_localities == "Rural" // rural mean for flat bonus
mean q2_2_1 if classification_of_localities == "Urban" // urban mean for flat bonus
mean q2_3_1 if classification_of_localities == "Rural" // rural mean for threshold
mean q2_3_1 if classification_of_localities == "Urban" // urban mean for threshold
mean q2_4_1 if classification_of_localities == "Rural" // rural mean for pure franchising 
mean q2_4_1 if classification_of_localities == "Urban" // urban mean for pure franching
mean q2_5_1 if classification_of_localities == "Rural" // rural mean for tournament 
mean q2_5_1 if classification_of_localities == "Urban" // urban mean for tournament

tab q3 // confidence in understanding the scheme and of choices made
sum i.q3 
tab q3 classification_of_localities, col 

tab q4 // Reasons for choices
sum i.q4 
tab q4 classification_of_localities, col 

 tab q7 // multi-tasking 
 sum i.q7
tab q7 classification_of_localities, col  

sum momo_commissions_USD i.sa_3 i.q2 q2_1_1 q2_2_1 q2_3_1 q2_4_1 q2_5_1 i.q3 i.q4 i.q7

*(3) Job xtics & incentives
recode s2_6(0=.)
sum s2_6, detail // years of work experience 
mean s2_6 if classification_of_localities == "Rural" 
mean s2_6 if classification_of_localities == "Urban" 

sum s2_6b, detail // months of work experience 
mean s2_6b if classification_of_localities == "Rural" 
mean s2_6b if classification_of_localities == "Urban" 

recode s2_7(0=.)
recode s2_7(-6=6)
recode s2_7(-3=3)
sum s2_7, detail // total years of work exp. in sales & retailing 
mean s2_7 if classification_of_localities == "Rural"  
mean s2_7 if classification_of_localities == "Urban" 

sum s2_7b, detail // total years of work exp. in sales & retailing 
mean s2_7b if classification_of_localities == "Rural" 
mean s2_7b if classification_of_localities == "Urban" 

sum i.s2_7x //tenure of work in particular MOMO outlet 
codebook s2_7x
*mmoodes s2_7x
tab s2_7x classification_of_localities, col

tab q8c
sum i.q8c // Frequency of communication with MML managers / supervisors  
tab q8c classification_of_localities, col 

tab q8d // last time interacted 
sum i.q8d 
tab q8d classification_of_localities, col 

tab s1_2 // Respondents relationship with the store 
sum i.s1_2 
tab s1_2 classification_of_localities, col 

tab s1_4 // familiarity wit motivating agents to work hard and bring in more sales revenue 
sum i.s1_4 
tab s1_4 classification_of_localities, col  

recode q9_1 (.=0) // monetary incentives (commissions) 
sum i.q9_1  
mean q9_1 if classification_of_localities == "Rural"  
mean q9_1 if classification_of_localities == "Urban"  

recode q9_2 (.=0) // non-monetary incentives (good working conditions) 
sum i.q9_2 
mean q9_2 if classification_of_localities == "Rural" 
mean q9_2 if classification_of_localities == "Urban" 

recode q9_3 (.=0) // non-monetary incentives (regular visitation from MML supervisors / managers) 
sum i.q9_3 
mean q9_3 if classification_of_localities == "Rural"  
mean q9_3 if classification_of_localities == "Urban" 

recode q9_4 (.=0) // non-monetary incentives (real time support) 
sum i.q9_4 
mean q9_4 if classification_of_localities == "Rural"  
mean q9_4 if classification_of_localities == "Urban"  

recode q9_5 (.=0) // non-monetary incentives (non-financial prizes) 
sum i.q9_5 
mean q9_5 if classification_of_localities == "Rural" 
mean q9_5 if classification_of_localities == "Urban"

recode q9_6 (.=0) // non-monetary incentives (flexibility in operations) 
sum i.q9_6 
mean q9_6 if classification_of_localities == "Rural"
mean q9_6 if classification_of_localities == "Urban" 

recode q9_7(.=0) // monetary & non-monetary incentives (others) 
sum i.q9_7  
mean q9_7 if classification_of_localities == "Rural" 
mean q9_7 if classification_of_localities == "Urban" 

sum i.s3_2 // retailing mobile money for other organisations 
tab s3_2 classification_of_localities, col 

sum s2_6 s2_6b s2_7 s2_7b i.s2_7x i.q8c i.q8d i.s1_2 i.s1_4 i.q9_1 i.q9_2 i.q9_3 i.q9_4 i.q9_5 i.q9_6 i.q9_7 i.s3_2

*(4) access to credit outcomes
tab s4_1 // sought to borrow money in the past 12 months 
sum i.s4_1 
tab s4_1 classification_of_localities, col 

tab s4_3 // place sought to borrow money from
sum i.s4_3 
tab s4_3 classification_of_localities, col 

tab s4_2 // success in acquiring loan 
sum i.s4_2 
tab s4_2 classification_of_localities, col 

sum s4_4 // number of times borrowed in the past 12 months 
mean s4_4 if classification_of_localities == "Rural"  
mean s4_4 if classification_of_localities == "Urban" 

tab s4_5
*gen amt_borrowed_USD = s4_5 / 15.51 // avg. amount borrowed in the last loan request 
format amt_borrowed_USD %12.2f 
*winsor2 amt_borrowed_USD, suffix(_wb) cuts(5 95)
sum amt_borrowed_USD_wb, detail 
mean amt_borrowed_USD_wb if classification_of_localities == "Rural" 
mean amt_borrowed_USD_wb if classification_of_localities == "Urban" 

tab s4_6 // credit based MoMo trnsactions 
sum i.s4_6  
tab s4_6 classification_of_localities, col 

tab s4_8
*gen MoMo_nonMoMo_credits_USD = s4_8 / 15.51 // estimate of MoMo and non-MoMo services credited 
format MoMo_nonMoMo_credits_USD %12.2f 
*winsor2 MoMo_nonMoMo_credits_USD, suffix(_wb) cuts(5 95)
sum MoMo_nonMoMo_credits_USD_wb, detail  
mean MoMo_nonMoMo_credits_USD if classification_of_localities == "Rural" 
mean MoMo_nonMoMo_credits_USD if classification_of_localities == "Urban" 

sum i.s4_1 i.s4_2 i.s4_3 s4_4 amt_borrowed_USD_wb i.s4_6 MoMo_nonMoMo_credits_USD_wb 

*(5) firm performance outcomes
tab s6_2 // Does store operate non-MoMo services?
sum i.s6_2 
tab s6_2 classification_of_localities, col 

tab s6_3
*gen MoMo_Revenues_USD = s6_3 / 15.51 // MoMo Revenues
format MoMo_Revenues_USD %12.2f 
*winsor2 MoMo_Revenues_USD, suffix(_wb) cuts(5 95) 
sum MoMo_Revenues_USD_wb, detail 
mean MoMo_Revenues_USD_wb if classification_of_localities == "Rural"  
mean MoMo_Revenues_USD_wb if classification_of_localities == "Urban" 

tab s6_4
*gen MoMo_Business_Income_USD = s6_4 / 15.51 // MoMo Business Income Earned 
format MoMo_Revenues_USD %12.2f 
*winsor2 MoMo_Business_Income_USD, suffix(_wb) cuts(5 95) 
sum MoMo_Business_Income_USD_wb, detail  
mean MoMo_Business_Income_USD_wb if classification_of_localities == "Rural" 
mean MoMo_Business_Income_USD_wb if classification_of_localities == "Urban" 

tab s6_5
recode s6_5 (0=.)
*gen nonCore_MTNMoMo_USD = s6_5 / 15.51 // Monthly total sales for non-core MTN MoMo Services
format nonCore_MTNMoMo_USD %12.2f 
*winsor2 nonCore_MTNMoMo_USD, suffix(_wb) cuts(5 95) 
sum nonCore_MTNMoMo_USD_wb, detail 
mean nonCore_MTNMoMo_USD_wb if classification_of_localities == "Rural" 
mean nonCore_MTNMoMo_USD_wb if classification_of_localities == "Urban" 

tab s6_6
recode s6_6 (0=.)
*gen sales_revenue_nonMTN_MoMo_USD = s6_6 / 15.51 // monthly sales revenues for non-MTN MobileMoney retail services
format sales_revenue_nonMTN_MoMo_USD %12.2f 
*winsor2 sales_revenue_nonMTN_MoMo_USD, suffix(_wb) cuts(5 95) 
sum sales_revenue_nonMTN_MoMo_USD_wb, detail 
mean sales_revenue_nonMTN_MoMo_USD_wb if classification_of_localities == "Rural"  
mean sales_revenue_nonMTN_MoMo_USD_wb if classification_of_localities == "Urban" 

tab s6_7
recode s6_7 (0=.)
*gen sales_rev_nonMoMo_USD = s6_7 / 15.51 // estimate of monthly sales revenues for non-MOMO business
format sales_rev_nonMoMo_USD %12.2f 
*winsor2 sales_rev_nonMoMo_USD, suffix(_wb) cuts(5 95) 
sum sales_rev_nonMoMo_USD_wb, detail 
mean sales_rev_nonMoMo_USD_wb if classification_of_localities == "Rural" 
mean sales_rev_nonMoMo_USD_wb if classification_of_localities == "Urban" 

tab s6_8
*gen non_MoMo_Bus_Income_earned = s6_8 / 15.51 // Non-MoMo Business Income earned after paying all expenses 
format non_MoMo_Bus_Income_earned %12.2f //
*winsor2 non_MoMo_Bus_Income_earned, suffix(_wb) cuts(5 95) 
sum non_MoMo_Bus_Income_earned_wb, detail 
mean non_MoMo_Bus_Income_earned_wb if classification_of_localities == "Rural"  
mean non_MoMo_Bus_Income_earned_wb if classification_of_localities == "Urban"  

sum s6_9, detail // estimated number of customers 
mean s6_9 if classification_of_localities == "Rural"  
mean s6_9 if classification_of_localities == "Urban"   

tab s6_10
*gen float_mgt_USD = s6_10 / 15.51 // float management 
format float_mgt_USD %12.2f 
*winsor2 float_mgt_USD, suffix(_wb) cuts (5 95) 
sum float_mgt_USD_wb, detail   
mean float_mgt_USD_wb if classification_of_localities == "Rural"  
mean float_mgt_USD_wb if classification_of_localities == "Urban"  

sum i.s6_2 MoMo_Revenues_USD_wb MoMo_Business_Income_USD_wb nonCore_MTNMoMo_USD_wb sales_revenue_nonMTN_MoMo_USD_wb sales_rev_nonMoMo_USD_wb non_MoMo_Bus_Income_earned_wb s6_9 float_mgt_USD_wb 

*(6) local economic env't
tab s7_1
sum i.s7_1, detail 
tab s7_1 classification_of_localities, col  

sum s7_3 // avg. number of MoMo providers in a given market 
mean s7_3 if classification_of_localities == "Rural" 
mean s7_3 if classification_of_localities == "Urban" 

sum s7_4, detail // average number of agents in a given community 
mean s7_4 if classification_of_localities == "Rural"  
mean s7_4 if classification_of_localities == "Urban"

sum i.s7_1 s7_3 s7_4

*(7) possible effort change
sum s8_1, detail // avg. number of days agent operated the shop 
mean s8_1 if classification_of_localities == "Rural" 
mean s8_1 if classification_of_localities == "Urban" 

sum s8_2, detail // avg. number of hours of operation 
mean s8_2 if classification_of_localities == "Rural" 
mean s8_2 if classification_of_localities == "Urban"  

tab s8_3 // Did business add another line of business? 
sum i.s8_3 
tab s8_3 classification_of_localities, col 

tab s8_4 // Did business relocate?
sum i.s8_4  
tab s8_4 classification_of_localities, col  

tab s8_5 // did your business activate new customers in the last 30 days?
sum i.s8_5 
tab s8_5 classification_of_localities, col 

recode s8_6 (0=.) // total number of paid workers
sum i.s8_6, detail 
mean s8_6 if classification_of_localities == "Rural" 
mean s8_6 if classification_of_localities == "Urban" 

**On total wage bill paid to workers**
recode s8_7 (0=.)
list eid s1_1cii s0_3i s8_7 if s8_7 < 100
replace s8_7 = 0 if _n == 2378
replace s8_7 = 400 if _n == 2165
replace s8_7 = 400 if _n == 2285
replace s8_7 = 300 if _n == 4100
replace s8_7 = 350 if _n == 47
replace s8_7 = 500 if _n == 80
replace s8_7 = 0 if _n == 81
replace s8_7 = 150 if _n == 5602
replace s8_7 = 1100 if _n == 1769
replace s8_7 = 450 if _n == 2426
replace s8_7 = 600 if _n == 4263
replace s8_7 = 750 if _n == 4100
replace s8_7 = 650 if _n == 4265
replace s8_7 = 700 if _n == 4258
replace s8_7 = 750 if _n == 4238
replace s8_7 = 500 if _n == 4234
replace s8_7 = . if _n == 81
replace s8_7 = . if _n == 2378
tab s8_7
*gen wage_bill_USD = s8_7 / 15.51 
format wage_bill_USD %12.2f  
sum wage_bill_USD 
mean wage_bill_USD if classification_of_localities == "Rural" 
mean wage_bill_USD if classification_of_localities == "Urban" 

tab s8_8 // total business expenses incurred 
*gen total_bus_expenses_USD = s8_8 / 15.51 
format total_bus_expenses_USD %12.2f 
*winsor2 total_bus_expenses_USD, suffix(_wb) cuts(5 95) 
sum total_bus_expenses_USD_wb, detail  
mean total_bus_expenses_USD_wb if classification_of_localities == "Rural" 
mean total_bus_expenses_USD_wb if classification_of_localities == "Urban" 

tab s8_9
*gen MoMo_capital_USD = s8_9 / 15.51 // capital for MoMo
format MoMo_capital_USD %12.2f 
*winsor2 MoMo_capital_USD, suffix(_wb) cuts(5 95) 
sum MoMo_capital_USD_wb, detail 
mean MoMo_capital_USD_wb if classification_of_localities == "Rural" 
mean MoMo_capital_USD_wb if classification_of_localities == "Urban" 


tab s8_9x
*gen total_bus_capital_USD = s8_9x / 15.51 // capital for entire business
format total_bus_capital_USD %12.2f 
*winsor2 total_bus_capital_USD, suffix(_wb) cuts(5 95) 
sum total_bus_capital_USD_wb, detail 
mean total_bus_capital_USD_wb if classification_of_localities == "Rural" 
mean total_bus_capital_USD_wb if classification_of_localities == "Urban"

tab s8_9a // price reduction of major products / services
sum i.s8_9a, detail 
tab s8_9a classification_of_localities, col 

tab s8_9b // ensured the availability of goods and services 
sum i.s8_9b 
tab s8_9b classification_of_localities, col  

tab s8_9c // ensured good work ethics
sum i.s8_9c 
tab s8_9c classification_of_localities, col 

tab s8_9d // discussed official transaction fees with customers upon arrival 
sum i.s8_9d  
tab s8_9d classification_of_localities, col 

tab s8_9e // availability of tariff sheet at store
sum i.s8_9e 
tab s8_9e classification_of_localities, col 

tab s8_9f // implemented any new / unique business practice that helped increase profit
sum i.s8_9f 
tab s8_9f classification_of_localities, col 

tab s8_12 // experienced fraud / scam 
sum i.s8_12 
tab s8_12 classification_of_localities, col

tab s8_15 // assess the profitability of business 
sum i.s8_15  
tab s8_15 classification_of_localities, col 

tab s8_16 // assess the profitability of business 
sum i.s8_16  
tab s8_16 classification_of_localities, col 

tab s8_17 // participated in any training in the past 12 months
sum i.s8_17
tab s8_17 classification_of_localities, col 

tab s8_20 // ownership of a working smart phone 
sum i.s8_20 
tab s8_20 classification_of_localities, col 

tab s8_22 // life satisfaction
sum i.s8_22 
tab s8_22 classification_of_localities, col

tab s8_23 // financial satisfaction
sum i.s8_23 
tab s8_23 classification_of_localities, col 

sum s8_24 // nearby stores that offer same services as agents stores 
mean s8_24 if classification_of_localities == "Rural" 
mean s8_24 if classification_of_localities == "Urban"  

sum s8_25 // nearby stores that do not offer same services as agents stores 
mean s8_25 if classification_of_localities == "Rural" 
mean s8_25 if classification_of_localities == "Urban" 

tab ic // intervention consent 
sum i.ic // intervention consent 
tab ic classification_of_localities, col // intervention consent 

tab icxx // intervention consent 
sum i.icxx 
tab icxx classification_of_localities, col

sum qx2 // rating MML's services on a scale of 1 - 10
mean qx2 if classification_of_localities == "Rural" 
mean qx2 if classification_of_localities == "Urban" 

sum s8_1 s8_2 i.s8_3 i.s8_4 i.s8_5 i.s8_6 wage_bill_USD total_bus_expenses_USD_wb total_bus_expenses_USD_wb MoMo_capital_USD_wb total_bus_capital_USD_wb i.s8_9a i.s8_9b i.s8_9c i.s8_9d i.s8_9e i.s8_9f i.s8_12 i.s8_15 i.s8_16 i.s8_17 i.s8_20 i.s8_22 i.s8_23 s8_24 s8_25 i.ic i.icxx qx2

**summarize all!!
**@Beatrice: bring all together and summarize!!!
*agents
sum s0_2 i.s2_1 i.s2_2 i.s2_3 s2_4 household_income_USD_wb household_expenses_USD_wb momo_commissions_USD i.sa_3 i.q2 q2_1_1 q2_2_1 q2_3_1 q2_4_1 q2_5_1 i.q3 i.q4 i.q7  s2_6 s2_6b s2_7 s2_7b i.s2_7x i.q8c i.q8d i.s1_2 i.s1_4 i.q9_1 i.q9_2 i.q9_3 i.q9_4 i.q9_5 i.q9_6 i.q9_7 i.s3_2 i.s4_1 i.s4_2 i.s4_3 s4_4 amt_borrowed_USD_wb i.s4_6 MoMo_nonMoMo_credits_USD_wb i.s6_2 MoMo_Revenues_USD_wb MoMo_Business_Income_USD_wb nonCore_MTNMoMo_USD_wb sales_revenue_nonMTN_MoMo_USD_wb sales_rev_nonMoMo_USD_wb non_MoMo_Bus_Income_earned_wb s6_9 float_mgt_USD_wb  s8_1 s8_2 i.s8_3 i.s8_4 i.s8_5 i.s8_6 wage_bill_USD total_bus_expenses_USD_wb total_bus_expenses_USD_wb MoMo_capital_USD_wb total_bus_capital_USD_wb i.s8_9a i.s8_9b i.s8_9c i.s8_9d i.s8_9e i.s8_9f i.s8_12 i.s8_15 i.s8_16 i.s8_17 i.s8_20 i.s8_22 i.s8_23 s8_24 s8_25 i.ic i.icxx qx2



***(ii) MANAGERS-baseline survey data (summaries)*** 
****************************************************
*use "C:\Users\USER\Dropbox\contracts-w Collin\survey_data_management\Field data\Manager\Manager.dta", clear 
use "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Manager/Manager.dta", clear 
tab s2_3 // gender 
sum i.s2_3 
tab s2_3 classification_of_localities, col

recode s0_2 (99=.)
sum s0_2, detail // age 
mean s0_2 if classification_of_localities == "Rural" 
mean s0_2 if classification_of_localities == "Urban" 

tab s2_1 // level f education
sum i.s2_1 
tab s2_1 classification_of_localities, col 

tab s2_2 // marital status
sum i.s2_2 
tab s2_2 classification_of_localities, col 

recode s2_4 (99=.)
sum s2_4, detail // household size 
mean s2_4 if classification_of_localities == "Rural" 
mean s2_4 if classification_of_localities == "Urban" 

tab s2_5
recode s2_5 (99999=.)
*gen manager_hsehold_income_USD = s2_5 / 15.51 // household income
format manager_hsehold_income_USD %12.2f 
*winsor2 manager_hsehold_income_USD, suffix(_wb) cuts(5 95) 
sum manager_hsehold_income_USD_wb, detail 
mean manager_hsehold_income_USD_wb if classification_of_localities == "Rural" 
mean manager_hsehold_income_USD_wb if classification_of_localities == "Urban" 

sum s2_6, detail // total years of work experience 
mean s2_6 if classification_of_localities == "Rural" 
mean s2_6 if classification_of_localities == "Urban" 

sum s2_7, detail // total years of work experience in sales and retailing 
mean s2_7 if classification_of_localities == "Rural"  
mean s2_7 if classification_of_localities == "Urban"  

sum s2_8, detail // tenure at MTN 
mean s2_8 if classification_of_localities == "Rural" 
mean s2_8 if classification_of_localities == "Urban"  

tab s3_3 // managerial bonuses linked to the performance of agents
sum i.s3_3 
tab s3_3 classification_of_localities, col 

recode s3_9 (99999=.) // number of people directly managed by manager
sum s3_9, detail 
mean s3_9 if classification_of_localities == "Rural" 
mean s3_9 if classification_of_localities == "Urban" 

tab s3_10
recode s3_10 (99999=.) // sales revenue for agents core MTN MoMo
recode s3_10 (-99=.) 
*gen sales_rev_USD = s3_10 / 15.51
format sales_rev_USD %12.2f
*winsor2 sales_rev_USD, suffix(_wb) cuts(5 95)
sum sales_rev_USD_wb, detail 
mean sales_rev_USD_wb if classification_of_localities == "Rural" 
mean sales_rev_USD_wb if classification_of_localities == "Urban" 

tab sa_3 // adequacy of the current commission structure 
sum i.sa_3  
tab sa_3 classification_of_localities, col  

tab q2 // managers most preferred incentive scheme
sum i.q2 
tab q2 classification_of_localities, col 

*Baseline mml reverse revenue ranking
forvalues i = 1/5 {
    gen q2_`i'_1 = 6 - q2_`i'
}

sum q2_1_1 // ranking of simple linear scheme 
mean q2_1_1 if classification_of_localities == "Rural" 
mean q2_1_1 if classification_of_localities == "Urban" 

sum q2_2_1 // ranking of flat bonus scheme 
mean q2_2_1 if classification_of_localities == "Rural"  
mean q2_2_1 if classification_of_localities == "Urban" 

sum q2_3_1 // ranking of threshold
mean q2_3_1 if classification_of_localities == "Rural" 
mean q2_3_1 if classification_of_localities == "Urban" 

sum q2_4_1 // ranking of pure franchising
mean q2_4_1 if classification_of_localities == "Rural" 
mean q2_4_1 if classification_of_localities == "Urban"  

sum q2_5_1 // ranking of tournament 
mean q2_5_1 if classification_of_localities == "Rural"  
mean q2_5_1 if classification_of_localities == "Urban" 

tab q3 // confidence in understanding and of choices 
sum i.q3 
tab q3 classification_of_localities, col 

tab q4 // reasons for choices 
sum i.q4 
tab q4 classification_of_localities, col 
  
tab q7 // multi-tasking 
sum i.q7 
tab q7 classification_of_localities, col 

sum i.q8c // Frequency of communication with agents 
tab q8c 
tab q8c classification_of_localities, col 

recode q9_1 (0=.)
sum q9_1 // monetary incentives that induces agents effort (Commissions)
mean q9_1 if classification_of_localities == "Rural" 
mean q9_1 if classification_of_localities == "Urban" 

recode q9_2 (0=.)
sum q9_2 // non-monetary incentives that induces agents effort (Good working conditions)
mean q9_2 if classification_of_localities == "Rural"
mean q9_2 if classification_of_localities == "Urban" 

recode q9_3 (0=.)
sum q9_3 // non-monetary incentives that induces agents effort (Regular visitations from supervisors)
mean q9_3 if classification_of_localities == "Rural" 
mean q9_3 if classification_of_localities == "Urban" 

recode q9_4 (0=.)
sum q9_4 // non-monetary incentives that induces agents effort (Getting real time support)
mean q9_4 if classification_of_localities == "Rural" 
mean q9_4 if classification_of_localities == "Urban" 

recode q9_5 (0=.)
sum q9_5 // non-monetary incentives that induces agents effort (Non-financial services)
mean q9_5 if classification_of_localities == "Rural" 
mean q9_5 if classification_of_localities == "Urban" 

recode q9_6 (0=.)
sum q9_6 // non-monetary incentives that induces agents effort (Flexibility in how agents operate their business)
mean q9_6 if classification_of_localities == "Rural" 
mean q9_6 if classification_of_localities == "Urban" 

recode q9_7 (0=.)
sum q9_7 // incentives that induces agents effort (Other)
mean q9_7 if classification_of_localities == "Rural" 
mean q9_7 if classification_of_localities == "Urban" 

tab s1_4 // familiarity with issues related to motivating agents to work hard and bring in more sales revenue 
sum i.s1_4 
tab s1_4 classification_of_localities, col  

tab s1_5 // direct involvement in the set-up of compensation scheme for retail agents 
sum i.s1_5 
tab s1_5 classification_of_localities, col  

tab s4_0_1 // retailing MoMo for other organisations 
sum i.s4_0_1 
tab s4_0_1 classification_of_localities, col 

sum s4_3 // number of providers in the community
mean s4_3 if classification_of_localities == "Rural" 
mean s4_3 if classification_of_localities == "Urban" 

recode s4_4 (-99=.) // number of agents in a given market 
sum s4_4, detail  
mean s4_4 if classification_of_localities == "Rural" 
mean s4_4 if classification_of_localities == "Urban"

tab s4_5 // would you classify your communities as a busy market for mobile money services?
sum i.s4_5 
tab s4_5 classification_of_localities, col 

sum qx2 // rating MML's services on a scale of 1 - 10
mean qx2 if classification_of_localities == "Rural" 
mean qx2 if classification_of_localities == "Urban" 

**summarize all!!
**@Beatrice: bring all together and summarize!!!
sum s2_3 s0_2 s2_1 s2_2 s2_4 manager_hsehold_income_USD_wb s2_6 s2_7 s2_8 s3_3 s3_9 sales_rev_USD_wb sa_3 q2 q2_1_1 q2_2_1 q2_3_1 q2_4_1 q2_5_1 q3 q4 q7 q8c q9_1 q9_2 q9_3 q9_4 q9_5 q9_7 s1_4 s1_5 s4_0_1 s4_3 s4_4 s4_5 qx2



***(iii) Markets (n=692)-baseline survey data (summaries)*** 
***********************************************************
**@Beatrice: you can skip this!!!




*c) randomization - non-uniform assignments*
**markets (n=692-219)**
use "C:\Users\USER\Dropbox\contracts-w Collin\survey_data_management\Field data\Agent\Agent.dta", clear 
*use "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Agent/Agent.dta", clear  //Francis
**dropping Jan/Feb 2025?
***********************
drop if mm ==1 | mm ==2 //20 momag execs
*step 1: keep only consented agents
keep if ic==1
drop if icx==99 //no wallet numbers capture though consented
*#get experimental sample (from survey sample): ar, cr, er, gar, vr, wr, br, ahafo reg, ber
tab s1_1a
tab s1_1a, nolab
keep if s1_1a==1 | s1_1a==2 | s1_1a==3 | s1_1a==4 | s1_1a==5 | s1_1a==6 | s1_1a==7 | s1_1a==14 | s1_1a==15 //n=9 regions

*step 2: randomize - gen treatments based on managerial probabilities, stratified by tsc zones
*stratify:
*layer? https://blogs.worldbank.org/en/impactevaluations/how-should-i-stratify-when-randomizing-group-level
*# get geo commercial zones (1): north {ashanti & up}, southwest {cr, wr/wnr, er-parts/kwaib/birim}, southeast {er/rest, oti, ga, volta}

tab s1_1a, nolab
tab s1_1b if s1_1a==6

gen westEastern=(s1_1b==69 | s1_1b==161) if s1_1a==6 //er splitted!

gen commercialzones="north"
*replace commercialzones ="north" if (s1_1a==1 | s1_1a==3 | s1_1a==4) //redundant!!!!
replace commercialzones ="southwest" if (s1_1a==5 | s1_1a==15 | s1_1a==16 | westEastern==1)
replace commercialzones ="southeast" if (westEastern==0 | s1_1a==7 | s1_1a==10 | s1_1a==14) 
tab commercialzones

*# get @loc-level baseline revenue bins (2) & agent density (3)
*winsor2 s6_3 s7_4, suffix(_w) cuts(5 95) //pilot
winsor2 s6_3 s7_4, suffix(_w) cuts(5 95) //full study
bys s1_1a s1_1b s1_1c: egen locality_revtot=total(s6_3_w)
bys s1_1a s1_1b s1_1c: egen locality_agentdensitytot=mean(s7_4_w) // mean of totals provided by respondents

bys s1_1a s1_1b s1_1c: keep if _n==1 //@locality level (nb: loc's avg size: ~10 agents) 

*#select 20 communities in gar for techical pilot?
set seed 019845
gen u_gar=runiform() if s1_1a==7
sort u_gar
gen techpilot_gar=(_n<=20) if !missing(u_gar)
tab techpilot_gar
tab techpilot_gar, miss

sort s1_1a s1_1b

/* 
**technical pilot work
preserve
keep if techpilot_gar ==1 //keep 20 pilot communities
*to get list of technical pilot agents?

**randomize into 5 groups for pilot?
xtile rev_bins=locality_revtot, n(3)
xtile density_bins=locality_agentdensitytot, n(2)
tab rev_bins
tab density_bins

egen strata=group(s1_1b rev_bins density_bins) //ignore stratification for pilot
tab strata
randtreat, generate(treatment) replace unequal(25/100 22.5/100 20/100 17.5/100 15/100) strata() misfits(wstrata) setseed(73492334) 
tab treatment
keep s1_1a s1_1b s1_1c treatment techpilot_gar //key to avoid duplicating constants
*merge 1:m s1_1a s1_1b s1_1c using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Agent/Agent_consented.dta"
merge 1:m s1_1a s1_1b s1_1c using "C:\Users\USER\Dropbox\contracts-w Collin\survey_data_management\Field data\Agent\Agent_consented.dta" 
keep if _merge==3
sort s1_1a s1_1b s1_1c

gen treatment_contract=""
replace treatment_contract="Simple Linear" if treatment==1
replace treatment_contract="Flat bonus/week" if treatment==4
replace treatment_contract="Threshold" if treatment==0
replace treatment_contract="Pure Franchising" if treatment==2
replace treatment_contract="Tournament" if treatment==3
tab treatment
tab treatment_contract

**get tournament groups?
bys s1_1a s1_1b s1_1c: gen _nagents=_n
egen tournamentgroups = cut(_nagents), at(1 5 9 13 17 21 25 29 33 37 41 45 49) icodes
replace tournamentgroups = tournamentgroups+1
bys s1_1a s1_1b s1_1c tournamentgroups: gen tournamentsizes=_N
tab tournamentgroups
tab tournamentsizes
tab tournamentsizes if treatment_contract=="Tournament"
*drop if tournamentsizes==1 //for all
drop if tournamentsizes==1 & treatment_contract=="Tournament" //for all

saveold "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Agent/gar_technical_pilot_consented.dta", replace
outsheet using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Agent/gar_technical_pilot_consented.xls", replace
restore
*/

**full study work
drop if techpilot_gar ==1 //drop 20 pilot communities, and keep all the rest for FULL STUDY

xtile rev_bins=locality_revtot, n(3)
xtile density_bins=locality_agentdensitytot, n(2)
tab rev_bins
tab density_bins

tabstat locality_rev, by(rev_bins) statistics(mean sd n) //across group variance large, within not that large, ok!
tabstat locality_agentdensity, by(density_bins) statistics(mean sd n)

*#define strata 
egen strata=group(commercialzones rev_bins density_bins)
tab strata //few 12 strata but strata's avg size: ~30+ localities > loc's size, so ok to do inference at loc level
*ssc install randtreat, replace
*randtreat, generate(treatment) replace unequal(30/100 25/100 20/100 15/100 10/100) strata(strata) misfits(wstrata) setseed(019845) 
*try: 25 22.5 20 17.5 15 (preserved only rank order by managers with enough sample at tails)
randtreat, generate(treatment) replace unequal(25/100 22.5/100 20/100 17.5/100 15/100) strata(strata) misfits(wstrata) setseed(183507)  //019745, 19745 // 29819745 // 183507

tab strata treatment , miss 

gen treatment_contract=""
replace treatment_contract="Simple Linear" if treatment==1
replace treatment_contract="Flat bonus/week" if treatment==4
replace treatment_contract="Threshold" if treatment==0
replace treatment_contract="Pure Franchising" if treatment==2
replace treatment_contract="Tournament" if treatment==3
tab treatment
tab treatment_contract

keep s1_1a s1_1b s1_1c strata treatment treatment_contract commercialzones //key to avoid duplicating constants [n=493-20=473 localities]
*saveold "C:\Users\USER\Desktop\IFC-MTN CICO PR\Field data (3)\Field data\Agent\fullstudy_community_assignments.dta", replace //Beatrice
*saveold "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Agent/fullstudy_community_assignments.dta", replace //Francis

*step 3: get tournament groups (n=3 or n=4) for each locality, but bring in full agent consented data again
use "C:\Users\USER\Desktop\IFC-MTN CICO PR\Field data (3)\Field data\Agent\fullstudy_community_assignments.dta", clear //Beatrice
*use "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Agent/fullstudy_community_assignments.dta", clear //Francis

*drop _merge
merge 1:m s1_1a s1_1b s1_1c using "C:\Users\USER\Desktop\IFC-MTN CICO PR\Field data (3)\Field data\Agent\Agent_consented.dta" //Beatrice
*merge 1:m s1_1a s1_1b s1_1c using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Agent/Agent_consented.dta" //Francis

sort s1_1a s1_1b s1_1c

keep if _merge==3
*bys s1_1a s1_1b s1_1c: keep if _n==1 //3397 agents, 473 localities, 64 districts, 9 regions, good!

bys s1_1a s1_1b s1_1c: gen _nx=_n
tab strata treatment if _nx==1 , miss //xx [= 473] localities


bys s1_1a s1_1b s1_1c: gen _nagents=_n
egen tournamentgroups = cut(_nagents), at(1 5 9 13 17 21 25 29 33 37 41 45 49) icodes
replace tournamentgroups = tournamentgroups+1
bys s1_1a s1_1b s1_1c tournamentgroups: gen tournamentsizes=_N
tab tournamentgroups
tab tournamentsizes
tab tournamentsizes if treatment_contract=="Tournament"
*drop if tournamentsizes==1 //for all
*drop if tournamentsizes==1 & treatment_contract=="Tournament" //for only tournament group (ss)

*saveold "C:\Users\USER\Dropbox\contracts-w Collin\survey_data_management\Main Study\fullstudy_sample.dta", replace 
*saveold "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Main Study/fullstudy_sample.dta", replace //Francis 



*d) balance tests*
********************
**(1) agents vs
**survey data evidence?
**bring in mehrged data file: fullstudy_sample
use "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Main Study/fullstudy_sample.dta", clear 

winsor2 s6_3 s6_4 s7_4 s6_5 s6_6 s6_7 s6_8 s8_7 s8_9 s8_9x s8_2 s6_9 s8_21 s8_22, suffix(_wb) cuts(5 95) 

encode treatment_contract, gen(treatment_num)
drop treatment_contract
rename treatment_num treatment_contract
gen pool_treatment = (treatment_contract != 3) if !missing(treatment_contract)

*balance: demographic outcomes (1)
reg s0_2 ib3.treatment_contract i.strata, cluster(s1_1c) // age
estimates store age
reg s2_3 ib3.treatment_contract i.strata, cluster(s1_1c) //gender 
estimates store gender
reg s2_6 ib3.treatment_contract i.strata, cluster(s1_1c) //Years of work experience
estimates store maritalstatus
reg s2_4 ib3.treatment_contract i.strata, cluster(s1_1c) //hh size
estimates store hhsize
reg s2_5 ib3.treatment_contract i.strata, cluster(s1_1c) //income
estimates store income
reg s8_21_wb ib3.treatment_contract i.strata, cluster(s1_1c) //hh expenditure 
estimates store hhexpenditure
reg s8_22_wb ib3.treatment_contract i.strata, cluster(s1_1c) // life satisfaction 
estimates store lifesatisfaction
reg s8_23 ib3.treatment_contract i.strata , cluster(s1_1c) //financial satisfaction
estimates store financialsatisfaction
*esttab age gender maritalstatus hhsize income hhexpenditure lifesatisfaction financialsatisfaction using "C:\Users\USER\Dropbox\contracts-w Collin\Completed Tasks - Beatrice\results\balance_demographics.rtf", replace keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) p(%4.3f) star title("Baseline Balance: Demographic Outcomes") label nogaps

*balance: job xtics & incentives (2)
reg s2_7 ib3.treatment_contract i.strata, cluster(s1_1c) // total years of work experience in sales and retailing 
estimates store salesyears
tab s1_2
gen sameoweneroperator=(s1_2==1) if !missing(s1_2)
reg sameoweneroperator ib3.treatment_contract i.strata, cluster(s1_1c) 
estimates store sameoweneroperator
reg q8c ib3.treatment_contract i.strata, cluster(s1_1c) //how often interact with manager
estimates store freq_interactmanager
reg q8d ib3.treatment_contract i.strata, cluster(s1_1c) // last time interacted with manager
estimates store lastime_interactmanager
reg q9_1 ib3.treatment_contract i.strata, cluster(s1_1c) // monetary incentives commissions
estimates store commissions_matter
reg q9_2 ib3.treatment_contract i.strata, cluster(s1_1c) // non-monetary good working conditions 
estimates store goodworkconditions_matter
reg q9_3 ib3.treatment_contract i.strata, cluster(s1_1c) // regular visitations 
estimates store regularmanagervisit_matter
reg q9_4 ib3.treatment_contract i.strata, cluster(s1_1c) // getting real time support when needed 
estimates store realtimesupport_matter
reg q9_5 ib3.treatment_contract i.strata, cluster(s1_1c) // non-financial prizes 
estimates store prizesrrawards_matter
reg q9_6 ib3.treatment_contract i.strata, cluster(s1_1c) // flexibility on how agents operate their business 
estimates store flexibility_matter
reg s7_3 ib3.treatment_contract i.strata, cluster(s1_1c) //number of providers
estimates store numberproviders
tab s3_2
gen retailnonmtnmomos=(s3_2==1) if !missing(s3_2)
reg retailnonmtnmomos ib3.treatment_contract i.strata, cluster(s1_1c) 
estimates store retailnonmtnmomos
reg s7_4_wb ib3.treatment_contract i.strata, cluster(s1_1c) //number of agents
estimates store numberagents_locality
*esttab salesyears sameoweneroperator freq_interactmanager lastime_interactmanager commissions_matter goodworkconditions_matter regularmanagervisit_matter using "C:\Users\USER\Dropbox\contracts-w Collin\Completed Tasks - Beatrice\results\balance_job_incentives.rtf", replace keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Job Characteristics and Incentive Preferences") label nogaps
*esttab realtimesupport_matter prizesrrawards_matter flexibility_matter numberproviders retailnonmtnmomos numberagents_locality using "C:\Users\USER\Dropbox\contracts-w Collin\Completed Tasks - Beatrice\results\balance_job_incentives.rtf", append keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Job Characteristics and Incentive Preferences (2)") label nogaps
esttab salesyears sameoweneroperator freq_interactmanager lastime_interactmanager commissions_matter goodworkconditions_matter regularmanagervisit_matter using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/Completed Tasks - Beatrice/results/balance_job_incentives.rtf", replace keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Job Characteristics and Incentive Preferences") label nogaps
esttab realtimesupport_matter prizesrrawards_matter flexibility_matter numberproviders retailnonmtnmomos numberagents_locality using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/Completed Tasks - Beatrice/results/balance_job_incentives.rtf", append keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Job Characteristics and Incentive Preferences (2)") label nogaps


*balance: firm performance outcomes (3)
reg s6_3_wb ib3.treatment_contract i.strata, cluster(s1_1c) //rev-core mtnmomo-only
estimates store rev_coremtnmomoonly
reg s6_4_wb ib3.treatment_contract i.strata, cluster(s1_1c) //profit-core mtnmomo-only
estimates store profit_coremtnmomoonly
reg s6_5_wb ib3.treatment_contract i.strata, cluster(s1_1c) //rev-noncore mtnmomo eg, aitrime
estimates store rev_noncoremtnmomo
reg s6_6_wb ib3.treatment_contract i.strata, cluster(s1_1c) //rev-nonmtn momo
estimates store rev_nonmtnmomo
reg s6_7_wb ib3.treatment_contract i.strata, cluster(s1_1c) //rev-nonfinancial services
estimates store rev_nonfinancialservices
reg s6_8_wb ib3.treatment_contract i.strata, cluster(s1_1c) //profit-business total
estimates store profit_businesstotal
replace s8_6=5 if s8_6>5
reg s8_6 ib3.treatment_contract i.strata, cluster(s1_1c)
estimates store noofpaidworkers
reg s8_7_wb ib3.treatment_contract i.strata, cluster(s1_1c) // business wagebill
estimates store businesswagebill
reg s8_9_wb ib3.treatment_contract i.strata, cluster(s1_1c) // liquidity or capital in momo businesses
estimates store liquiditymomobusinesses
reg s8_9x_wb ib3.treatment_contract i.strata, cluster(s1_1c) // capital-business total
estimates store capitalbusinesstotal
gen borrow_past12months=(s4_1==1) if s4_1 !=3
reg borrow_past12months ib3.treatment_contract i.strata, cluster(s1_1c)
estimates store borrow_past12months
reg s8_2_wb ib3.treatment_contract i.strata, cluster(s1_1c) //avg. daily hours of work
estimates store avgdailyhoursofwork
reg s6_9_wb ib3.treatment_contract i.strata, cluster(s1_1c) //number of customers last month
estimates store lastmonth_numbercustomers
*esttab rev_coremtnmomoonly profit_coremtnmomoonly rev_noncoremtnmomo rev_nonmtnmomo rev_nonfinancialservices profit_businesstotal using "C:\Users\USER\Dropbox\contracts-w Collin\Completed Tasks - Beatrice\results\balance_firmperformance.rtf", replace keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Firm Performance Outcomes") label nogaps
*esttab noofpaidworkers businesswagebill liquiditymomobusinesses capitalbusinesstotal borrow_past12months avgdailyhoursofwork lastmonth_numbercustomers using "C:\Users\USER\Dropbox\contracts-w Collin\Completed Tasks - Beatrice\results\balance_firmperformance.rtf", append keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Firm Performance Outcomes 2") label nogaps
esttab rev_coremtnmomoonly profit_coremtnmomoonly rev_noncoremtnmomo rev_nonmtnmomo rev_nonfinancialservices profit_businesstotal using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/Completed Tasks - Beatrice/results/balance_firmperformance.rtf", replace keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Firm Performance Outcomes") label nogaps
esttab noofpaidworkers businesswagebill liquiditymomobusinesses capitalbusinesstotal borrow_past12months avgdailyhoursofwork lastmonth_numbercustomers using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/Completed Tasks - Beatrice/results/balance_firmperformance.rtf", append keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Firm Performance Outcomes 2") label nogaps
 
 
preserve
**admin data evidence?
**bring in admin data**
*import delimited "C:\Users\USER\Dropbox\contracts-w Collin\survey_data_management\Admin Data Request\ISSER Agent Data - 2024.csv", clear // admin data
import delimited "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Admin Data Request/ISSER Agent Data - 2024.csv", clear // admin data

gen uniqueIDjj = substr(identifier,4,9) //extract the agent ID from Foster's
destring  uniqueIDjj, gen(icx) //icx is varname for agent ID

*merge m:m icx using "C:\Users\USER\Dropbox\contracts-w Collin\survey_data_management\Main Study\fullstudy_sample.dta", gen(_mergerandomize)
merge m:m icx using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Main Study/fullstudy_sample.dta", gen(_mergerandomize)
encode treatment_contract, gen(treatment_num)
drop treatment_contract
rename treatment_num treatment_contract

reg cash_in_volume ib3.treatment_contract i.strata, cluster(s1_1c)
estimates store cash_in_volume
reg cash_in_value ib3.treatment_contract i.strata, cluster(s1_1c)
estimates store cash_in_value
reg cash_out_volume ib3.treatment_contract i.strata, cluster(s1_1c)
estimates store cash_out_volume
reg cash_out_value ib3.treatment_contract i.strata, cluster(s1_1c)
estimates store cash_out_value
reg cashoutcommission ib3.treatment_contract i.strata, cluster(s1_1c)
estimates store cashout_commission
reg grosscashincommission ib3.treatment_contract i.strata, cluster(s1_1c)
estimates store grosscashincommission
reg netcashincommission ib3.treatment_contract i.strata, cluster(s1_1c)
estimates store netcashincommission
reg avg_daily_working_hours ib3.treatment_contract i.strata, cluster(s1_1c)
estimates store avg_daily_working_hours
*esttab cash_in_volume cash_in_value cash_out_volume cash_out_value cashout_commission grosscashincommission netcashincommission avg_daily_working_hours using "C:\Users\USER\Dropbox\contracts-w Collin\Completed Tasks - Beatrice\results\balance_adminoutcomes.rtf", replace keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Administrative Outcomes") label nogaps
esttab cash_in_volume cash_in_value cash_out_volume cash_out_value cashout_commission grosscashincommission netcashincommission avg_daily_working_hours using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/Completed Tasks - Beatrice/results/balance_adminoutcomes.rtf", replace keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Administrative Outcomes") label nogaps
restore

**(3a) markets - agents
**joint f-tests**
reg pool_treatment s0_2 s2_3 s2_6 s2_4 s2_5 s8_21 s8_22 s8_23 s2_7 sameoweneroperator q8c q8d q9_1 q9_2 q9_3 q9_4 q9_5 q9_6 s7_3 s3_2 retailnonmtnmomos s7_4_wb s6_3_wb s6_4_wb s6_5_wb s6_6_wb s6_7_wb s6_8_wb s8_6 s8_7_wb s8_9_wb s8_9x_wb borrow_past12months s8_2_wb s6_9_wb, cluster(s1_1c)
*probit pool_treatment s0_2 s2_3 s2_6 s2_4 s2_5 s8_21 s8_22 s8_23 s2_7 sameoweneroperator q8c q8d q9_1 q9_2 q9_3 q9_4 q9_5 q9_6 s7_3 s3_2 retailnonmtnmomos s7_4_wb s6_3_wb s6_4_wb s6_5_wb s6_6_wb s6_7_wb s6_8_wb s8_6 s8_7_wb s8_9_wb s8_9x_wb borrow_past12months s8_2_wb s6_9_wb, cluster(s1_1c)





**(2) managers vs 
**survey data evidence?
**bring in manager data, then merge w/ intermediate randomization file**
*use "C:\Users\USER\Dropbox\contracts-w Collin\survey_data_management\Field data\Manager\Manager.dta", clear 
*merge m:1 s1_1a s1_1b s1_1c using "C:\Users\USER\Dropbox\contracts-w Collin\survey_data_management\Field data\Agent\fullstudy_community_assignments.dta", gen(_mergecommunities)
use "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Manager/Manager.dta", clear 
merge m:1 s1_1a s1_1b s1_1c using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/survey_data_management/Field data/Agent/fullstudy_community_assignments.dta", gen(_mergecommunities)
drop if _mergecommunities==2
count //~n=456 managers
tab s1_1a //consistent with managers data

tabulate treatment_contract
encode treatment_contract, gen(treat_contract)
br treatment_contract treat_contract
drop treatment_contract
rename treat_contract treatment_contract
gen pool_treatment = (treatment_contract != 3) if !missing(treatment_contract)

*balance: demographic outcomes (1)
reg s0_2 ib3.treatment_contract i.strata, cluster(s1_1c) // age
estimates store age
reg s2_1 ib3.treatment_contract i.strata, cluster(s1_1c) //level of education 
estimates store education
reg s2_2 ib3.treatment_contract i.strata, cluster(s1_1c) //marital_status 
estimates store maritalstatus
reg s2_3 ib3.treatment_contract i.strata, cluster(s1_1c) //gender 
estimates store gender
reg s2_4 ib3.treatment_contract i.strata, cluster(s1_1c) //hhsize 
estimates store hhsize
reg s2_5 ib3.treatment_contract i.strata, cluster(s1_1c) //income
estimates store income
*esttab age education maritalstatus gender hhsize income using "C:\Users\USER\Dropbox\contracts-w Collin\Completed Tasks - Beatrice\results\balance_demographics_managers.rtf", replace keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract) b(%7.2f) p(%4.3f) star title("Baseline Balance: Demographic Outcomes") label nogaps
esttab age education maritalstatus gender hhsize income using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/Completed Tasks - Beatrice/results/balance_demographics_managers.rtf", replace keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract) b(%7.2f) p(%4.3f) star title("Baseline Balance: Demographic Outcomes") label nogaps

*balance: job xtics & incentives (2)
tab s1_2 //manaher level
tab s1_2, nolab
reg  s1_2 ib3.treatment_contract i.strata, cluster(s1_1c) 
estimates store employment_level
reg q8c ib3.treatment_contract i.strata, cluster(s1_1c) //how often interact with manager
estimates store freq_interactmanager
reg q9_1 ib3.treatment_contract i.strata, cluster(s1_1c) // monetary incentives commissions
estimates store commissions_matter
reg q9_3 ib3.treatment_contract i.strata, cluster(s1_1c) // regular visitations 
estimates store regularmanagervisit_matter
reg q9_4 ib3.treatment_contract i.strata, cluster(s1_1c) // getting real time support when needed 
estimates store realtimesupport_matter
reg q9_5 ib3.treatment_contract i.strata, cluster(s1_1c) // non-financial prizes 
estimates store prizesrrawards_matter
reg q9_6 ib3.treatment_contract i.strata, cluster(s1_1c) // flexibility on how agents operate their business 
estimates store flexibility_matter
esttab  employment_level freq_interactmanager commissions_matter regularmanagervisit_matter using "C:\Users\USER\Dropbox\contracts-w Collin\Completed Tasks - Beatrice\results\balance_job_incentives_manager.rtf", replace keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Job Characteristics and Incentive Preferences") label nogaps
*esttab realtimesupport_matter prizesrrawards_matter flexibility_matter using "C:\Users\USER\Dropbox\contracts-w Collin\Completed Tasks - Beatrice\results\balance_job_incentives_manager.rtf", append keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Job Characteristics and Incentive Preferences (2)") label nogaps
esttab realtimesupport_matter prizesrrawards_matter flexibility_matter using "/Users/fannan/Dropbox/research_Chiman_Francis/contracts-w Collin/Completed Tasks - Beatrice/results/balance_job_incentives_manager.rtf", append keep(1.treatment_contract 2.treatment_contract 4.treatment_contract 5.treatment_contract _cons) b(%7.2f) se(%7.2f) star title("Baseline Balance: Job Characteristics and Incentive Preferences (2)") label nogaps

**(3b) markets - managers
**joint f-tests**
reg pool_treatment s0_2 s2_1 s2_2 s2_3 s2_4 s2_5 s1_2 q8c q9_1 q9_3 q9_4 q9_5, cluster(s1_1c)


log close


