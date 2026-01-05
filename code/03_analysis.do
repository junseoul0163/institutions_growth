/*==============================================================================
    Project:    Institutions & Growth
    File:       03_analysis.do
    Purpose:    Summary Stats, OLS, and Fixed Effects Regressions
    Author:     Heejun Hwang
==============================================================================*/

clear all
set more off
global path "/Users/heejunhwang/Documents/GitHub/institutions_growth"
cd "$path"

*--- 0. INSTALL TABLE MAKER (Run once) ---*
* ssc install estout

*--- 1. LOAD DATA ---*
use "data/clean/growth_panel.dta", clear

*--- 2. LESSON 8: EXPLORE VARIATION ---*
display "--------------------------------------"
display "SUMMARY STATISTICS (Panel)"
display "--------------------------------------"
xtsum ln_gdp_pc polity2

*--- 3. RUN REGRESSIONS ---*
* We use 'eststo' to store results in memory so we can make a table later.

* MODEL 1: Naive OLS (Pooled)
* "Does Democracy predict Wealth?"
eststo model_ols: reg ln_gdp_pc lag_polity ln_capital_pc, vce(cluster country_id)

* MODEL 2: Fixed Effects (The Within Estimator)
* "Does BECOMING Democratic predict Growth?"
* i.year controls for global shocks.
eststo model_fe: xtreg ln_gdp_pc lag_polity ln_capital_pc i.year, fe vce(cluster country_id)

*--- 4. EXPORT TABLE ---*
* 'esttab' is what every RA uses.
esttab model_ols model_fe using "output/table1_growth.rtf", ///
    replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    stats(N r2_a r2_o, labels("Observations" "Adj. R-Squared" "Overall R-Sq")) ///
    keep(lag_polity ln_capital_pc) ///
    coeflabels(lag_polity "Democracy (t-1)" ln_capital_pc "Capital Stock (t-1)") ///
    title("Table 1: Effect of Democracy on GDP per Capita") ///
    addnote("Note: Dependent variable is Log GDP per Capita. Std Errors clustered by country.")

display "--------------------------------------"
display "STEP 3 COMPLETE: Table 1 Saved in Output."
display "--------------------------------------"
