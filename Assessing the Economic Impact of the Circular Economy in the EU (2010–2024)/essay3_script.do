
use "df6.dta", clear  
rename v1 metadata
gen country = substr(metadata, -2, 2)

foreach var of varlist v* {
    replace `var' = ustrregexra(`var', "[^0-9.]", "")
    replace `var' = "" if `var' == "."
}

destring v*, replace

destring v*, replace ignore("ib ") 

reshape long v, i(country) j(year_idx)

gen year = year_idx + 1998

gen year = year_idx + 2002 

keep if year >= 2010 & year <= 2024
rename v [название_переменной] 

drop if strpos(metadata, "EA19") > 0
drop if strpos(metadata, "EU27") > 0
drop if strpos(metadata, "EA21") > 0
drop if _n <= 15
drop metadata

save "clean_df6.dta", replace 


duplicates report country
duplicates list country
bysort country: keep if _n == 1

* merging datasets in 1

use "clean_df3.dta", clear

merge 1:1 country year using "clean_df2.dta", nogenerate

merge 1:1 country year using "clean_df1.dta", nogenerate

merge 1:1 country year using "clean_df4.dta", nogenerate

merge 1:1 country year using "clean_df5.dta", nogenerate

merge 1:1 country year using "clean_df6.dta", nogenerate

drop if missing(GDPpc) | missing(CMU)

encode country, gen(id)

xtset id year
save "final_circular_economy_dataset.dta", replace
summarize

* regression 
gen ln_gdp = ln(GDPpc)
gen ln_co2 = ln(CO2)

* 2. main regression (Fixed Effects)
xtreg ln_gdp CMU ln_co2 Inv P_MHAB import_dep, fe

*graphs 

*graph 1
twoway (scatter ln_gdp CMU, mcolor(blue%30) msize(small)) ///
       (lfit ln_gdp CMU, lcolor(red) lwidth(medthick)), ///
       title("Correlation: Circularity vs. Economic Wealth", size(medium)) ///
       xtitle("Circular Material Use Rate (%)") ///
       ytitle("ln(GDP per capita)") ///
       note("Source: Eurostat Data (2010-2024). Red line indicates the positive linear trend.") ///
       legend(label(1 "Observations") label(2 "Linear Fit")) ///
       graphregion(color(white))
	   
*graph 2

preserve
collapse (mean) CMU Inv, by(year)

twoway (line CMU year, lcolor(green) lwidth(thick) yaxis(1)) ///
       (line Inv year, lcolor(orange) lwidth(thick) yaxis(2)), ///
       title("Evolution of Circular Economy in EU (Average Trends)", size(medium)) ///
       xtitle("Year") ///
       ytitle("Average CMU Rate (%)", axis(1)) ///
       ytitle("Average Private Investment (% of GDP)", axis(2)) ///
       legend(label(1 "Circularity (CMU)") label(2 "Investment Intensity")) ///
       graphregion(color(white))
restore

*graph 3
twoway (scatter ln_gdp Inv, mcolor(orange%40)) ///
       (lfit ln_gdp Inv, lcolor(black)), ///
       title("GDP Growth driven by Circular Investments", size(medium)) ///
       xtitle("Private Investment in Circular Economy (% GDP)") ///
       ytitle("ln(GDP per capita)") ///
       graphregion(color(white))
