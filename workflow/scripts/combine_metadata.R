# ------------------------------------------------------------------------------
#          ---        
#        / o o \    Project:  cov-armee Phylodynamics
#        V\ Y /V    Parse and plot BaTs output
#    (\   / - \     
#     )) /    |     
#     ((/__) ||     Code by Ceci VA 
# ------------------------------------------------------------------------------

# Load libraries ---------------------------------------------------------------
library(tidyverse)

# Combine sample ids
ids <- read_tsv(snakemake@input[["ids"]])
metadata <- read_tsv(snakemake@input[["metadata"]])

combined <- left_join(ids, metadata)

p <- ggplot(combined) +
  geom_count(aes(x = date, fill = deme))

write_tsv(combined, file = snakemake@output[["metadata"]])
ggsave(p, filename = snakemake@output[["fig"]])
  
