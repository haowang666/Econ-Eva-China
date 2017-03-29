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

























