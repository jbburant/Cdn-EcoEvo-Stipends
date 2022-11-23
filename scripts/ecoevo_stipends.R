
# EcoEvo Graduate Stipends in Canada --------------------------------------

## Author: Joey Burant
## Last updated: 23-11-2022

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
library(googlesheets4)  ## read data from google sheets
library(dplyr)          ## data manipulation
library(readr)          ## read and write data
library(skimr)          ## data summary
library(ggplot2)        ## plotting
library(see)            ## plotting theme

## set a plotting theme
theme_set(theme_blackboard())

## specify a colour palette
pal <- c("#005F73", "#0A9396", "#94D2BD", "#E9D8A6", 
         "#EE9B00", "#CA6702", "#BB3E03", "#AE2012", "#9B2226")

## authorize access to Google Sheets
gs4_auth()

# data import -------------------------------------------------------------

## import compiled data from Google Sheets
stipends <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1w4KM7JGm7XmVwhuIM9nC5R6i685czj5g2GvO9B3Tb3E/edit", 
  sheet = "included", ## which sheet to read from
  na = c("", "NA", 0, "??") ## which values to treat as NAs
  ) |> 
  ## round calculated dollar amounts and proportions to two decimal places
  mutate(across(c("gross_wage_dom", "net_wage_dom", "prop_stipend_rent", 
                  "prop_gross_wage_min_wage", "prop_net_wage_min_wage"), 
                round, 2)) |> 
  ## order provinces from  west to east
  mutate(province = factor(province, levels = c("BC", "AB", "SK", 
                                                "MB", "ON", "QC", 
                                                "NB", "NS", "NL")))

## overview of dataset
names(stipends)
skimr::skim(stipends)


# summary statistics ------------------------------------------------------

## annual tuition (excluding ancillary fees)
stipends |> 
  group_by(degree) |> 
  summarise(min_t = min(tuition_dom, na.rm = TRUE), 
            max_t = max(tuition_dom, na.rm = TRUE), 
            avg_t = mean(tuition_dom, na.rm = TRUE), 
            med_t = median(tuition_dom, na.rm = TRUE), 
            n_t   = n(), 
            sd_t  = sd(tuition_dom, na.rm = TRUE), 
            se_t  =  sd_t / sqrt(n_t))

hist(stipends$tuition_dom)

## post-tuition minimum stipends
stipends |> 
  group_by(degree) |> 
  summarise(min_s = min(net_stipend_dom, na.rm = TRUE), 
            max_s = max(net_stipend_dom, na.rm = TRUE), 
            avg_s = mean(net_stipend_dom, na.rm = TRUE), 
            med_s = median(net_stipend_dom, na.rm = TRUE), 
            n_s   = n(), 
            sd_s  = sd(net_stipend_dom, na.rm = TRUE), 
            se_s  =  sd_s / sqrt(n_s))

hist(stipends$net_stipend_dom)


## net hourly rate as a proportion of provincial minimum wage
stipends |> 
  filter(prop_net_wage_min_wage > 0) |> 
  group_by(degree) |> 
  summarise(min_w = min(prop_net_wage_min_wage, na.rm = TRUE), 
            max_w = max(prop_net_wage_min_wage, na.rm = TRUE), 
            avg_w = mean(prop_net_wage_min_wage, na.rm = TRUE), 
            med_w = median(prop_net_wage_min_wage, na.rm = TRUE), 
            n_w   = n(), 
            sd_w  = sd(prop_net_wage_min_wage, na.rm = TRUE), 
            se_w  =  sd_w / sqrt(n_w))

hist(stipends$prop_net_wage_min_wage)

## proportion of annual rental costs covered by net stipend
stipends |> 
  summarise(min_r = min(prop_stipend_rent, na.rm = TRUE), 
            max_r = max(prop_stipend_rent, na.rm = TRUE), 
            avg_r = mean(prop_stipend_rent, na.rm = TRUE), 
            med_r = median(prop_stipend_rent, na.rm = TRUE), 
            n_r   = n(), 
            sd_r  = sd(prop_stipend_rent, na.rm = TRUE), 
            se_r  =  sd_r / sqrt(n_r))

hist(stipends$rent_year)


# visualizations ----------------------------------------------------------

## plot net stipends against the average annual rent
ggplot(data = stipends, 
       mapping = aes(x = rent_year, 
                     y = net_stipend_dom, 
                     colour = province)) + 
  geom_abline(slope = 1, intercept = 0, lwd = 1.5, colour = "grey50", lty = 6) + 
  geom_smooth(se = FALSE, 
              method = "lm", colour = "grey", lwd = 1.5) + 
  geom_point(size = 3) + 
  facet_wrap(~ degree) + 
  scale_colour_manual(values = pal, name = NULL) + 
  scale_x_continuous(limits = c(6500, 28500)) +
  scale_y_continuous(limits = c(6500, 28500)) +
  coord_fixed() +
  labs(x = "Average annual cost of rent ($)", 
       y = "Minimum domestic stipend after tuition ($)") + 
  theme(legend.position = "bottom") + 
  guides(colour = guide_legend(nrow = 1))

