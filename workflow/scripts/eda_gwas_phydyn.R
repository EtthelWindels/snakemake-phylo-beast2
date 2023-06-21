# ------------------------------------------------------------------------------
#          ---        
#        / o o \    Project:  cov-armee GWAS Phylodynamics
#        V\ Y /V    EDA mutation C3037T
#    (\   / - \     13 September 2022
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# ------------------------------------------------------------------------------


library(tidyverse)
library(lubridate)
source("~/Tools/utils/plot_functions.R")
source("~/Tools/talking-to-LAPIS/R/lapis_functions.R")

# For reproducible army like dataset
set.seed(24)
set_plotopts()

# ----------------------
# 1.Load army data
# ----------------------
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
  inner_join(df_ethid_query, by = "ethid")

# Symptoms
df_symptoms_query <- dplyr::tbl(db_connection, "x_consensus_sequence_notes") %>%
  rename(comment_symptoms = comment) %>%
  select(ethid, comment_symptoms) %>%
  right_join(df_seqid_query, by = "ethid")

# CT value
df_ct_query <- dplyr::tbl(db_connection, "backup_220530_viollier_test__viollier_plate") %>%
  select(sample_number, e_gene_ct, rdrp_gene_ct) %>%
  filter(!is.na(e_gene_ct) | !is.na(rdrp_gene_ct)) %>%
  right_join(df_symptoms_query, by = "sample_number")

df <- df_ct_query %>% collect() 

df_dedup <- df %>%
  filter(is_positive) %>%
  distinct() %>%
  # Duplicates are due to :
  # 1. two entries in viollier_test__viollier_plate for the two genes ct values
  #    We keep both ct values
  group_by(sample_number) %>%
  fill(e_gene_ct, rdrp_gene_ct, .direction = "downup") %>%
  distinct() %>%
  ungroup %>%
  # Take min CT value if both genes ct-values are filled
  group_by(sample_number) %>%
  mutate(ct = case_when(
    !is.na(e_gene_ct) & !is.na(rdrp_gene_ct) ~ min(e_gene_ct, rdrp_gene_ct),
    is.na(e_gene_ct) & !is.na(rdrp_gene_ct) ~ rdrp_gene_ct,
    !is.na(e_gene_ct) & is.na(rdrp_gene_ct) ~ e_gene_ct
  )) %>% ungroup

# ----------------------
# 1.b Load army metadata from gisaid through LAPIS
# --------------------------------------------

df_gisaid <- lapis_query_by_id(database = "gisaid",
                               endpoint = "details",
                               samples = df$gisaid_id,
                               sample_id = "gisaidEpiIsl")
# ----------------------
# 2. Explore army lineages
# ----------------------

df_join <- df_dedup %>% left_join(df_gisaid, by = c("gisaid_id" = "gisaidEpiIsl")) %>%
  mutate(voc = case_when(
    grepl("B.1.1.7", pangoLineage) ~ "Alpha",
    grepl("B.1.351", pangoLineage) ~ "Beta",
    grepl("P.1", pangoLineage) ~ "Gamma",
    grepl("B.1.617.2", pangoLineage) ~ "Delta",
    grepl("AY", pangoLineage) ~ "Delta",
    grepl("B.1.617.1", pangoLineage) ~ "Kappa",
    grepl("B.1.427", pangoLineage) ~ "Epsilon",
    grepl("B.1.429", pangoLineage) ~ "Epsilon",
    grepl("B.1.525", pangoLineage) ~ "Eta",
    grepl("B.1.526", pangoLineage) ~ "Iota",
    grepl("BA", pangoLineage) ~ "Omicron",
    grepl("B.1.1.529", pangoLineage) ~ "Omicron",
    TRUE ~ "WT"),
    week = floor_date(fall_dt, "week", week_start = 1),
    kw = isoweek(fall_dt),
    month = floor_date(fall_dt, "month"),
    year = floor_date(fall_dt, "year"),
    army = grepl(x = comment, pattern = "armee"),
    analysis = case_when(
     army & kw %in% c(2,3,6) & year == "2021-01-01" & is.na(comment_symptoms) ~ "screening", 
     TRUE ~ "surveillance"),
    symptoms = case_when(
     comment_symptoms == "Symptomatic Army" ~ T, 
     analysis == "screening"  ~ F))

ggplot(df_join 
       #%>% filter(analysis != "screening")
       ) +
  geom_violin(aes(ct, voc)) +
  geom_boxplot(aes(ct, voc), width = 0.1)

library(rstatix)
test <- wilcox_test(df_join 
                    #%>% filter(analysis != "screening")
                    , ct ~ voc)

# CT values differ significantly between variants. Alpha < WT < Delta
# Screening samples do not impact this relationship

ggplot(df_join) +
  geom_violin(aes(ct, analysis)) +
  geom_boxplot(aes(ct, analysis), width = 0.1)

# Query lapis mutation C3037T

df_mut <- lapis_query_by_id(database = "gisaid",
                         endpoint = "details",
                         samples = df_join$gisaid_id,
                         sample_id = "gisaidEpiIsl",
                         more_filter = lapis_filter(nucMutations = "3037T"),
                         access_key =  Sys.getenv("LAPIS_ACCESS_KEY"))




df_join <- df_join %>%
  mutate(mut = ifelse(gisaid_id %in% df_mut$gisaidEpiIsl, TRUE, FALSE))

df_join %>% 
  #filter(analysis != "screening") %>%
  count(mut)
# 792 samples have mutation 3037T, and 87 do not

