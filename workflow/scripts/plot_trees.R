# ------------------------------------------------------------------------------
#          ---        
#        / o o \    Project:  cov-armee
#        V\ Y /V    Plot tree results 7.army-phydyn
#    (\   / - \     11 May 2023
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# ------------------------------------------------------------------------------


library(tidyverse)
library(lubridate)
source('~/Tools/utils/plot_functions.R')
source("~/Tools/utils/talking_to_beast.R")
source("~/Tools/talking-to-LAPIS/R/lapis_functions.R")
library(ggtree)
set_plotopts()

# Read tree and metadata

tree_file <- "/Users/ceciliav/Projects/2105-cov-armee/7.asymp-phydyn/results/commlike_asymp_comm_2m/trees/ml_tree_random.0.treefile"
timetree_file <- "/Users/ceciliav/Projects/2105-cov-armee/7.asymp-phydyn/results/commlike_asymp_comm_2m/trees/timetree_random.0.nexus"
metadata_file_symp <- "/Users/ceciliav/Projects/2105-cov-armee/7.asymp-phydyn/results/commlike_asymp_comm_2m/data/symp/metadata_symp.tsv"
metadata_file_asymp <- "/Users/ceciliav/Projects/2105-cov-armee/7.asymp-phydyn/results/commlike_asymp_comm_2m/data/asymp/metadata_asymp.tsv"
metadata_file_community <- "/Users/ceciliav/Projects/2105-cov-armee/7.asymp-phydyn/results/commlike_asymp_comm_2m/data/community/metadata_community.tsv"

tree <- treeio::read.tree(tree_file)
timetree <- treeio::read.beast(timetree_file)
tree$tip.label <- str_split(tree$tip.label, "\\|", simplify = TRUE)[,1]
timetree@phylo$tip.label <- str_split(timetree@phylo$tip.label, "\\|", simplify = TRUE)[,1]

metadata <- bind_rows(read_tsv(metadata_file_symp), 
                      bind_rows(read_tsv(metadata_file_asymp), read_tsv(metadata_file_community))) %>%
  filter(gisaidEpiIsl %in% tree$tip.label) %>%
  select(gisaidEpiIsl, everything()) %>%
  group_by(gisaidEpiIsl) %>%
  slice(1) %>%
  ungroup

t <- ggtree(tree, ladderize = T,  color = "grey30", alpha = 0.5) %<+%
  metadata +
  geom_tippoint(data = td_filter(deme != "community"), 
                aes(color = deme), alpha = 0.3, size = 1) +
  theme_tree2()

tt <- ggtree(timetree, ladderize = T,  color = "grey30", size = 0.1) %<+%
  metadata +
  geom_tippoint(data = td_filter(deme == "asymp"), 
                aes(color = deme), alpha = 1, size = 0.5) +
  theme_tree2()

hm <- metadata %>% select(deme)
row.names(hm) <- metadata$gisaidEpiIsl

tt %>%
  gheatmap(as.matrix(hm), offset=-1.0, width=0.05, colnames=FALSE) %>%
  scale_x_ggtree()


# Add BAG database metadata

source('~/Tools/database/R/utility.R')
db_connection <- open_database_connection(
  "server", config_file = "~/Tools/database/config.yml")

# gisaid ID
df_seqid_query <- dplyr::tbl(db_connection, "sequence_identifier") %>%
  select(ethid, gisaid_id) 

# ETHID
df_ethid_query <- dplyr::tbl(db_connection, "backup_220530_viollier_test") %>%
  select(sample_number, ethid, order_date, is_positive) %>%
  right_join(df_seqid_query, by = "ethid")

# Sample metadata
df_meta_query <- dplyr::tbl(db_connection, "bag_meldeformular") %>%
  select(sample_number, eingang_dt, fall_dt, kanton, altersjahr, sex, manifestation_dt, hospdatin, pttoddat, exp_ort, comment) %>%
  right_join(df_ethid_query, by = "sample_number")

metadata_bag <- df_meta_query %>% collect()  %>%
  filter(gisaid_id %in% metadata$gisaidEpiIsl)

# Add kanton info
hm <- metadata_bag %>% select(kanton)
row.names(hm) <- metadata_bag$gisaid_id

