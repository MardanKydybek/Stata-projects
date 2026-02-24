********************************************************************************
* RESEARCH TOPIC: Impact of Population Aging on CO2 Emissions Per Capita
* DATA SOURCES: World Bank (WDI) & Our World in Data (Global Carbon Budget)
* ANALYST: [Your Name]
********************************************************************************

// STEP 1: DATA CLEANING - POPULATION AGING //

* Import World Bank CSV (Data typically starts from row 5)
import delimited "aging.csv", rowrange(5) clear

* Rename initial columns for clarity
* v1: Country Name, v2: Country Code
rename v1 country_name
rename v2 country_code

* Remove unnecessary indicator metadata
drop v3 v4

* Reshape data from Wide to Long format
* v5 corresponds to 1960, v6 to 1961, and so on
reshape long v, i(country_code) j(year_index)

* Convert the column index into actual calendar years
* Since v5 is the 1960 observation:
gen year = 1960 + (year_index - 5)

* Rename the main variable
rename v aging

* Keep relevant variables and save as a Stata dataset
keep country_name country_code year aging
save "aging_cleaned.dta", replace

// NOTE: The same procedure above was applied to GDP and Urban Population files //


// STEP 2: DATA CLEANING - CO2 EMISSIONS //

* Import the CO2 emissions per capita file (Long format)
import delimited "co2-emissions-per-capita.csv", clear
rename entity country_name
rename code country_code
rename year year
rename coemissionspercapita co2_pc

* Save initial clean version
save "co2_cleaned.dta", replace


// STEP 3: DATA MERGING & FINAL PREPARATION //

use "co2_cleaned.dta", clear

* Check for duplicate observations to ensure data integrity
duplicates report country_code year

* Remove observations without a valid ISO country code (e.g., specific regions)
drop if country_code == ""

* Drop any remaining duplicates to ensure a unique 1:1 match
duplicates drop country_code year, force
save "co2_cleaned.dta", replace

* Merge Population Aging data
merge 1:1 country_code year using "aging_cleaned.dta"
drop if _merge == 2 // Drop observations present only in the using file
drop _merge

* Merge GDP per capita data
merge 1:1 country_code year using "gdp_cleaned.dta"
drop if _merge == 2
drop _merge

* Merge Urbanization data
merge 1:1 country_code year using "urban_cleaned.dta"
drop if _merge == 2
drop _merge

* Restrict the sample to the target period (1990-2024)
keep if year >= 1990 & year <= 2024
drop if country_code == "" 

* Save the final merged master dataset
save "final_dataset.dta", replace


// STEP 4: VARIABLE TRANSFORMATION & ANALYSIS //

* Generate natural logarithms for regression coefficients (elasticity analysis)
gen ln_co2 = ln(co2_pc)
gen ln_gdp = ln(gdp)

* Generate Descriptive Statistics for the Variables Discussion section
summarize co2_pc aging gdp urban

* Define the Panel Data Structure
* Convert the string country code into a numeric ID for xtset
encode country_code, gen(country_id)

* Declare the dataset as a panel (ID: country, Time: year)
xtset country_id year

* Execute the Fixed-Effects (FE) Regression
xtreg ln_co2 aging ln_gdp urban, fe

//step 5: plotting some graphs//

*graph A: general correlation  (scatter plot with trend line)

twoway (scatter ln_co2 aging, msize(tiny) mcolor(blue%30)) ///
       (lfit ln_co2 aging, lcolor(red)), ///
       title("Relationship between Population Aging and CO2 per capita") ///
       xtitle("Population aged 65+ (% of total)") ///
       ytitle("Log of CO2 emissions per capita") ///
       legend(order(1 "Observations" 2 "Fitted Trend"))
graph export "scatter_main.png", replace

* graph B: time dynamics for key countries

twoway (line ln_co2 year if country_code == "JPN", lcolor(blue)) ///
       (line ln_co2 year if country_code == "DEU", lcolor(green)) ///
       (line ln_co2 year if country_code == "USA", lcolor(red)) ///
       (line ln_co2 year if country_code == "CHN", lcolor(orange)) ///
       (line ln_co2 year if country_code == "AUS", lcolor(cyan)) ///
       (line ln_co2 year if country_code == "KOR", lcolor(magenta)) ///
       (line ln_co2 year if country_code == "GBR", lcolor(purple)) ///
       (line ln_co2 year if country_code == "MEX", lcolor(brown)), ///
       title("CO2 Emission Trends in Diverse Economies (1990-2024)") ///
       xtitle("Year") ytitle("ln(CO2 per capita)") ///
       legend(label(1 "Japan") label(2 "Germany") label(3 "USA") ///
              label(4 "China") label(5 "Australia") label(6 "S. Korea") ///
              label(7 "UK") label(8 "Mexico") size(vsmall) cols(2))
graph export "line_trends_updated.png", replace

* time and country fixed effects regression
xtreg ln_co2 aging ln_gdp urban, fe vce(robust)

import excel "Median age.xlsx", sheet("Estimates") cellrange(A17:AZ22000) firstrow clear

* 1. Оставляем только необходимые колонки
keep Regionsubregioncountryorar ISO3Alphacode Year MedianAgeasof1Julyyears Type

* 2. Фильтруем: оставляем только страны (убираем регионы и "World")
keep if Type == "Country/Area"

* 3. Переименовываем переменные, чтобы они совпадали с главным датасетом
rename ISO3Alphacode country_code
rename Year year
rename MedianAgeasof1Julyyears median_age

keep country_code year median_age Type 

* 4. Ограничиваем временной период (как в твоем основном анализе)
keep if year >= 1990 & year <= 2024

* 5. Убеждаемся, что данные числовые (на всякий случай)
destring year median_age, replace

save "median_age_final.dta", replace

//merging to our main dta//
use "final_dataset.dta", clear
merge 1:1 country_code year using "median_age_final.dta"

* Проверяем корреляцию (то, что просил проф)
pwcorr aging median_age, sig

* regression with median age
xtreg ln_co2 median_age ln_gdp urban i.year, fe vce(robust)

save "final_dataset.dta", replace

* tables comparative
* Модель 1: Основная (Aging 65+)
xtreg ln_co2 aging ln_gdp urban i.year, fe vce(robust)
estimates store model1

* Модель 2: С медианным возрастом
xtreg ln_co2 median_age ln_gdp urban i.year, fe vce(robust)
estimates store model2

estimates table model1 model2, b(%9.4f) p se stats(N r2_w)
********************************************************************************
* END OF SCRIPT
********************************************************************************