# CT value
ggplot(df_join
       #%>% filter(analysis == "surveillance")
       ) +
  geom_violin(aes(ct, mut)) +
  geom_boxplot(aes(ct, mut), width = 0.1)

# Analysis
ggplot(df_join) +
  geom_bar(aes(analysis, fill = mut)) 

ggplot(df_join
       #%>% filter(analysis == "surveillance")
) +
  geom_violin(aes(ct, analysis, color = mut), position = position_dodge(0.75)) +
  geom_boxplot(aes(ct, analysis, color = mut), width = 0.1, position = position_dodge(0.75))

# Location
ggplot(df_join) +
  geom_bar(aes(kanton, fill = mut)) 

# Time
ggplot(df_join %>%
         count(week, mut), 
       aes(week, n, fill = mut)) +
  geom_bar(stat = "identity", position = "dodge")

ggplot(df_join %>%
         group_by(week, mut) %>%
         summarise(median_ct = median(ct, na.rm = TRUE)), 
       aes(week, median_ct, color = mut)) +
  geom_point() +
  geom_line()

# Lineage
ggplot(df_join) +
  geom_bar(aes(voc, fill = mut)) 


ggplot(df_join
       #%>% filter(analysis == "surveillance")
, aes(ct, voc, color = mut)) +
  geom_violin(position = position_dodge(0.75)) +
  geom_boxplot(width = 0.1, position = position_dodge(0.75)) +
  geom_jitter(alpha = 0.2,  position = position_jitterdodge(jitter.width = 0.3, dodge.width = 0.75))

df_join %>%
  filter(voc == "WT") %>%
  filter(order_date > "2020-09-01", order_date < "2021-03-01") %>%
  filter(analysis == "surveillance") %>%
  count(mut)

# No clear confounding effect, looks like mutation C3037T is related to low CT
ggplot(df_join %>%
         filter(voc == "WT") %>%
         filter(order_date < "2021-03-01") %>%
         filter(order_date > "2020-09-01") %>%
         filter(analysis == "surveillance") %>%
         count(week, mut), 
       aes(week, n, fill = mut)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_x_date(date_breaks = "month")

ggplot(df_join %>%
         count(week, voc), 
       aes(week, n, fill = voc)) +
  geom_bar(stat = "identity") +
  scale_x_date(date_breaks = "month")

df_join %>%
  filter(order_date < "2021-03-01",
    voc == "WT") %>%
  #filter(analysis == "surveillance")  %>% 
  count(mut)

# Selecting only sequences until 2021-03-01 of Wildtype strain so we do not need 
# to deal with different variants and 70% of the sequences without mutation C3037 
# are in this group (61 of 87).
# Total dataset size 61 + 249 = 310


ggplot(df_join
       %>% filter(order_date < "2021-03-01") 
       %>% filter(voc == "WT") 
       #%>% filter(analysis == "surveillance")
) + 
  geom_violin(aes(ct, analysis, color = mut), position = position_dodge(0.75)) +
  geom_boxplot(aes(ct, analysis, color = mut), width = 0.1, position = position_dodge(0.75))

       
# Save ids
df_ids <- df_join %>% 
  filter(order_date < "2021-03-01",
         voc == "WT") %>%
  select(gisaid_id, strain, genbankAccession, sraAccession, ethid, sample_number, mut) %>%
  rename(gisaidEpiIsl = gisaid_id)

write_tsv(df_ids %>% filter(mut) %>% select(-mut), "5.gwas-phydyn/data/mut_ids.tsv")
write_tsv(df_ids %>% filter(!mut) %>% select(-mut), "5.gwas-phydyn/data/wt_ids.tsv")



# Save surveillance ids
df_surv_ids <- df_join %>% 
  filter(order_date < "2021-03-01",
         voc == "WT",
         analysis == "surveillance") %>%
  select(gisaid_id, strain, genbankAccession, sraAccession, ethid, sample_number, mut) %>%
  rename(gisaidEpiIsl = gisaid_id)

write_tsv(df_surv_ids %>% filter(mut) %>% select(-mut), "5.gwas-phydyn/data/mut_surv_ids.tsv")
write_tsv(df_surv_ids %>% filter(!mut) %>% select(-mut), "5.gwas-phydyn/data/wt_surv_ids.tsv")
# 
# # Community
# 
# df_mut_com <- lapis_query(database = "gisaid",
#                             endpoint = "aggregated",
#                             filter = lapis_filter(nucMutations = "3037T"),
#                             accessKey =  Sys.getenv("LAPIS_ACCESS_KEY"))
# 
# 

# CT
# Save surveillance ids
df_surv_ids_ct <- df_join %>% 
  filter(voc == "WT") %>%
  filter(order_date < "2021-03-01") %>%
  filter(order_date > "2020-09-01") %>%
  filter(analysis == "surveillance") %>%
  mutate(ct_cat = (ct >= 30)) %>%
  filter(!is.na(ct_cat)) %>%
  select(gisaid_id, strain, genbankAccession, sraAccession, ethid, sample_number, ct_cat) %>%
  rename(gisaidEpiIsl = gisaid_id)

df_surv_ids_ct %>%
  count(ct_cat)
ggplot(df_surv_ids_ct %>%
         count(week, ct >= 30 ), 
       aes(week, n, fill = `ct >= 30`)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_x_date(date_breaks = "month")

write_tsv(df_surv_ids_ct %>% filter(ct_cat) %>% select(-ct_cat), "5.gwas-phydyn/data/cthigh_surv_ids.tsv")
write_tsv(df_surv_ids_ct %>% filter(!ct_cat) %>% select(-ct_cat), "5.gwas-phydyn/data/ctlow_surv_ids.tsv")

