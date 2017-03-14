 *Do file for data analysis
*Hao Wang
*Apr/17/2016
**************************************

cd "D:\Dropbox\2016 Spring\POS 598 - Opinion\Paper\00Data Analysis"
clear all
import excel "D:\Dropbox\2016 Spring\POS 598 - Opinion\Paper\00Data Analysis\GDP Growth.xlsx", sheet("Sheet1") firstrow
rename GDP_growthyear_1100 GDP_Growth
destring Year, replace
sort Name Year
save GDP_Growth, replace


use GDP_Growth, clear
keep if Year > 2002 & Year <2006
by Name: egen ave_growth_3_1 = mean(GDP_Growth)
gen ave_growth_3 = ave_growth_3_1 -100
duplicates drop Name, force

use GDP_Growth, clear
keep if Year > 2000 & Year <2006
by Name: egen ave_growth_5_1 = mean(GDP_Growth)
gen ave_growth_5 = ave_growth_5_1 -100
duplicates drop Name, force

use GDP_Growth, clear
keep if Year > 1995 & Year <2006
by Name: egen ave_growth_10_1 = mean(GDP_Growth)
gen ave_growth_10 = ave_growth_10_1 -100
duplicates drop Name, force


********************************************************************************
****Merge two datasets together*************************************************
********************************************************************************
import excel "D:\Dropbox\2016 Spring\POS 598 - Opinion\Paper\00Data Analysis\Growth_survey.xlsx", sheet("Sheet1") firstrow clear
save Growth_survey, replace
use cgss2006, replace
merge m:1 province using Growth_survey, gen(_merge_growth) force
save cgss2006_merged, replace
********************************************************************************
*important (the followings are from cgss2005, now I'm using cgss2006)
*qs2a: province, -9901 missing data
*qb03b: education, missing value coded as -9901
*qb04a: party membership, 1: member; missing: -9901
*qb09d: bureaucrats class: 1: non; missing: -9901
*qb12b: income, better log it?
*qa201: gender, 1 male 2 female, missing -9901
*qa301: birth year (need to convert to age); missing -9901; reject to answer:-9902
*qb10a - qb10g: social welfare coverage, 1: yes 2: no 3: don't know missing -9901
*qe02: econ evaluation (compared to 3 years ago): 1 up 2:no change 3: down 4: hard to say -9901 missing
*qa7_01: employment condition in the last threee months: 
********************************************************************************
*baseline
use cgss2005_merged, clear
gen econ_eva =.
replace econ_eva = 3 if qe02 ==1
replace econ_eva = 2 if qe02 ==2
replace econ_eva = 1 if qe02 ==3
reg econ_eva ave_growth_5
********************************************************************************






***Analysis part***************************************************************
*edited Apr. 21
********************************************************************************
****cgss2006_merged*************************************************************
********************************************************************************
cd "D:\Dropbox\2016 Spring\POS 598 - Opinion\Paper\00Data Analysis"
clear all
use cgss2006_merged, clear
*important indicators:
*province: province
*qs3: urban: 1 rural: 2; missing -9901
gen urban =.
replace urban = 1 if qs3 ==1
replace urban = 0 if qs3 ==2
*qa01: gender: 1 male 2 female -9901 missing
gen gender =.
replace gender = 1 if qa01 ==1
replace gender = 0 if qa01 ==2
*qa03b: age
gen age = 2006 - qa03b
*qa05a: education: -9901 missing 14 missing
gen edu = .
replace edu = 1 if qa05a ==1
replace edu = 2 if qa05a ==2
replace edu = 2 if qa05a ==3
replace edu = 3 if qa05a ==4
replace edu = 4 if qa05a ==5
replace edu = 4 if qa05a ==6
replace edu = 4 if qa05a ==7
replace edu = 4 if qa05a ==8
replace edu = 5 if qa05a ==9
replace edu = 5 if qa05a ==10
replace edu = 5 if qa05a ==11
replace edu = 5 if qa05a ==12
replace edu = 5 if qa05a ==13
*qa06: foreign language ability (1-6 increasing)
gen for_language =qa06
replace for_language =. if qa06 ==-9901
*qa08a ccp membership: 1 ccp 2 other party 3 junior 4 the mass **note 
gen party = 0
replace party =1 if qa08a==1


*qb01b unemployment
gen unemployment =0
replace unemployment =1 if qb01b ==2
replace unemployment =1 if qb01b ==3
replace unemployment =1 if qb01b ==8
*company welfare benefits insurance qc27a -qc27g
gen cwelfare1 = 0
replace cwelfare1 =1 if qc27a ==1
gen cwelfare2 = 0
replace cwelfare2 =1 if qc27b ==1
gen cwelfare3 = 0
replace cwelfare3 =1 if qc27c ==1
gen cwelfare4 = 0
replace cwelfare4 =1 if qc27d ==1
gen cwelfare5 = 0
replace cwelfare5 =1 if qc27e ==1 
gen cwelfare6 = 0
replace cwelfare6 =1 if qc27f ==1
gen cwelfare7 = 0
replace cwelfare7 =1 if qc27g ==1
gen cwelfare = cwelfare1 + cwelfare2 + cwelfare3 + cwelfare4 + cwelfare5 + cwelfare6 + cwelfare7
*occupation type qb16h3 1 : party 2 company 3 shiye danwei 4 shehui tuanti 5 getihu 6,7,missing 8 refused 
gen occupation =0
replace occupation = 5 if qb16h3 ==1
replace occupation = 4 if qb16h3 ==3
replace occupation = 3 if qb16h3 ==2 
*qiye danwei
replace occupation = 2 if qb16h3 ==4 
replace occupation = 1 if qb16h3 ==5

gen occupation2 =0
replace occupation2 =1 if qb16h3 ==5
replace occupation2 =1 if qb16h3 ==4 
*改革经历
gen re_experience =0
replace re_experience =1 if qc355==0
*worker's rights during reforming era
gen re_protect =.
replace re_protect = 1 if qe20 ==5
replace re_protect = 2 if qe20 ==4
replace re_protect = 3 if qe20 ==3
replace re_protect = 4 if qe20 ==2
replace re_protect = 5 if qe20 ==1

gen re_protect_rej=0
replace re_protect_rej =1 if qe20 ==9


*unfairly treated 
gen unfairly =1
replace unfairly =0 if qe2910 ==1

gen unfairly_rej=0
replace unfairly_rej =1 if qe2911 ==1


*social welfare and insurance
gen welfare1 =0
replace welfare1 =1 if qd46a ==1
gen welfare2 =0
replace welfare2 =1 if qd46b ==1
gen welfare3 =0
replace welfare3 =1 if qd46c ==1
gen welfare4 =0
replace welfare4 =1 if qd46d ==1
gen welfare5 =0
replace welfare5 =1 if qd46e ==1
gen welfare6 =0
replace welfare6 =1 if qd46f ==1
gen welfare = welfare1 + welfare2 + welfare3 + welfare4 + welfare5 + welfare6 

*干群冲突
*qe063
gen elite_citizen =.
replace elite_citizen = 4 if qe063==1
replace elite_citizen = 3 if qe063==2
replace elite_citizen = 2 if qe063==3
replace elite_citizen = 1 if qe063==4
*refused to answer
gen elite_citizen_refuse = 0
replace elite_citizen_refuse =1 if qe063==5





********************************************************************************
*income part********************************************************************
********************************************************************************
*consider your current, is it reasonable?
*qe02
gen income_eva =.
replace income_eva =4 if qe02 ==1
replace income_eva =3 if qe02 ==2
replace income_eva =2 if qe02 ==3
replace income_eva =1 if qe02 ==4
*compare your current situation to what it was 3 years ago
gen retro_income = .
replace retro_income = 3 if qe101 ==1
replace retro_income = 2 if qe101 ==2
replace retro_income = 1 if qe101 ==3

gen retro_asset = .
replace retro_asset = 3 if qe102 ==1
replace retro_asset = 2 if qe102 ==2
replace retro_asset = 1 if qe102 ==3

gen retro_position = .
replace retro_position = 3 if qe103 ==1
replace retro_position = 2 if qe103 ==2
replace retro_position = 1 if qe103 ==3

gen retro_wkcondition =.
replace retro_wkcondition = 3 if qe104 ==1
replace retro_wkcondition = 2 if qe104 ==2
replace retro_wkcondition = 1 if qe104 ==3

gen retro_class =.
replace retro_class = 3 if qe105 ==1
replace retro_class = 2 if qe105 ==2
replace retro_class = 1 if qe105 ==3

*guess your current situation to what it might be 3 years later
gen pro_income =.
replace pro_income = 3 if qe111 ==1
replace pro_income = 2 if qe111 ==2
replace pro_income = 1 if qe111 ==3

gen pro_asset =.
replace pro_asset = 3 if qe112 ==1
replace pro_asset = 2 if qe112 ==2
replace pro_asset = 1 if qe112 ==3

gen pro_position =.
replace pro_position = 3 if qe113 ==1
replace pro_position = 2 if qe113 ==2
replace pro_position = 1 if qe113 ==3


gen pro_wkcondition =.
replace pro_wkcondition = 3 if qe114 ==1
replace pro_wkcondition = 2 if qe114 ==2
replace pro_wkcondition = 1 if qe114 ==3

gen pro_class =.
replace pro_class = 3 if qe115 ==1
replace pro_class = 2 if qe115 ==2
replace pro_class = 1 if qe115 ==3

gen pro_family_condition =.
replace pro_family_condition = 3 if qe12 ==1
replace pro_family_condition = 2 if qe12 ==2
replace pro_family_condition = 1 if qe12 ==3

*******************************************************************************
*access to media information
*******************************************************************************
*watch TV
gen TV =.
replace TV =1 if qe3801 ==7
replace TV =2 if qe3801 ==6
replace TV =3 if qe3801 ==5
replace TV =4 if qe3801 ==4
replace TV =5 if qe3801 ==3
replace TV =6 if qe3801 ==2
replace TV =7 if qe3801 ==1
*newspaper
gen newspaper =. 
replace newspaper =1 if qe3802 ==7
replace newspaper =2 if qe3802 ==6
replace newspaper =3 if qe3802 ==5
replace newspaper =4 if qe3802 ==4
replace newspaper =5 if qe3802 ==3
replace newspaper =6 if qe3802 ==2
replace newspaper =7 if qe3802 ==1
*Internet
gen internet =.
replace internet =1 if qe3803 ==7
replace internet =2 if qe3803 ==6
replace internet =3 if qe3803 ==5
replace internet =4 if qe3803 ==4
replace internet =5 if qe3803 ==3
replace internet =6 if qe3803 ==2
replace internet =7 if qe3803 ==1

********************************************************************************
*political trust in government, central media, expert and folk hearsay
********************************************************************************
gen trustgov_house =.
replace trustgov_house = 1 if qe3911 ==1
replace trustgov_house = 2 if qe3911 ==2
replace trustgov_house = 3 if qe3911 ==3
replace trustgov_house = 4 if qe3911 ==4
replace trustgov_house = 5 if qe3911 ==5

gen trustgov_stock =.
replace trustgov_stock = 1 if qe3912 ==1
replace trustgov_stock = 2 if qe3912 ==2
replace trustgov_stock = 3 if qe3912 ==3
replace trustgov_stock = 4 if qe3912 ==4
replace trustgov_stock = 5 if qe3912 ==5

gen trustgov_corruption =.
replace trustgov_corruption = 1 if qe3913 ==1
replace trustgov_corruption = 2 if qe3913 ==2
replace trustgov_corruption = 3 if qe3913 ==3
replace trustgov_corruption = 4 if qe3913 ==4
replace trustgov_corruption = 5 if qe3913 ==5

gen trustgov_ineq =.
replace trustgov_ineq =1 if qe3914 ==1
replace trustgov_ineq =2 if qe3914 ==2
replace trustgov_ineq =3 if qe3914 ==3
replace trustgov_ineq =4 if qe3914 ==4
replace trustgov_ineq =5 if qe3914 ==5

gen trustgov_employ= .
replace trustgov_employ =1 if qe3915 ==1
replace trustgov_employ =2 if qe3915 ==2
replace trustgov_employ =3 if qe3915 ==3
replace trustgov_employ =4 if qe3915 ==4
replace trustgov_employ =5 if qe3915 ==5

gen trustgov_security =. 
replace trustgov_security =1 if qe3916 ==1
replace trustgov_security =2 if qe3916 ==2
replace trustgov_security =3 if qe3916 ==3
replace trustgov_security =4 if qe3916 ==4
replace trustgov_security =5 if qe3916 ==5

gen trustgov_mine =.
replace trustgov_mine =1 if qe3917 ==1
replace trustgov_mine =2 if qe3917 ==2
replace trustgov_mine =3 if qe3917 ==3
replace trustgov_mine =4 if qe3917 ==4
replace trustgov_mine =5 if qe3917 ==5

*trus in media
********************************************************************************
gen trustmedia_house =.
replace trustmedia_house =1 if qe3921 ==1
replace trustmedia_house =2 if qe3921 ==2
replace trustmedia_house =3 if qe3921 ==3
replace trustmedia_house =4 if qe3921 ==4
replace trustmedia_house =5 if qe3921 ==5

gen trustmedia_stock =.
replace trustmedia_stock =1 if qe3922 ==1
replace trustmedia_stock =2 if qe3922 ==2
replace trustmedia_stock =3 if qe3922 ==3
replace trustmedia_stock =4 if qe3922 ==4
replace trustmedia_stock =5 if qe3922 ==5

gen trustmedia_corruption =.
replace trustmedia_corruption =1 if qe3923 ==1
replace trustmedia_corruption =2 if qe3923 ==2
replace trustmedia_corruption =3 if qe3923 ==3
replace trustmedia_corruption =4 if qe3923 ==4
replace trustmedia_corruption =5 if qe3923 ==5

gen trustmedia_ineq =.
replace trustmedia_ineq =1 if qe3924 ==1
replace trustmedia_ineq =2 if qe3924 ==2
replace trustmedia_ineq =3 if qe3924 ==3
replace trustmedia_ineq =4 if qe3924 ==4
replace trustmedia_ineq =5 if qe3924 ==5

gen trustmedia_employ=.
replace trustmedia_employ =1 if qe3925 ==1
replace trustmedia_employ =2 if qe3925 ==2
replace trustmedia_employ =3 if qe3925 ==3
replace trustmedia_employ =4 if qe3925 ==4
replace trustmedia_employ =5 if qe3925 ==5

gen trustmedia_security=.
replace trustmedia_security =1 if qe3926 ==1
replace trustmedia_security =2 if qe3926 ==2
replace trustmedia_security =3 if qe3926 ==3
replace trustmedia_security =4 if qe3926 ==4
replace trustmedia_security =5 if qe3926 ==5

gen trustmedia_mine=.
replace trustmedia_mine =1 if qe3927 ==1
replace trustmedia_mine =2 if qe3927 ==2
replace trustmedia_mine =3 if qe3927 ==3
replace trustmedia_mine =4 if qe3927 ==4
replace trustmedia_mine =5 if qe3927 ==5

gen trustmedia_earthquake =.
replace trustmedia_earthquake =1 if qe3928 ==1
replace trustmedia_earthquake =2 if qe3928 ==2
replace trustmedia_earthquake =3 if qe3928 ==3
replace trustmedia_earthquake =4 if qe3928 ==4
replace trustmedia_earthquake =5 if qe3928 ==5

*trust in expert
*******************************************************************************
gen trustexpert_house =.
replace trustexpert_house =1 if qe3931 ==1
replace trustexpert_house =2 if qe3931 ==2
replace trustexpert_house =3 if qe3931 ==3
replace trustexpert_house =4 if qe3931 ==4
replace trustexpert_house =5 if qe3931 ==5

gen trustexpert_stock =.
replace trustexpert_stock =1 if qe3932 ==1
replace trustexpert_stock =2 if qe3932 ==2
replace trustexpert_stock =3 if qe3932 ==3
replace trustexpert_stock =4 if qe3932 ==4
replace trustexpert_stock =5 if qe3932 ==5

gen trustexpert_corruption =.
replace trustexpert_corruption =1 if qe3933 ==1
replace trustexpert_corruption =2 if qe3933 ==2
replace trustexpert_corruption =3 if qe3933 ==3
replace trustexpert_corruption =4 if qe3933 ==4
replace trustexpert_corruption =5 if qe3933 ==5

gen trustexpert_ineq =.
replace trustexpert_ineq =1 if qe3934 ==1
replace trustexpert_ineq =2 if qe3934 ==2
replace trustexpert_ineq =3 if qe3934 ==3
replace trustexpert_ineq =4 if qe3934 ==4
replace trustexpert_ineq =5 if qe3934 ==5

gen trustexpert_employ =.
replace trustexpert_employ =1 if qe3935 ==1
replace trustexpert_employ =2 if qe3935 ==2
replace trustexpert_employ =3 if qe3935 ==3
replace trustexpert_employ =4 if qe3935 ==4
replace trustexpert_employ =5 if qe3935 ==5

gen trustexpert_security =.
replace trustexpert_security =1 if qe3936 ==1
replace trustexpert_security =2 if qe3936 ==2
replace trustexpert_security =3 if qe3936 ==3
replace trustexpert_security =4 if qe3936 ==4
replace trustexpert_security =5 if qe3936 ==5

gen trustexpert_mine =.
replace trustexpert_mine =1 if qe3937 ==1
replace trustexpert_mine =2 if qe3937 ==2
replace trustexpert_mine =3 if qe3937 ==3
replace trustexpert_mine =4 if qe3937 ==4
replace trustexpert_mine =5 if qe3937 ==5

gen trustexpert_earthquake =.
replace trustexpert_earthquake =1 if qe3938 ==1
replace trustexpert_earthquake =2 if qe3938 ==2
replace trustexpert_earthquake =3 if qe3938 ==3
replace trustexpert_earthquake =4 if qe3938 ==4
replace trustexpert_earthquake =5 if qe3938 ==5

*trust in legal institution
*******************************************************************************
gen trustlegal_house =.
replace trustlegal_house =1 if qe3941 ==1
replace trustlegal_house =2 if qe3941 ==2
replace trustlegal_house =3 if qe3941 ==3
replace trustlegal_house =4 if qe3941 ==4
replace trustlegal_house =5 if qe3941 ==5

gen trustlegal_stock =.
replace trustlegal_stock =1 if qe3942 ==1
replace trustlegal_stock =2 if qe3942 ==2
replace trustlegal_stock =3 if qe3942 ==3
replace trustlegal_stock =4 if qe3942 ==4
replace trustlegal_stock =5 if qe3942 ==5

gen trustlegal_corruption=.
replace trustlegal_corruption=1 if qe3943 ==1
replace trustlegal_corruption=1 if qe3943 ==2
replace trustlegal_corruption=1 if qe3943 ==3
replace trustlegal_corruption=1 if qe3943 ==4
replace trustlegal_corruption=1 if qe3943 ==5

gen trustlegal_ineq =.
replace trustlegal_ineq =1 if qe3944 ==1
replace trustlegal_ineq =2 if qe3944 ==2
replace trustlegal_ineq =3 if qe3944 ==3
replace trustlegal_ineq =4 if qe3944 ==4
replace trustlegal_ineq =5 if qe3944 ==5

gen trustlegal_employ =.
replace trustlegal_employ =1 if qe3945 ==1
replace trustlegal_employ =2 if qe3945 ==2
replace trustlegal_employ =3 if qe3945 ==3
replace trustlegal_employ =4 if qe3945 ==4
replace trustlegal_employ =5 if qe3945 ==5

gen trustlegal_security =.
replace trustlegal_security =1 if qe3946 ==1
replace trustlegal_security =2 if qe3946 ==2
replace trustlegal_security =3 if qe3946 ==3
replace trustlegal_security =4 if qe3946 ==4
replace trustlegal_security =5 if qe3946 ==5

gen trustlegal_mine =.
replace trustlegal_mine =1 if qe3947 ==1
replace trustlegal_mine =2 if qe3947 ==2
replace trustlegal_mine =3 if qe3947 ==3
replace trustlegal_mine =4 if qe3947 ==4
replace trustlegal_mine =5 if qe3947 ==5

gen trustlegal_earthquake =.
replace trustlegal_earthquake =1 if qe3948 ==1
replace trustlegal_earthquake =2 if qe3948 ==2
replace trustlegal_earthquake =3 if qe3948 ==3
replace trustlegal_earthquake =4 if qe3948 ==4
replace trustlegal_earthquake =5 if qe3948 ==5

*trust in folk hearsay
*******************************************************************************
gen trustfolk_house =.
replace trustfolk_house =1 if qe3951 ==1
replace trustfolk_house =2 if qe3951 ==2
replace trustfolk_house =3 if qe3951 ==3
replace trustfolk_house =4 if qe3951 ==4
replace trustfolk_house =5 if qe3951 ==5

gen trustfolk_stock =.
replace trustfolk_stock =1 if qe3952 ==1
replace trustfolk_stock =2 if qe3952 ==2
replace trustfolk_stock =3 if qe3952 ==3
replace trustfolk_stock =4 if qe3952 ==4
replace trustfolk_stock =5 if qe3952 ==5

gen trustfolk_corruption =.
replace trustfolk_corruption =1 if qe3953 ==1
replace trustfolk_corruption =2 if qe3953 ==2
replace trustfolk_corruption =3 if qe3953 ==3
replace trustfolk_corruption =4 if qe3953 ==4
replace trustfolk_corruption =5 if qe3953 ==5

gen trustfolk_ineq =.
replace trustfolk_ineq =1 if qe3954 ==1
replace trustfolk_ineq =2 if qe3954 ==2
replace trustfolk_ineq =3 if qe3954 ==3
replace trustfolk_ineq =4 if qe3954 ==4
replace trustfolk_ineq =5 if qe3954 ==5

gen trustfolk_employ =.
replace trustfolk_employ =1 if qe3955 ==1
replace trustfolk_employ =2 if qe3955 ==2
replace trustfolk_employ =3 if qe3955 ==3
replace trustfolk_employ =4 if qe3955 ==4
replace trustfolk_employ =5 if qe3955 ==5

gen trustfolk_security =.
replace trustfolk_security =1 if qe3956 ==1
replace trustfolk_security =2 if qe3956 ==2
replace trustfolk_security =3 if qe3956 ==3
replace trustfolk_security =4 if qe3956 ==4
replace trustfolk_security =5 if qe3956 ==5

gen trustfolk_mine =.
replace trustfolk_mine =1 if qe3957 ==1
replace trustfolk_mine =2 if qe3957 ==2
replace trustfolk_mine =3 if qe3957 ==3
replace trustfolk_mine =4 if qe3957 ==4
replace trustfolk_mine =5 if qe3957 ==5

gen trustfolk_earthquake =.
replace trustfolk_earthquake =1 if qe3958 ==1
replace trustfolk_earthquake =2 if qe3958 ==2
replace trustfolk_earthquake =3 if qe3958 ==3
replace trustfolk_earthquake =4 if qe3958 ==4
replace trustfolk_earthquake =5 if qe3958 ==5
********************************************************************************
********************************************************************************
**??political support: it is always good to support gov qe4711
gen obey =.
replace obey =1 if qe4711 ==1
replace obey =2 if qe4711 ==2
replace obey =3 if qe4711 ==3
replace obey =4 if qe4711 ==4
*laws can be effective only if gov is supporting qe4712
gen law_gov =.
replace law_gov =1 if qe4712 ==1
replace law_gov =1 if qe4712 ==1
replace law_gov =1 if qe4712 ==1
replace law_gov =1 if qe4712 ==1

*democracy is not necessary as long as economy is growing
gen dem_demand =.
replace dem_demand = 1 if qe4732 ==1
replace dem_demand = 2 if qe4732 ==2
replace dem_demand = 3 if qe4732 ==3
replace dem_demand = 4 if qe4732 ==4


*political interest: politics is so complicated that i cannot understand
gen poli_interest =.
replace poli_interest =1 if qe4731 == 4
replace poli_interest =2 if qe4731 == 3
replace poli_interest =3 if qe4731 == 2
replace poli_interest =4 if qe4731 == 1

*liefe satisfication: qe488
gen life_satis =.
replace life_satis =1 if qe488 ==4
replace life_satis =2 if qe488 ==3
replace life_satis =3 if qe488 ==2
replace life_satis =4 if qe488 ==1
********************************************************************************
drop if serial ==.
save mydata, replace





use mydata, clear
********************************************************************************
*now it's the regression part
*contruct latent DV
*latent: trust in government 
egen trustgov_overall = rmean(trustgov_house trustgov_stock trustgov_corruption trustgov_ineq trustgov_employ trustgov_security trustgov_mine)
drop if serial ==.



dem_demand
trustgov
retro_econ
pro_econ
cri_gov law_gov poli_interest
mixed trustgov rich_poor ave_growth_10 ave_growth_5 ave_growth_3 urban gender edu age income for_language party ||province:
outreg2 using table1, excel replace title(Table 1 Modernization Hypotheses Tests)
mixed trustgov rich_poor cri_gov law_gov poli_interest ave_growth_10 ave_growth_5 ave_growth_3 urban gender edu age income for_language party ||province:
outreg2 using table1, excel append
mixed trustgov cri_gov law_gov poli_interest ave_growth_10 ave_growth_5 ave_growth_3 urban gender edu age income for_language party ||province:
outreg2 using table1, excel append
mixed dem_demand rich_poor ave_growth_10 ave_growth_5 ave_growth_3 urban gender edu age income for_language party ||province:
outreg2 using table1, excel append
mixed dem_demand rich_poor cri_gov law_gov poli_interest ave_growth_10 ave_growth_5 ave_growth_3 urban gender edu age income for_language party ||province:
outreg2 using table1, excel append
mixed dem_demand cri_gov law_gov poli_interest ave_growth_10 ave_growth_5 ave_growth_3 urban gender edu age income for_language party ||province:
outreg2 using table1, excel append



mixed trustgov retro_econ  urban gender edu age income for_language party ||province:
outreg2 using table2, excel replace title(Table2 Self-Evaluation Tests)
mixed trustgov pro_econ urban gender edu age income for_language party ||province:
outreg2 using table2, excel append
mixed trustgov pro_econ retro_econ rich_poor cri_gov law_gov poli_interest urban gender edu age income for_language party ||province:
outreg2 using table2, excel append
mixed dem_demand retro_econ  urban gender edu age income for_language party ||province:
outreg2 using table2, excel append
mixed dem_demand pro_econ urban gender edu age income for_language party ||province:
outreg2 using table2, excel append
mixed dem_demand pro_econ retro_econ rich_poor cri_gov law_gov poli_interest urban gender edu age income for_language party ||province:
outreg2 using table2, excel append

gen TV_cri= TV * cri_gov
gen newspaper_cri=newspaper * cri_gov

mixed trustgov rich_poor cri_gov TV newspaper law_gov poli_interest urban gender edu age income for_language party ||province:
outreg2 using table3, excel replace title(Table3 Self-Evaluation Tests)
mixed trustgov rich_poor cri_gov TV TV_cri newspaper newspaper_cri  law_gov poli_interest urban gender edu age income for_language party ||province:
outreg2 using table3, excel append
mixed dem_demand rich_poor cri_gov TV newspaper law_gov poli_interest urban gender edu age income for_language party ||province:
outreg2 using table3, excel append
mixed dem_demand rich_poor cri_gov TV TV_cri newspaper newspaper_cri law_gov poli_interest urban gender edu age income for_language party ||province:
outreg2 using table3, excel append





. gsem (Trust_gov -> trustgov_house, ) (Trust_gov -> trustgov_stock, ) (Trust_gov -> trustgov_corruption, ) (Trust_gov -> trustgov_ineq, ) (Trust_gov -> trustgov_employ, ) ///
(Trust_gov -> trustgov_security, ) (Trust_gov -> trustgov_mine, ) (retro_eco -> Trust_gov, ) (ret
> ro_eco -> retro_income, ) (retro_eco -> retro_asset, ) (retro_eco -> retro_position, ) (r
> etro_eco -> retro_wkcondition, ) (retro_eco -> retro_class, ) (pro_econ -> Trust_gov, ) (
> pro_econ -> pro_income, ) (pro_econ -> pro_asset, ) (pro_econ -> pro_position, ) (pro_eco
> n -> pro_wkcondition, ) (pro_econ -> pro_class, ) (pro_econ -> pro_family_condition, ) (p
> arty -> Trust_gov, ) (gender -> Trust_gov, ) (life_satis -> Trust_gov, ) (M1[province] ->
>  party, family(bernoulli) link(logit)) (M1[province] -> gender, family(bernoulli) link(lo
> git)) (M1[province] -> life_satis, family(ordinal) link(logit)) (M1[province] -> ave_grow
> th_3, ) (M1[province] -> ave_growth_5, ) (M1[province] -> ave_growth_10, ) [pweight = wei
> ght], covstruct(_lexogenous, diagonal) latent(Trust_gov retro_eco pro_econ M1 ) cov( retr
> o_eco*pro_econ) nocapslatent





















