# Graduate Stipends in Canadian Ecology & Evolution Programs

## Brief Description
Data on minimum stipends, tuition, and cost of living for graduate programs (M.Sc. and Ph.D.) in ecology and evolution at major universities in Canada (2022). This repository also includes R code to produce a series of summary statistics and plots exploring variation in minimum financial support to graduate researchers, and how this funding compares to cost of tuition and rent.

## Context
See this twitter thread for more context: https://twitter.com/jbburant/status/1595413427786321922?s=20&t=zBqTPgGHA32KYJ3hIMqwHA

## Questions
1. How do post-tuition* minimum stipend amounts compare across ecology and evolution programs in Canada?
2. Do post-tuition* hourly rates meet provincial minimum wage requirements?
3. Do post-tuition* stipends cover the annual cost of renting a one-bedroom, non-central apartment in the city in which the institution is located?

**Why *post-tuition*?** Simply, tuition fees are highly variable and are effectively an in-house transfer of funds from departments and research budgets to universities. This money is never seen by graduate students; the question is whether they can live on the money left over after tuition is deducted.

 
## Variable definitions
*Descriptors*
- university = university name or abbreviation
- province = province in which university is located
- city = city (proper) in which the university is located (e.g., SFU is in Burnaby not Vancouver)
- department = academic department through which the ecology and evolution (or adjacent) program is offered
- degree = academic degree offered (MSc or PhD)
- website = website on which stipend information can be found (more details about tuition typically found on other sites)

*Core data*
- tuition_dom = annual tuition paid (in CAD) by domestic students (typically in three installments); does not include ancillary fees (e.g., athletics, health, etc.)
- waiver_dom = whether the domestic tuition is waived (or subsized) by the department
- tuition_int = annual tuition paid (in CAD) by international students (typically in three installments); does not include ancillary fees
- waiver_int = whether the international tuition is waived (or subsized) by the department or offset (via scholarships)
- guaranteed_funding = whether funding is guaranteed for students entering the program
- gross_stipend_dom = total annual stipend (in CAD); does not include the value of tuition waivers, but does include value of paid tuition if used to calculate stipend (e.g., UNB)
- stipend_gra = whether the stipend includes a graduate research assistantship (GRA)
- stipend_gta = whether the stipend includes a graduate teach assistantship(s) (GTA)
- gta_hours = expected number of GTA hours per year, either quoted on department websites or searched in TA union guidelines (optional)
- notes = additional context about how stipends are structured or interpreted for the purposes of this table (optional)

*Other data*
- living_month = average monthly cost (in CAD) of living excluding rent as determined by Numbeo user-submitted data
- rent_month = average monthly cost (in CAD) of a one-bedroom apartment outside the city centre as determined by Numbeo
- min_wage_nov22 = provincial minimum hourly wage as of November 2022

*Calculated variables*
- net_stipend_dom = annual stipend after domestic tuition is deducted (if tuition is not otherwise waived)
- gross_wage_dom = hourly wage calculated from total (gross) annual stipend divided by average full-time hours (1685 h in 2021 per OECD)
- net_wage_dom = post-tuition (net) hourly wage for domestic; calculated from net_stipend_dom in the same manner as gross_wage
- rent_year = average annual cost of rent (rent_month x 12)
- prop_stipend_rent = net_stipend divided by rent_year
- prop_gross_wage_min_wage = gross_wage_dom divided by min_wage_nov22
- prop_net_wage_min_wage = net_wage_dom divided by min_wage_nov22

## Data sources
- the initial set of universities considered was extracted and expanded from the Maclean's University Ranking: https://education.macleans.ca/education/canadas-best-universities-by-reputation-rankings-2023/
- tuition and stipend amounts were collated from university and departmental websites (see variable: website); typically, exact tuition values were found on a separate fee schedule
- cost of living and average rental costs were extracted from Numbeo on 09 November 2022: https://www.numbeo.com/cost-of-living/
- the average number of hours worked annually in Canada (used to translate stipends to hourly rates) was taken from the StatsCan Labour Survey (via OECD) and was 1685 h in 2021: https://stats.oecd.org/index.aspx?DataSetCode=ANHRS
 
