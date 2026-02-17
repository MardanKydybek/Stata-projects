*empirical project*


/// Step 1. preparing dataset////
use "gravity_V202211.dta", clear

*preparing country files - exporters
use "countries_V202211.dta", clear
describe 		// to look more clearly

*renaming iso3, country variables*
rename iso3 iso3_o
rename country country_o
save "countries_exporter.dta", replace
duplicates drop iso3_o, force   	// dropping the duplicates
save "countries_exporter.dta", replace  		// saving file	

*Merge gravity + exporter countries*
use "gravity_V202211.dta", clear
merge m:1 iso3_o using "countries_exporter.dta"

*let's do the same for imports, iso3_d*
use "countries_V202211.dta", clear
rename iso3 iso3_d
rename country country_d
duplicates drop iso3_d, force
save "countries_importer.dta", replace
*merging*
use "gravity_V202211.dta", clear
merge m:1 iso3_d using "countries_importer.dta"

save "gravity_V202211_merged.dta", replace


///Step 2. filtering East-European countries///
use "gravity_V202211_merged.dta", clear 

*list of East European countries*
keep if country_o=="Poland" | country_o=="Czech Republic" | country_o=="Slovakia" | country_o=="Slovenia" | country_o=="Hungary" | country_o=="Estonia" | country_o=="Latvia" | country_o=="Lithuania" | country_o=="Bulgaria" | country_o=="Romania" | country_o=="Croatia"

*filtering the importers: EU countries* 
eu_d = 1, if country is is a member of EU /// we've got this in our dataset 

keep if eu_d == 1 

*quick check*
list country_o country_d year tradeflow_baci in 1/20
count
///step 3. creating the logarithms for gravity model///
*we will use BACI trade flow - this is best trading flow in CEPII.*

gen ln_trade = ln(tradeflow_baci)

gen ln_gdp_o = ln(gdp_o)
gen ln_gdp_d = ln(gdp_d)
gen ln_dist = ln(dist)

///step 4. descriptive statistics///
summarize ln_trade ln_gdp_o ln_gdp_d ln_dist
summarize ln_trade, detail
summarize ln_gdp_o, detail
summarize ln_gdp_d, detail
summarize ln_dist, detail
*some histograms*
histogram ln_trade
histogram ln_gdp_o
histogram ln_gdp_d
histogram ln_dist

///step 5. creating and lunching the regression ///
/// Additional step: creating the key variable for accession impact
gen post_accession = 0
* Accession 2004 (Poland, Czech Republic, Slovakia, Slovenia, Hungary, Estonia, Latvia, Lithuania)
replace post_accession = 1 if (country_o=="Poland" | country_o=="Czech Republic" | country_o=="Slovakia" | country_o=="Slovenia" | country_o=="Hungary" | country_o=="Estonia" | country_o=="Latvia" | country_o=="Lithuania") & year >= 2004
* Accession 2007 (Bulgaria, Romania)
replace post_accession = 1 if (country_o=="Bulgaria" | country_o=="Romania") & year >= 2007
* Accession 2013 (Croatia)
replace post_accession = 1 if country_o=="Croatia" & year >= 2013

formula for lunching regression: 
ln_trade = β0 
         + β1 ln_gdp_o 
         + β2 ln_gdp_d 
         + β3 ln_dist 
         + β4 сontig 
         + β5 comlang_off
         + β6 post_accession
         + ε
		 
regress ln_trade ln_gdp_o ln_gdp_d ln_dist contig comlang_off post_accession
		 
save gravity_final_merged.dta, replace /// this our final clean and ready dataset with generated variables and labels 		 
		 
		 
/// final step. interpretation///



/// additional step 