tt %>%
  gheatmap(as.matrix(hm), offset=-1.2, width=0.05, colnames=FALSE) %>%
  scale_x_ggtree()

tt + geom_text2(aes(subset=!isTip, label=node))
viewClade(tt, 1544) %>%
  gheatmap(as.matrix(hm), offset=-1.2, width=0.05, colnames=FALSE) %>%
  scale_x_ggtree()

t + geom_text2(aes(subset=!isTip, label=node), size = 2)
viewClade(t, 1705) %>%
  gheatmap(as.matrix(hm), offset=-0.0005, width=0.05, colnames=FALSE) %>%
  scale_x_ggtree()


# Add mutation info 29557T --> clade with the mutation
df_mut29557T <- lapis_query_by_id(database = "gisaid",
                            endpoint = "details",
                            samples = metadata$gisaidEpiIsl,
                            sample_id = "gisaidEpiIsl",
                            more_filter = lapis_filter(variantQuery = "29557T"),
                            access_key =  Sys.getenv("LAPIS_ACCESS_KEY"))

df_wt29557T <- lapis_query_by_id(database = "gisaid",
                           endpoint = "details",
                           samples = metadata$gisaidEpiIsl,
                           sample_id = "gisaidEpiIsl",
                           more_filter = lapis_filter(variantQuery = "!maybe(29557T)"),
                           access_key =  Sys.getenv("LAPIS_ACCESS_KEY"))

hm29557T <- metadata_bag  %>% 
  mutate(mut = case_when(
    gisaid_id %in% df_mut29557T$gisaidEpiIsl ~ TRUE,
    gisaid_id %in% df_wt29557T$gisaidEpiIsl ~ FALSE,
    TRUE ~ NA)) %>% 
  select(kanton, mut)
row.names(hm29557T) <- metadata_bag$gisaid_id
tt %>%
  gheatmap(as.matrix(hm29557T), offset=-1.2, width=0.05, colnames=FALSE) %>%
  scale_x_ggtree()
viewClade(tt, 1481) %>%
  gheatmap(as.matrix(hm29557T), offset=-1.2, width=0.05, colnames=FALSE) %>%
  scale_x_ggtree()

# Add mutation info 29867A --> homogeneous
df_mut29867A <- lapis_query_by_id(database = "gisaid",
                            endpoint = "details",
                            samples = metadata$gisaidEpiIsl,
                            sample_id = "gisaidEpiIsl",
                            more_filter = lapis_filter(variantQuery = "29867A"),
                            access_key =  Sys.getenv("LAPIS_ACCESS_KEY"))

df_wt29867A <- lapis_query_by_id(database = "gisaid",
                           endpoint = "details",
                           samples = metadata$gisaidEpiIsl,
                           sample_id = "gisaidEpiIsl",
                           more_filter = lapis_filter(variantQuery = "!maybe(29867A)"),
                           access_key =  Sys.getenv("LAPIS_ACCESS_KEY"))

hm <- metadata_bag  %>% 
  left_join(metadata, by = c("gisaid_id" = "gisaidEpiIsl")) %>%
  mutate(mut29867A = case_when(
    gisaid_id %in% df_mut29867A$gisaidEpiIsl ~ TRUE,
    gisaid_id %in% df_wt29867A$gisaidEpiIsl ~ FALSE,
    TRUE ~ NA), 
    mut29557T = hm29557T$mut) %>% 
  select(deme, nextstrainClade, pangoLineage, kanton, mut29867A, mut29557T)
row.names(hm) <- metadata_bag$gisaid_id
tt %>%
  gheatmap(as.matrix(hm), offset=-1.2, width=0.05, 
           colnames=TRUE, colnames_position="top", colnames_angle = 90, colnames_offset_x = 0.2, colnames_offset_y = -80, font.size = 2.5) %>%
  scale_x_ggtree()
viewClade(tt, 1481) %>%
  gheatmap(as.matrix(hm), offset=-1.2, width=0.05, 
           colnames=TRUE, colnames_position="top", colnames_angle = 90, colnames_offset_x = 0.2, colnames_offset_y = -80, font.size = 2.5) %>%
  scale_x_ggtree()
