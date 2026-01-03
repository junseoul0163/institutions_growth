/*==============================================================================
    Project:    Institutions & Growth
    File:       01_clean_data.do
    Purpose:    Clean PWT 11.0 and Polity data & standardize country names
    Author:     Heejun Hwang
==============================================================================*/

clear all
set more off

*--- 1. SET PATH ---*
global path "/Users/heejunhwang/Documents/GitHub/institutions_growth"
cd "$path"

*--- 2. INSTALL PACKAGE (Run once, then comment out) ---*
* ssc install kountry

*-------------------------------------------------------------------------------
* 3. CLEAN POLITICAL DATA (Polity V)
*-------------------------------------------------------------------------------
display "Cleaning Polity V Data..."
import excel "data/raw/p5v2018.xls", firstrow clear

* Keep key variables
keep country year polity2

* FIX: Polity uses special codes for "Anarchy" (-77) or "Transition" (-88)
* We treat these as missing data (.) for now.
replace polity2 = . if polity2 < -10

* STANDARDIZE NAMES
rename country country_raw
kountry country_raw, from(other) stuck
rename _ISO3N_ iso_num
kountry iso_num, from(iso3n) to(iso3c)
rename _ISO3C_ iso_code

* Drop countries that didn't match
drop if iso_code == ""

* Save temp file
save "data/clean/polity_clean.dta", replace


*-------------------------------------------------------------------------------
* 4. CLEAN ECONOMIC DATA (Penn World Table 11.0)
*-------------------------------------------------------------------------------
display "Cleaning Penn World Table 11.0..."
use "data/raw/pwt110.dta", clear  // <--- UPDATED FILENAME

* PWT already has ISO codes ("countrycode").
rename countrycode iso_code

* FILTER: Update range to 2023 (PWT 11.0 goes up to 2023)
keep if year >= 1960 & year <= 2023

* KEEP KEY VARIABLES (Solow Model + TFP)
* rgdpe   = Real GDP (Expenditure side)
* pop     = Population
* emp     = Employment
* cn      = Capital Stock
* ctfp    = TFP (Productivity)
keep iso_code country year rgdpe pop emp cn ctfp

* GENERATE INTENSIVE VARIABLES (Per Capita)
gen gdp_pc = rgdpe / pop
gen capital_pc = cn / pop
gen ln_gdp_pc = log(gdp_pc)
gen ln_capital_pc = log(capital_pc)

label var ln_gdp_pc "Log Real GDP per Capita"
label var ctfp "Total Factor Productivity (TFP)"

* Save temp file
save "data/clean/pwt_clean.dta", replace

display "STEP 1 COMPLETE: PWT 11.0 and Polity Cleaned."
