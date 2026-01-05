/*==============================================================================
    Project:    Institutions & Growth
    File:       02_merge.do
    Purpose:    Merge Economic (PWT) and Political (Polity) data
    Author:     Heejun Hwang
==============================================================================*/

clear all
set more off
global path "/Users/heejunhwang/Documents/GitHub/institutions_growth"
cd "$path"

*--- 1. LOAD THE MASTER DATA (Economics) ---*
use "data/clean/pwt_clean.dta", clear

*--- 2. MERGE WITH POLITICAL DATA ---*
merge 1:1 iso_code year using "data/clean/polity_clean.dta"

*--- 3. ANALYZE THE MERGE ---*
tab _merge

* DECISION: We only want to analyze countries where we have BOTH econ and politics.
keep if _merge == 3
drop _merge

*--- 4. DECLARE PANEL STRUCTURE ---*
* 'encode' creates a numeric ID from the string ISO code.
encode iso_code, gen(country_id)
xtset country_id year

*--- 5. CREATE LAGS (The Time Machine) ---*
* L.polity2 = "Democracy Score in the previous year"
gen lag_polity = L.polity2
gen lag_gdp_pc = L.ln_gdp_pc

label var lag_polity "Democracy Score (t-1)"
label var lag_gdp_pc "Log GDP per Capita (t-1)"

*--- 6. SAVE FINAL PANEL ---*
save "data/clean/growth_panel.dta", replace

display "---------------------------------------------------"
display "STEP 2 COMPLETE: Panel Merged and Saved."
display "---------------------------------------------------"
