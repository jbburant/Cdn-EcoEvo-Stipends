# Ecology and Evolution Graduate Stipends in Canada

## Brief Description
Data on minimum stipends, tuition, and cost of living for graduate programs in ecology and evolution at major universities in Canada (2022). This repository also includes R code to produce a series of summary statistics and plots exploring variation in minimum financial support to graduate researchers, and how this funding compares to cost of tuition and rent.

## Context


## Questions
1. 
2. 
3. 

## Variable definitions
- university = university name or abbreviation [basic info]
- province = province in which university is located [basic info]
- city = city (proper) in which the university is located (e.g., SFU is in Burnaby not Vancouver) [basic info]
- department = academic department through which the ecology and evolution (or adjacent) program is offered [basic info]
- degree = (required)
- website = (required)
- tuition_dom = (required)
- waiver_dom = (required)
- tuition_int = (optional)
- waiver_int = (optional)
- guaranteed_funding = (required)
- gross_stipend_dom = (required)
- net_stipend_dom = (calculated)
- gross_wage_dom = (calculated)
- net_wage_dom = (calculated)
- stipend_gra = (required)
- stipend_gta = (required)
- gta_hours = (optional)
- living_month = (common source)
- rent_month = (common source)
- rent_year = (calculated)
- prop_stipend_rent = (calculated)
- min_wage_nov22 = (required)
- prop_gross_wage_min_wage = (calculated)
- prop_net_wage_min_wage = (calculated)
- notes = (optional)

## Data sources
- the initial set of universities considered was extracted and expanded from the Maclean's University Ranking: https://education.macleans.ca/education/canadas-best-universities-by-reputation-rankings-2023/
- tuition and stipend amounts were collated from university and departmental websites (see variable:website); typically, exact tuition values were found on a separate fee schedule
- cost of living and average rental costs were extracted from Numbeo on 09 November 2022: https://www.numbeo.com/cost-of-living/
- the average annual number of hours work in Canada (used to translate stipends to hourly rates) was taken from the StatsCan Labour Survey (via OECD) and was 1685 h in 2021: https://stats.oecd.org/index.aspx?DataSetCode=ANHRS
 
