# ------------------------------------------------------------------------------
#          ---        
#        / o o \    Project:  cov-armee Phylodynamics
#        V\ Y /V    Sampling rates calculation for MTBD asymp analysis
#    (\   / - \     25 May 2023
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# ------------------------------------------------------------------------------


library(tidyverse)
library(lubridate)
source('~/Tools/database/R/utility.R')
source("~/Tools/utils/plot_functions.R")
source("~/Tools/talking-to-LAPIS/R/lapis_functions.R")

# 1. Load army screening data
df_army <- load_army_data()
# Using order_date instead of fall_dt to classify in screening samples 
# and isoweek() to filter weeks 2, 3 and 6

# 2. BAG data cases and tests by group age
file <- "/Users/ceciliav/Tools/bag_covid_19_data_csv_23_May_2023/data/COVID19Test_geoRegion_AKL10_w.csv"
df_bag <- read_csv(file)

df_bag_test_young_weeks <- df_bag %>%
  filter(geoRegion == "CH", 
         altersklasse_covid19 == "20 - 29",
         datum %in% c(202102, 202103, 202106)) 

df_bag_test <- df_bag %>%
  filter(geoRegion == "CH", 
         datum >= 202101, 
         datum <= 202107)

df_bag_test_young <- df_bag_test %>%
  filter(altersklasse_covid19 == "20 - 29") 

# # 1.a Rho sampling rate asymptomatics
n_seqs_asymp = nrow(df_army %>% filter(analysis == "screening", !is.na(gisaid_id)))
n_pos_army =  nrow(df_army %>% filter(analysis == "screening"))
n_test_army = 3000 + 6000 + 6000 # Pirmin email
positivity_asymp = n_pos_army / n_test_army
# 
n_pop_young = unique(df_bag_test_young_weeks$pop)
#n_pos_young_weeks = sum(df_bag_young %>% filter(datum <= 202106) %>% pull(entries_pos), na.rm = TRUE)
n_pos_young = sum(df_bag_young$entries_pos, na.rm = TRUE)
# symp_under_reporting = 1
# n_pop_young_nosymp = n_pop_young - (n_pos_young * symp_under_reporting)
# # n_pop_young_nosymp_weeks = n_pop_young - (n_pos_young_weeks * symp_under_reporting)
# n_cases_asymp_weeks = positivity_asymp * n_pop_young_nosymp_weeks
# rho_asymp = n_seqs_asymp / n_cases_asymp_weeks

# 1.b Rho sampling rate asymptomatics second try
## Week 1
n_seqs_asymp_kw2 = nrow(df_army %>% 
                          filter(analysis == "screening", kw == 2, 
                                 gisaid_id %in% qc_seqs$gisaidEpiIsl,
                                 !is.na(genbankAccession))) 
n_pos_army_kw2 =  nrow(df_army %>% filter(analysis == "screening", kw == 2))
n_test_army_kw2 = 3000# Pirmin email
positivity_asymp_kw2 = n_pos_army_kw2 / n_test_army_kw2

n_pop_young = unique(df_bag_test_young_weeks$pop)
n_pos_young_kw2 = sum(df_bag_test_young %>% filter(datum == 202102) %>% pull(entries_pos), na.rm = TRUE)
n_symp_young_kw2 = sum(df_bag_test_young %>% filter(datum == 202102) %>% pull(entries), na.rm = TRUE)
symp_under_reporting = 1
n_pop_young_nosymp_kw2 = n_pop_young - (n_symp_young_kw2 * symp_under_reporting)
n_cases_asymp_kw2 = positivity_asymp_kw2 * n_pop_young_nosymp_kw2
rho_asymp_kw2 = n_seqs_asymp_kw2 / n_cases_asymp_kw2

## Week 2
n_seqs_asymp_kw3 = nrow(df_army %>% filter(analysis == "screening", kw == 3, 
                                           gisaid_id %in% qc_seqs$gisaidEpiIsl,
                                           !is.na(genbankAccession))) 
n_pos_army_kw3 =  nrow(df_army %>% filter(analysis == "screening", kw == 3))
n_test_army_kw3 = 6000# Pirmin email
positivity_asymp_kw3 = n_pos_army_kw3 / n_test_army_kw3

