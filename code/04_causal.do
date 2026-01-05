/*==============================================================================
    Project:    Institutions & Growth
    File:       04_causal.do
    Purpose:    Dynamic Lags and Visualization (The J-Curve)
    Author:     Heejun Hwang
==============================================================================*/

clear all
set more off
global path "/Users/heejunhwang/Documents/GitHub/institutions_growth"
cd "$path"

*--- 0. INSTALL VISUALIZATION TOOL (Run once) ---*
* ssc install coefplot

*--- 1. LOAD DATA ---*
use "data/clean/growth_panel.dta", clear

*--- 2. THE LOOP ---*
display "Generating 10 years of lags..."
forvalues k = 1/10 {
    * Create Lag 1, Lag 2... Lag 10
    * L`k'.polity2 tells Stata to look `k` years back.
    gen lag_polity_`k' = L`k'.polity2
    
    * Label them so the graph looks nice
    label var lag_polity_`k' "Year `k'"
}

*--- 3. THE DYNAMIC REGRESSION ---*
* We want to see the timeline: 1 year later, 3 years later, 5, and 10.
eststo dynamic_model: xtreg ln_gdp_pc ///
    lag_polity_1 lag_polity_3 lag_polity_5 lag_polity_10 ///
    ln_capital_pc i.year, fe vce(cluster country_id)

*--- 4. THE VISUALIZATION ---*
* This draws the coefficients (dots) and the 95% Confidence Intervals (lines).
coefplot dynamic_model, ///
    keep(lag_polity_1 lag_polity_3 lag_polity_5 lag_polity_10) ///
    vertical ///
    yline(0, lcolor(red) lpattern(dash)) ///
    title("The Timeline of Democracy's Effect") ///
    subtitle("Does the effect become positive over time?") ///
    ytitle("% Change in GDP") ///
    xtitle("Years Since Reform") ///
    ciopts(lwidth(medium) lcolor(black)) ///
    msymbol(circle_hollow) ///
    note("Whiskers = 95% Confidence Intervals. If they touch the red line, p > 0.05.")

* Save it
graph export "output/figure1_dynamics.png", replace

display "STEP 4 COMPLETE. Check output/figure1_dynamics.png"
