Assessing the Economic Impact of the Circular Economy in the EU (2010–2024)
📊 Project Overview
This project provides an empirical analysis of how circular economy transitions influence economic growth across European Union member states. Using a Fixed-Effects (FE) Panel Regression model, we examine the relationship between resource productivity (Circular Material Use), private investments, and GDP per capita.

🔍 Key Findings
Circularity is a Growth Driver: A 1 percentage point increase in the Circular Material Use (CMU) rate correlates with a 0.85% increase in GDP per capita (p<0.01).

Investment Efficiency: Private investments in circular sectors are highly productive, with a coefficient of 0.11 (p<0.01).

Decoupling Evidence: The model shows a lack of statistical significance for CO2 emissions, suggesting a structural decoupling where EU economic growth is becoming less dependent on carbon output.

🛠 Data Pipeline & Methodology
The study utilizes six distinct datasets sourced from Eurostat (2026 pull):

df1 (CO2): Carbon emissions (Environmental control).

df2 (CMU): Circular material use rate (Main Independent Variable).

df3 (GDPpc): Real GDP per capita (Dependent Variable).

df4 (Inv): Private investments in circular economy (% of GDP).

df5 (Patents): Green patents per million inhabitants (Innovation proxy).

df6 (Imp_dep): Material import dependency (Strategic control).

Data Cleaning Process (Stata):
Format Conversion: Handled complex TSV-to-Stata conversions, resolving "ambiguous abbreviation" errors and string-to-numeric formatting.

Header Purging: Identified and removed technical artifacts (e.g., 'OD' identifiers and header-row contamination).

Deduplication: Filtered out supra-national aggregates (EU-27, EA-19) to maintain a strictly sovereign-level panel.

Normalization: Applied logarithmic transformations (ln) to GDP and CO2 to interpret results as elasticities.

💻 Stata Implementation
The analysis was performed using the following econometric framework:
* Panel Setup
encode country, gen(id)
xtset id year

* Main Regression Model
xtreg ln_gdp CMU ln_co2 Inv P_MHAB import_dep, fe

📈 Visualizations
The repository includes:

Circularity vs. Wealth Scatter: Visual proof of the positive correlation between recycling rates and national income.

Temporal Trends (2010–2024): Comparison of the steady rise in CMU rates versus the cyclical nature of private investments.

📁 Repository Structure
/data_raw/: Original Eurostat files.

/data_clean/: Processed .dta files after cleaning.

/scripts/: Stata .do files containing the full cleaning and regression logic.

/results/: Regression output tables and generated graphs.

🎓 Author
Mardan Kydyrbek Project completed as part of Economic Growth and Sustainable Development course, Liège, 2026.