n_symp_young_kw3 = sum(df_bag_test_young %>% filter(datum == 202103) %>% pull(entries), na.rm = TRUE)
symp_under_reporting = 1
n_pop_young_nosymp_kw3 = n_pop_young - (n_symp_young_kw3 * symp_under_reporting)
n_cases_asymp_kw3 = positivity_asymp_kw3 * n_pop_young_nosymp_kw3
rho_asymp_kw3 = n_seqs_asymp_kw3 / n_cases_asymp_kw3

## Week 3
n_seqs_asymp_kw6 = nrow(df_army %>% filter(analysis == "screening", kw == 6, 
                                           gisaid_id %in% qc_seqs$gisaidEpiIsl,
                                           !is.na(gisaid_id))) 
n_pos_army_kw6 =  nrow(df_army %>% filter(analysis == "screening", kw == 6))
n_test_army_kw6 = 6000# Pirmin email
positivity_asymp_kw6 = n_pos_army_kw6 / n_test_army_kw6

n_symp_young_kw6 = sum(df_bag_test_young %>% filter(datum == 202106) %>% pull(entries_pos), na.rm = TRUE)
symp_under_reporting = 1
n_pop_young_nosymp_kw6 = n_pop_young - (n_symp_young_kw6 * symp_under_reporting)
n_cases_asymp_kw6 = positivity_asymp_kw6 * n_pop_young_nosymp_kw6
rho_asymp_kw6 = n_seqs_asymp_kw6 / n_cases_asymp_kw6


# Sampling rate symptomatics TODO
n_pos_young = sum(df_bag_test %>% filter(altersklasse_covid19 == "20 - 29") %>% pull(entries_pos))
total_under_reporting = 2.7
n_cases_young = n_pos_young * total_under_reporting
# n_cases_young = n_cases_asymp + n_cases_symp


n_cases_asymp = positivity_asymp  * n_pop_young_nosymp

n_seqs_symp # to compute so s_asymp == s_symp
n_cases_symp = n_test_young * symp_under_reporting
s_symp = n_seqs_symp / n_cases_symp

# r_asymp_symp = n_cases_asymp / n_cases_symp # false, because n_cases_asymp is 
# only during the 3 screening weeks

# For tree interpretation, we want that
s_asymp == s_symp



# 2. Sampling rate symptomatics 
total_under_reporting = 2.7
n_cases_young = n_pos_young * total_under_reporting
# n_cases_young = n_pos_young * symp_under_reporting + n_asymp_cases
n_asymp_cases = positivity_asymp * n_pop_young
n_symp_cases = n_pos_young * symp_under_reporting
symp_under_reporting = (n_cases_young - n_asymp_cases) /n_pos_young


# 1.Load army data
db_connection <- open_database_connection(
  "server", config_file = "~/Tools/database/config.yml")

# Sample metadata
df_meta_query <- dplyr::tbl(db_connection, "bag_meldeformular") %>%
  select(sample_number, eingang_dt, fall_dt, kanton, altersjahr, sex, manifestation_dt, hospdatin, pttoddat, exp_ort, comment) %>%
  filter(grepl(x = comment, pattern = "armee")) 

# ETHID
df_ethid_query <- dplyr::tbl(db_connection, "backup_220530_viollier_test") %>%
  select(sample_number, ethid, order_date, is_positive) %>%
  right_join(df_meta_query, by = "sample_number")

# gisaid ID
df_seqid_query <- dplyr::tbl(db_connection, "sequence_identifier") %>%
  select(ethid, gisaid_id) %>%
  #inner_join(df_ethid_query, by = "ethid")
  right_join(df_ethid_query, by = "ethid")

# Symptoms
df_symptoms_query <- dplyr::tbl(db_connection, "x_consensus_sequence_notes") %>%
  rename(comment_symptoms = comment) %>%
  select(ethid, comment_symptoms) %>%
  right_join(df_seqid_query, by = "ethid")

df <- df_symptoms_query %>% collect() 

df_dedup <- df %>%
  filter(is_positive) %>%
  distinct() 

# ----------------------
# 1.b Load army metadata from gisaid through LAPIS
# --------------------------------------------

df_gisaid <- lapis_query_by_id(database = "gisaid",
                               endpoint = "details",
                               samples = df$gisaid_id,
                               sample_id = "gisaidEpiIsl")

df_genbank <- lapis_query_by_id(database = "open",
                               endpoint = "details",
                               samples = df$gisaid_id,
                               sample_id = "gisaidEpiIsl")
