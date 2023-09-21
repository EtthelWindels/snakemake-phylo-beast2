## ------------------------------------------------------------------------
## Plot posterior densities inferred with BEAST
## 2023-08-24 Etthel Windels
## ------------------------------------------------------------------------



# Load libraries ----------------------------------------------------------

library(argparse)
library(ggplot2)
library(dplyr)
library(stringr)
library(cowplot)



# Read arguments ----------------------------------------------------------

# Malawi
LOGFILE_Ma_4_2 <- snakemake@input[[1]]

# Tanzania
LOGFILE_Ta_3_2 <- snakemake@input[[2]]

# The Gambia
LOGFILE_TG_4_2 <- snakemake@input[[3]]

# Vietnam
LOGFILE_VN_2_2 <- snakemake@input[[4]]



# Load trajectories -------------------------------------------------------

loadTrajectories <- function(filename, burninFrac=0.1, subsample=NA) {
  
  df_in <- as.matrix(read.table(filename, header=T))
  
  if (burninFrac>0) {
    n <- dim(df_in)[1]
    df_in <- df_in[-(1:ceiling(burninFrac*n)),]
  }
  
  if (!is.na(subsample)) {
    indices <- unique(round(seq(1, dim(df_in)[1], length.out=subsample)))
    df_in <- df_in[indices,]
  }
  
  return(df_in)
}



# Get posterior densities -------------------------------------------------

# Malawi

logfile_Ma_4_2 <- loadTrajectories(LOGFILE_Ma_4_2, burninFrac=0.1) %>%
              as.data.frame()
logfile_Ma_4_2$lambda1 <- logfile_Ma_4_2$birthRate.1
logfile_Ma_4_2$lambda2 <- logfile_Ma_4_2$birthRate.2

# Tanzania

logfile_Ta_3_2 <- loadTrajectories(LOGFILE_Ta_3_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_3_2$lambda1 <- logfile_Ta_3_2$birthRate.1
logfile_Ta_3_2$lambda2 <- logfile_Ta_3_2$birthRate.2

# The Gambia

logfile_TG_4_2 <- loadTrajectories(LOGFILE_TG_4_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_TG_4_2$lambda1 <- logfile_TG_4_2$birthRate.1
logfile_TG_4_2$lambda2 <- logfile_TG_4_2$birthRate.2

# Vietnam

logfile_VN_2_2 <- loadTrajectories(LOGFILE_VN_2_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_VN_2_2$lambda1 <- logfile_VN_2_2$birthRate.1
logfile_VN_2_2$lambda2 <- logfile_VN_2_2$birthRate.2


# Plot posterior densities ------------------------------------------------

all_lin_2 <- data.frame(country=c(rep("Malawi",2*dim(logfile_Ma_4_2)[1]),rep("Tanzania",2*dim(logfile_Ta_3_2)[1]),rep("TheGambia",2*dim(logfile_TG_4_2)[1]),rep("Vietnam",2*dim(logfile_VN_2_2)[1])),
                      lineage=c(rep("L4",2*dim(logfile_Ma_4_2)[1]),rep("L3",2*dim(logfile_Ta_3_2)[1]),rep("L4",2*dim(logfile_TG_4_2)[1]),rep("L2",2*dim(logfile_VN_2_2)[1])),
                      epoch=c(rep("t1",dim(logfile_Ma_4_2)[1]),rep("t2",dim(logfile_Ma_4_2)[1]),rep("t1",dim(logfile_Ta_3_2)[1]),rep("t2",dim(logfile_Ta_3_2)[1]),rep("t1",dim(logfile_TG_4_2)[1]),rep("t2",dim(logfile_TG_4_2)[1]),rep("t1",dim(logfile_VN_2_2)[1]),rep("t2",dim(logfile_VN_2_2)[1])),
                      lambda=c(logfile_Ma_4_2$lambda1,logfile_Ma_4_2$lambda2,logfile_Ta_3_2$lambda1,logfile_Ta_3_2$lambda2,logfile_TG_4_2$lambda1,logfile_TG_4_2$lambda2,logfile_VN_2_2$lambda1,logfile_VN_2_2$lambda2))


# 2 time intervals

lambda_Ma_2 <- ggplot(all_lin_2[all_lin_2$country=="Malawi",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Malawi"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2'),values=c('#c08168ff','#c08168ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2'),values=c('#c08168ff','#c08168ff'))

lambda_Ta_2 <- ggplot(all_lin_2[all_lin_2$country=="Tanzania",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Tanzania"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2'),values=c('#bfcbdbff','#bfcbdbff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2'),values=c('#bfcbdbff','#bfcbdbff'))

lambda_TG_2 <- ggplot(all_lin_2[all_lin_2$country=="TheGambia",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("The Gambia"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2'),values=c('#c08168ff','#c08168ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2'),values=c('#c08168ff','#c08168ff'))

lambda_VN_2 <- ggplot(all_lin_2[all_lin_2$country=="Vietnam",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Vietnam"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2'),values=c('#8a96a3ff','#8a96a3ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2'),values=c('#8a96a3ff','#8a96a3ff'))


lambda_2 <- plot_grid(lambda_Ma_2, lambda_Ta_2, lambda_TG_2, lambda_VN_2, ncol=4) 

ggsave("transm_rate_2.svg", plot=lambda_2, path=dirname(snakemake@output[["transm_rate_2"]]), width=408, height=144, units="mm")

