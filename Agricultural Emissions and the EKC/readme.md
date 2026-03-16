# 🌍 Macro-Econometric Analysis of the Environmental Kuznets Curve (EKC): BRICS vs. OECD

![Python](https://img.shields.io/badge/Python-3.8%2B-blue)
![Pandas](https://img.shields.io/badge/Pandas-Data_Manipulation-150458)
![Statsmodels](https://img.shields.io/badge/Statsmodels-Econometrics-green)
![Seaborn](https://img.shields.io/badge/Seaborn-Data_Visualization-lightgrey)

## 📌 Executive Summary
This project investigates the **Environmental Kuznets Curve (EKC)** hypothesis within the agricultural sector, analyzing the relationship between economic growth (GDP per capita) and greenhouse gas emissions ($CO_2$, $CH_4$, $N_2O$). Utilizing **Panel Data regression with Fixed Effects**, the study compares the structural emission trajectories of **BRICS** (emerging) and **OECD** (developed) economies. 

The empirical findings confirm the EKC inverted-U shape primarily for $CO_2$ emissions in BRICS nations, while OECD countries exhibit a flattening trajectory due to reduced GDP variance at higher income levels.

## 📊 Key Economic Findings
1. **Validation of the EKC for $CO_2$:** The global panel regression confirms a statistically significant quadratic relationship ($\beta_1 > 0$, $\beta_2 < 0$) for $CO_2$ emissions, proving that the rate of emission acceleration decelerates as income rises.
2. **Structural Divergence (BRICS vs. OECD):**
   * **BRICS:** Strongly drive the quadratic EKC trend. These economies are currently in the *Ascending Phase* (Scale Effect), where rapid GDP growth is heavily correlated with rising agricultural emissions, though the rate is mathematically starting to bend.
   * **OECD:** The EKC hypothesis is rejected for the OECD sub-sample. This is econometrically attributed to a lack of variance in their high-income GDP. These nations have reached the *Deceleration Phase* (Technique Effect), clustering near the flattened peak of the macroscopic curve.

## 🛠 Methodology & Tech Stack
* **Econometric Modeling:** Fixed Effects Panel Regression (LSDV approach) with clustered standard errors to account for unobserved, time-invariant heterogeneity across countries.
* **Control Variables:** Agricultural Value Added (%), Cereal Yield, and Agricultural Land Area.
* **Data Processing:** Robust filtering of zero/negative values, logarithmic transformations, and outlier handling.
* **Libraries Used:** `pandas`, `numpy`, `statsmodels.formula.api`, `matplotlib`, `seaborn`.

## 📈 Visualizing the Trend
The project includes advanced data visualizations that map the raw, cross-sectional data points onto the calculated quadratic regression trends. *Anchor scaling* was used to accurately position empirical data against the theoretical macroeconomic EKC path.

*(Optional: Add a screenshot of your final BRICS vs OECD dual-graph here by dragging and dropping the image into the GitHub editor)*

## 🚀 How to Run the Code
1. Clone the repository:
   ```bash
   git clone [https://github.com/yourusername/EKC-Macro-Analysis.git](https://github.com/yourusername/EKC-Macro-Analysis.git)
2. INstall required dependencies:
pip install pandas numpy statsmodels matplotlib seaborn openpyxl
3. Run the primary analysis script:
python ekc_regression_analysis.py