## lollipop chart of net stipends (after tuition)
(
  p1 <- stipends |> 
    group_by(degree) |> 
    mutate(mean_stipend = mean(net_stipend_dom)) |> 
    ungroup() |> 
    ggplot(mapping = aes(x = interaction(university, province), 
                         y = net_stipend_dom, 
                         colour = province)) + 
    geom_hline(mapping = aes(yintercept = mean_stipend), 
               colour = "grey", lwd = 1) + 
    geom_segment(mapping = aes(x    = interaction(university, province), 
                               xend = interaction(university, province), 
                               y    = mean_stipend, 
                               yend = net_stipend_dom), 
                 colour = "grey") + 
    geom_point(size = 3) + 
    facet_wrap(~ degree, ncol = 1) + 
    scale_y_continuous(limits = c(6900, 28100), 
                       breaks = seq(8000, 28000, by = 4000)) + 
    scale_colour_manual(values = pal, name = NULL) + 
    labs(x = NULL, y = "Minimum domestic stipend \nafter tuition ($)") + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 7.5), 
          legend.position = "bottom") + 
    guides(colour = guide_legend(nrow = 1))
)

ggsave("figures/net_stipends_lollipop.jpeg", plot = p1, 
       height = 4, width = 6, units = "in", dpi = "retina")

## lollipop chart of calculated net hourly rates (after tuition) 
## relative to provincial minimum wages
(
  p2 <- stipends |> 
  group_by(degree) |> 
  mutate(mean_prop_wage = mean(prop_net_wage_min_wage)) |> 
  ungroup() |> 
  ggplot(mapping = aes(x = interaction(university, province), 
                       y = prop_net_wage_min_wage, 
                       colour = province)) + 
  geom_hline(mapping = aes(yintercept = mean_prop_wage), 
             colour = "grey", lwd = 1) + 
  geom_hline(yintercept = 1, lty = 2, colour = "grey") + 
  geom_segment(mapping = aes(x    = interaction(university, province), 
                             xend = interaction(university, province), 
                             y    = mean_prop_wage, 
                             yend = prop_net_wage_min_wage), 
               colour = "grey") + 
  geom_point(size = 3) + 
  facet_wrap(~ degree, ncol = 1) + 
  scale_y_continuous(limits = c(0.25, 1.10),
                     breaks = seq(0.25, 1.0, by = 0.25)) +
  scale_colour_manual(values = pal, name = NULL) + 
  labs(x = NULL, y = "Calculated net hourly rate as a \nproportion of minimum wage") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 7.5), 
        legend.position = "bottom") + 
  guides(colour = guide_legend(nrow = 1))
)

ggsave("figures/prop_minimum_wage_lollipop.jpeg", plot = p2, 
       height = 4, width = 6, units = "in", dpi = "retina")


## lollipop chart of proportion of annual rent covered by net stipend
(
  p3 <- stipends |> 
  group_by(degree) |> 
  mutate(mean_prop_rent = mean(prop_stipend_rent, na.rm = TRUE)) |> 
  ungroup() |> 
  ggplot(mapping = aes(x = interaction(university, province), 
                       y = prop_stipend_rent, 
                       colour = province)) + 
  geom_hline(mapping = aes(yintercept = mean_prop_rent), 
             colour = "grey", lwd = 1) + 
  geom_hline(yintercept = 1, lty = 2, colour = "grey") + 
  geom_segment(mapping = aes(x    = interaction(university, province), 
                             xend = interaction(university, province), 
                             y    = mean_prop_rent, 
                             yend = prop_stipend_rent), 
               colour = "grey") + 
  geom_point(size = 3) + 
  facet_wrap(~ degree, ncol = 1) + 
  scale_y_continuous(limits = c(0.4, 1.9),
                     breaks = seq(0.5, 1.75, by = 0.25)) +
  scale_colour_manual(values = pal, name = NULL) + 
  labs(x = NULL, y = "Proportion of annual rent covered \nby post-tuition stipend") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 7.5), 
        legend.position = "bottom") + 
  guides(colour = guide_legend(nrow = 1))
)

ggsave("figures/prop_annual_rent_lollipop.jpeg", plot = p3, 
       height = 4, width = 6, units = "in", dpi = "retina")


# write dataset to csv ----------------------------------------------------

write_csv(stipends, "data/eco_evo_stipends_2022.csv")


# end of script -----------------------------------------------------------
