
# EcoEvo Graduate Stipends in Canada --------------------------------------

## Author: Joey Burant
## Last updated: 14-11-2022

## Github repo: https://github.com/jbburant/Cdn-EcoEvo-Stipends

## General information:
## This script produces a set of plots to visually explore the variation
## in minimum stipends, tuition, and rental costs for graduate students
## in ecology and evolution at Canadian universities. 

## Minimum stipends and tuition amounts were searched from departmental
## and university websites in early November 2022 and reflect the latest
## information available. Importantly, these values (particularly stipend 
## amounts) may not be fully up-to-date and thus may differ slightly from
## the actual amounts received by graduate students.

## Tuition costs exclude ancillary fees charged by universities for other
## services, such as athletics and health fees.

## See the Github repository for a full set of variable definitions


# initial set-up ----------------------------------------------------------

## where am I working?
getwd()
# here::here()

## load required packages
library(googlesheets4)
library(dplyr)
library(skimr)
library(ggplot2)
library(ggExtra)
library(cowplot)
library(showtext)

## authorize access to Google Sheets
gs4_auth()

# data import -------------------------------------------------------------

## import compiled data from Google Sheets
stipends <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1w4KM7JGm7XmVwhuIM9nC5R6i685czj5g2GvO9B3Tb3E/edit", 
  sheet = "included", ## which sheet to read from
  na = c("", "NA", 0) ## which values to treat as NAs
  ) |> 
  ## round calculated dollar amounts and proportions to two decimal places
  mutate(across(c("gross_wage_dom", "net_wage_dom", "prop_stipend_rent", 
                  "prop_gross_wage_min_wage", "prop_net_wage_min_wage"), 
                round, 2))

## overview of dataset
names(stipends)
skim(stipends)

## what is the range of tuition values?
stipends |> 
  group_by(degree) |> 
  summarise(min_t = min(tuition_dom, na.rm = TRUE), 
            max_t = max(tuition_dom, na.rm = TRUE), 
            avg_t = mean(tuition_dom, na.rm = TRUE), 
            med_t = median(tuition_dom, na.rm = TRUE))
hist(stipends$tuition_dom)

## what is the range of minimum stipends (after tuition is deducted)?
stipends |> 
  group_by(degree) |> 
  summarise(min_t = min(net_stipend_dom, na.rm = TRUE), 
            max_t = max(net_stipend_dom, na.rm = TRUE), 
            avg_t = mean(net_stipend_dom, na.rm = TRUE), 
            med_t = median(net_stipend_dom, na.rm = TRUE))







