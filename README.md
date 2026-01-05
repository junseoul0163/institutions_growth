# Institutions and Economic Growth: A Panel Data Analysis (1960–2023)

**Author:** Heejun Hwang  
**Institution:** Columbia University  
**Date:** January 2026

## 📌 Project Overview
This repository contains the code and data replication for a research note investigating the relationship between political institutions (democracy) and economic growth. Motivated by Acemoglu et al. (2019), this project constructs a balanced panel dataset of **160+ countries** from 1960 to 2023 to test the "Democracy Dividend" hypothesis.

Using a **Two-Way Fixed Effects (TWFE)** model to control for unobserved country heterogeneity and global shocks, I find **no statistically significant evidence** that democratization leads to an immediate or medium-term (10-year) increase in GDP per capita in this specification.

## 📂 Repository Structure
```text
institutions_growth/
├── code/
│   ├── 01_clean_data.do    # Cleans PWT and Polity data; standardizes country names (kountry)
│   ├── 02_merge.do         # Merges datasets and creates the panel structure (xtset)
│   ├── 03_analysis.do      # Generates summary stats and Table 1 (OLS vs Fixed Effects)
│   └── 04_causal.do        # Runs dynamic lag models and generates the J-Curve plot
├── data/
│   ├── raw/                # Raw inputs (PWT 11.0 and Polity V) - *Ignored by Git*
│   └── clean/              # Processed .dta files - *Ignored by Git*
├── output/
│   ├── table1_growth.rtf   # Regression results table
│   └── figure1_dynamics.png # Event study visualization
└── README.md

```

## 📊 Data Sources

The analysis relies on two primary public datasets:

1. **[Penn World Table 11.0](https://www.rug.nl/ggdc/productivity/pwt/)**: Source for Real GDP, Capital Stock, and TFP (1960–2023).
2. **[Polity V Project](http://www.systemicpeace.org/inscrdata.html)**: Source for the "Polity2" democracy score (-10 to +10).

## 🚀 How to Replicate

To run this code, you need **Stata 16 or higher**.

1. **Clone the Repository:**
```bash
git clone [https://github.com/junseoul0163/institutions_growth.git](https://github.com/junseoul0163/institutions_growth.git)

```


2. **Install Required Stata Packages:**
Open Stata and run the following once:
```stata
ssc install kountry
ssc install estout
ssc install coefplot

```


3. **Run the Master Scripts:**
* Run `01_clean_data.do` to process raw files.
* Run `02_merge.do` to build the panel.
* Run `03_analysis.do` to generate the regression table.
* Run `04_causal.do` to generate the dynamic event study plot.



## 📈 Key Findings

* **OLS vs. FE:** While a naive OLS regression suggests a strong correlation between democracy and wealth, controlling for country fixed effects renders the coefficient **insignificant** ().
* **Dynamics:** An event study looking at lags 1, 3, 5, and 10 years after a regime change shows no significant divergence from zero, suggesting that democratization alone is not a sufficient condition for short-term growth acceleration.

## 📬 Contact

For questions or feedback, please contact [Your Email] or open an issue in this repository.

```

```