# ----------------------
# 2. Explore army lineages
# ----------------------

df_join <- df_dedup %>% left_join(df_genbank, by = c("gisaid_id" = "gisaidEpiIsl")) %>%
  mutate(voc = case_when(
    pangoLineage == "B.1.1.7" | grepl("B\\.1\\.1\\.7\\.", pangoLineage) ~ "Alpha",
    pangoLineage == "B.1.351" | grepl("B\\.1\\.351\\.", pangoLineage) ~ "Beta",
    pangoLineage == "P.1" | grepl("P\\.1\\.", pangoLineage) ~ "Gamma",
    pangoLineage == "B.1.617.2" | grepl("B\\.1\\.617\\.2\\.", pangoLineage) ~ "Delta",
    grepl("AY\\.", pangoLineage) ~ "Delta",
    pangoLineage == "B.1.617.1" | grepl("B\\.1\\.617\\.1\\.", pangoLineage) ~ "Kappa",
    pangoLineage == "B.1.427" | grepl("B\\.1\\.427\\.", pangoLineage) ~ "Epsilon",
    pangoLineage == "B.1.429" | grepl("B\\.1\\.429\\.", pangoLineage) ~ "Epsilon",
    pangoLineage == "B.1.525" | grepl("B\\.1\\.525\\.", pangoLineage) ~ "Eta",
    pangoLineage == "B.1.526" | grepl("B\\.1\\.526\\.", pangoLineage) ~ "Iota",
    grepl("BA\\.", pangoLineage) ~ "Omicron",
    pangoLineage == "B.1.1.529" | grepl("B\\.1\\.1\\.529\\.", pangoLineage) ~ "Omicron",
    TRUE ~ "WT"),
    week = floor_date(order_date, "week", week_start = 1),
    kw = isoweek(order_date),
    month = floor_date(order_date, "month"),
    year = floor_date(order_date, "year"),
    army = grepl(x = comment, pattern = "armee"),
    analysis = case_when(
      army & kw %in% c(2,3,6) & year == "2021-01-01" & is.na(comment_symptoms) ~ "screening", 
      TRUE ~ "surveillance"),
    symptoms = case_when(
      comment_symptoms == "Symptomatic Army" ~ T, 
      analysis == "screening"  ~ F))

df_army = df_join



file <- "/Users/ceciliav/Tools/bag_covid_19_data_csv_23_May_2023/data/COVID19Test_geoRegion_sex_w.csv"
df_bag_sex <- read_csv(file) %>%
  filter(geoRegion == "CH", 
         datum %in% c(202102, 202103, 202106)) 
  


# Numebr of seqs to include
mean_rho = mean(c(rho_asymp_kw2,rho_asymp_kw3,rho_asymp_kw6))
active_cases = df_bag_test %>% group_by(datum) %>% summarise(pos = sum(entries_pos))
sum(active_cases %>% slice(1:3) %>% select(pos)) * rho_asymp_kw2
sum(active_cases %>% slice(1:3) %>% select(pos)) * mean_rho
sum(active_cases %>% slice(2:4) %>% select(pos)) * rho_asymp_kw3
sum(active_cases %>% slice(2:4) %>% select(pos)) * mean_rho
sum(active_cases %>% slice(5:7) %>% select(pos)) * rho_asymp_kw6
sum(active_cases %>% slice(5:7) %>% select(pos)) * mean_rho
sum(active_cases %>% select(pos)) * mean_rho

active_cases_young = df_bag_test %>% group_by(datum) %>% filter(altersklasse_covid19 == "20 - 29") %>% summarise(pos = sum(entries_pos))
sum(active_cases_young %>% slice(1:3) %>% select(pos)) * rho_asymp_kw2
sum(active_cases_young %>% slice(2:4) %>% select(pos)) * rho_asymp_kw3
sum(active_cases_young %>% slice(5:7) %>% select(pos)) * rho_asymp_kw6
sum(active_cases_young %>% select(pos)) * mean_rho



qc_seqs <- read_tsv("/Users/ceciliav/Projects/2105-cov-armee/7.asymp-phydyn/results/comm_asymp_2m/data/asymp/subsample_random.0.tsv")
  
df_army %>%
  filter(analysis == "screening", gisaid_id %in% qc_seqs$gisaidEpiIsl) %>%
  count(kw)
  
  

