## ------------------------------------------------------------------------
## Plot posterior densities inferred with BEAST
## 2023-08-24 Etthel Windels
## ------------------------------------------------------------------------



# Load libraries ----------------------------------------------------------

library(ggplot2)
library(dplyr)
library(stringr)
library(cowplot)



# Read input --------------------------------------------------------------

# Malawi
LOGFILE_Ma_1 <- snakemake@input[[1]]
LOGFILE_Ma_2 <- snakemake@input[[2]]
LOGFILE_Ma_3 <- snakemake@input[[3]]
LOGFILE_Ma_4 <- snakemake@input[[4]]

# Tanzania
LOGFILE_Ta_1 <- snakemake@input[[5]]
LOGFILE_Ta_2 <- snakemake@input[[6]]
LOGFILE_Ta_3 <- snakemake@input[[7]]
LOGFILE_Ta_4 <- snakemake@input[[8]]

# The Gambia
LOGFILE_TG_2 <- snakemake@input[[9]]
LOGFILE_TG_4 <- snakemake@input[[10]]
LOGFILE_TG_6 <- snakemake@input[[11]]

# Vietnam
LOGFILE_VN_1 <- snakemake@input[[12]]
LOGFILE_VN_2 <- snakemake@input[[13]]
LOGFILE_VN_4 <- snakemake@input[[14]]



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

logfile_Ma_1 <- loadTrajectories(LOGFILE_Ma_1, burninFrac=0.1) %>%
              as.data.frame()
logfile_Ma_1$lambda <- logfile_Ma_1$birthRate
logfile_Ma_1$bUR <- logfile_Ma_1$deathRate
logfile_Ma_1$inf_period <- 1/logfile_Ma_1$bUR
logfile_Ma_1$Re <- logfile_Ma_1$lambda/logfile_Ma_1$bUR

logfile_Ma_2 <- loadTrajectories(LOGFILE_Ma_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ma_2$lambda <- logfile_Ma_2$birthRate
logfile_Ma_2$bUR <- logfile_Ma_2$deathRate
logfile_Ma_2$inf_period <- 1/logfile_Ma_2$bUR
logfile_Ma_2$Re <- logfile_Ma_2$lambda/logfile_Ma_2$bUR

logfile_Ma_3 <- loadTrajectories(LOGFILE_Ma_3, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ma_3$lambda <- logfile_Ma_3$birthRate
logfile_Ma_3$bUR <- logfile_Ma_3$deathRate
logfile_Ma_3$inf_period <- 1/logfile_Ma_3$bUR
logfile_Ma_3$Re <- logfile_Ma_3$lambda/logfile_Ma_3$bUR

logfile_Ma_4 <- loadTrajectories(LOGFILE_Ma_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ma_4$lambda <- logfile_Ma_4$birthRate
logfile_Ma_4$bUR <- logfile_Ma_4$deathRate
logfile_Ma_4$inf_period <- 1/logfile_Ma_4$bUR
logfile_Ma_4$Re <- logfile_Ma_4$lambda/logfile_Ma_4$bUR


# Tanzania

logfile_Ta_1 <- loadTrajectories(LOGFILE_Ta_1, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_1$lambda <- logfile_Ta_1$birthRate
logfile_Ta_1$bUR <- logfile_Ta_1$deathRate
logfile_Ta_1$inf_period <- 1/logfile_Ta_1$bUR
logfile_Ta_1$Re <- logfile_Ta_1$lambda/logfile_Ta_1$bUR

logfile_Ta_2 <- loadTrajectories(LOGFILE_Ta_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_2$lambda <- logfile_Ta_2$birthRate
logfile_Ta_2$bUR <- logfile_Ta_2$deathRate
logfile_Ta_2$inf_period <- 1/logfile_Ta_2$bUR
logfile_Ta_2$Re <- logfile_Ta_2$lambda/logfile_Ta_2$bUR

logfile_Ta_3 <- loadTrajectories(LOGFILE_Ta_3, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_3$lambda <- logfile_Ta_3$birthRate
logfile_Ta_3$bUR <- logfile_Ta_3$deathRate
logfile_Ta_3$inf_period <- 1/logfile_Ta_3$bUR
logfile_Ta_3$Re <- logfile_Ta_3$lambda/logfile_Ta_3$bUR

logfile_Ta_4 <- loadTrajectories(LOGFILE_Ta_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_4$lambda <- logfile_Ta_4$birthRate
logfile_Ta_4$bUR <- logfile_Ta_4$deathRate
logfile_Ta_4$inf_period <- 1/logfile_Ta_4$bUR
logfile_Ta_4$Re <- logfile_Ta_4$lambda/logfile_Ta_4$bUR


# The Gambia

logfile_TG_2 <- loadTrajectories(LOGFILE_TG_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_TG_2$lambda <- logfile_TG_2$birthRate
logfile_TG_2$bUR <- logfile_TG_2$deathRate
logfile_TG_2$inf_period <- 1/logfile_TG_2$bUR
logfile_TG_2$Re <- logfile_TG_2$lambda/logfile_TG_2$bUR

logfile_TG_4 <- loadTrajectories(LOGFILE_TG_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_TG_4$lambda <- logfile_TG_4$birthRate
logfile_TG_4$bUR <- logfile_TG_4$deathRate
logfile_TG_4$inf_period <- 1/logfile_TG_4$bUR
logfile_TG_4$Re <- logfile_TG_4$lambda/logfile_TG_4$bUR

logfile_TG_6 <- loadTrajectories(LOGFILE_TG_6, burninFrac=0.1) %>%
  as.data.frame()
logfile_TG_6$lambda <- logfile_TG_6$birthRate
logfile_TG_6$bUR <- logfile_TG_6$deathRate
logfile_TG_6$inf_period <- 1/logfile_TG_6$bUR
logfile_TG_6$Re <- logfile_TG_6$lambda/logfile_TG_6$bUR


# Vietnam

logfile_VN_1 <- loadTrajectories(LOGFILE_VN_1, burninFrac=0.1) %>%
  as.data.frame()
logfile_VN_1$lambda <- logfile_VN_1$birthRate
logfile_VN_1$bUR <- logfile_VN_1$deathRate
logfile_VN_1$inf_period <- 1/logfile_VN_1$bUR
logfile_VN_1$Re <- logfile_VN_1$lambda/logfile_VN_1$bUR

logfile_VN_2 <- loadTrajectories(LOGFILE_VN_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_VN_2$lambda <- logfile_VN_2$birthRate
logfile_VN_2$bUR <- logfile_VN_2$deathRate
logfile_VN_2$inf_period <- 1/logfile_VN_2$bUR
logfile_VN_2$Re <- logfile_VN_2$lambda/logfile_VN_2$bUR

logfile_VN_4 <- loadTrajectories(LOGFILE_VN_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_VN_4$lambda <- logfile_VN_4$birthRate
logfile_VN_4$bUR <- logfile_VN_4$deathRate
logfile_VN_4$inf_period <- 1/logfile_VN_4$bUR
logfile_VN_4$Re <- logfile_VN_4$lambda/logfile_VN_4$bUR


# Plot posterior densities ------------------------------------------------

n_Ma <- dim(logfile_Ma_1)[1] + dim(logfile_Ma_2)[1] + dim(logfile_Ma_3)[1] + dim(logfile_Ma_4)[1] 
n_Ta <- dim(logfile_Ta_1)[1] + dim(logfile_Ta_2)[1] + dim(logfile_Ta_3)[1] + dim(logfile_Ta_4)[1] 
n_TG <- dim(logfile_TG_2)[1] + dim(logfile_TG_4)[1] + dim(logfile_TG_6)[1] 
n_VN <- dim(logfile_VN_1)[1] + dim(logfile_VN_2)[1] + dim(logfile_VN_4)[1] 

all_lin <- data.frame(country=c(rep("Malawi",n_Ma),rep("Tanzania",n_Ta),rep("TheGambia",n_TG),rep("Vietnam",n_VN)),
                      lineage=c(rep("L1",dim(logfile_Ma_1)[1]), rep("L2",dim(logfile_Ma_2)[1]), rep("L3",dim(logfile_Ma_3)[1]), rep("L4",dim(logfile_Ma_4)[1]),rep("L1",dim(logfile_Ta_1)[1]), rep("L2",dim(logfile_Ta_2)[1]), rep("L3",dim(logfile_Ta_3)[1]), rep("L4",dim(logfile_Ta_4)[1]),rep("L2",dim(logfile_TG_2)[1]), rep("L4",dim(logfile_TG_4)[1]), rep("L6",dim(logfile_TG_6)[1]),rep("L1",dim(logfile_VN_1)[1]), rep("L2",dim(logfile_VN_2)[1]), rep("L4",dim(logfile_VN_4)[1])),
                      Re=c(logfile_Ma_1$Re, logfile_Ma_2$Re, logfile_Ma_3$Re, logfile_Ma_4$Re,logfile_Ta_1$Re, logfile_Ta_2$Re, logfile_Ta_3$Re, logfile_Ta_4$Re, logfile_TG_2$Re, logfile_TG_4$Re, logfile_TG_6$Re, logfile_VN_1$Re, logfile_VN_2$Re, logfile_VN_4$Re),
                      inf_period=c(logfile_Ma_1$inf_period, logfile_Ma_2$inf_period, logfile_Ma_3$inf_period, logfile_Ma_4$inf_period,logfile_Ta_1$inf_period, logfile_Ta_2$inf_period, logfile_Ta_3$inf_period, logfile_Ta_4$inf_period, logfile_TG_2$inf_period, logfile_TG_4$inf_period, logfile_TG_6$inf_period, logfile_VN_1$inf_period, logfile_VN_2$inf_period, logfile_VN_4$inf_period),
                      lambda=c(logfile_Ma_1$lambda, logfile_Ma_2$lambda, logfile_Ma_3$lambda, logfile_Ma_4$lambda,logfile_Ta_1$lambda, logfile_Ta_2$lambda, logfile_Ta_3$lambda, logfile_Ta_4$lambda,logfile_TG_2$lambda, logfile_TG_4$lambda, logfile_TG_6$lambda, logfile_VN_1$lambda, logfile_VN_2$lambda, logfile_VN_4$lambda))

Re_Ma <- ggplot(all_lin[all_lin$country=="Malawi",], aes(Re, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Malawi"))), x=expression(R[e]), y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
  xlim(0,1.5)+
  scale_fill_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))+
  scale_colour_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))

Re_Ta <- ggplot(all_lin[all_lin$country=="Tanzania",], aes(Re, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Tanzania"))), x=expression(R[e]), y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
  xlim(0,1.5)+
  scale_fill_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))+
  scale_colour_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))

Re_TG <- ggplot(all_lin[all_lin$country=="TheGambia",], aes(Re, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("The Gambia"))), x=expression(R[e]), y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
  xlim(0,1.5)+
  scale_fill_manual(labels=c('L2','L4','L6'),values=c('#8a96a3ff','#c08168ff','moccasin'))+
  scale_colour_manual(labels=c('L2','L4','L6'),values=c('#8a96a3ff','#c08168ff','moccasin'))

Re_VN <- ggplot(all_lin[all_lin$country=="Vietnam",], aes(Re, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Vietnam"))), x=expression(R[e]), y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
  #  xlim(0,1.5)+
  scale_fill_manual(labels=c('L1','L2','L4'),values=c('#f4b79fff','#8a96a3ff','#c08168ff'))+
  scale_colour_manual(labels=c('L1','L2','L4'),values=c('#f4b79fff','#8a96a3ff','#c08168ff'))


infperiod_Ma <- ggplot(all_lin[all_lin$country=="Malawi",], aes(inf_period, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Malawi"))), x="Infectious period", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
 # xlim(0,1.5)+
  scale_fill_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))+
  scale_colour_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))

infperiod_Ta <- ggplot(all_lin[all_lin$country=="Tanzania",], aes(inf_period, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Tanzania"))), x="Infectious period", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
  #xlim(0,1.5)+
  scale_fill_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))+
  scale_colour_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))

infperiod_TG <- ggplot(all_lin[all_lin$country=="TheGambia",], aes(inf_period, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("The Gambia"))), x="Infectious period", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
#  xlim(0,1.5)+
  scale_fill_manual(labels=c('L2','L4','L6'),values=c('#8a96a3ff','#c08168ff','moccasin'))+
  scale_colour_manual(labels=c('L2','L4','L6'),values=c('#8a96a3ff','#c08168ff','moccasin'))

infperiod_VN <- ggplot(all_lin[all_lin$country=="Vietnam",], aes(inf_period, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Vietnam"))), x="Infectious period", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
  #  xlim(0,1.5)+
  scale_fill_manual(labels=c('L1','L2','L4'),values=c('#f4b79fff','#8a96a3ff','#c08168ff'))+
  scale_colour_manual(labels=c('L1','L2','L4'),values=c('#f4b79fff','#8a96a3ff','#c08168ff'))


lambda_Ma <- ggplot(all_lin[all_lin$country=="Malawi",], aes(lambda, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Malawi"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))+
  scale_colour_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))

lambda_Ta <- ggplot(all_lin[all_lin$country=="Tanzania",], aes(lambda, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Tanzania"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
  #xlim(0,1.5)+
  scale_fill_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))+
  scale_colour_manual(labels=c('L1','L2','L3','L4'),values=c('#f4b79fff','#8a96a3ff','#bfcbdbff','#c08168ff'))

lambda_TG <- ggplot(all_lin[all_lin$country=="TheGambia",], aes(lambda, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("The Gambia"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
  #  xlim(0,1.5)+
  scale_fill_manual(labels=c('L2','L4','L6'),values=c('#8a96a3ff','#c08168ff','moccasin'))+
  scale_colour_manual(labels=c('L2','L4','L6'),values=c('#8a96a3ff','#c08168ff','moccasin'))

lambda_VN <- ggplot(all_lin[all_lin$country=="Vietnam",], aes(lambda, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Vietnam"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        legend.title = element_blank(),
        legend.text = element_text(size=14),
        plot.title = element_text(size=25, hjust=0.5)) +
  #  xlim(0,1.5)+
  scale_fill_manual(labels=c('L1','L2','L4'),values=c('#f4b79fff','#8a96a3ff','#c08168ff'))+
  scale_colour_manual(labels=c('L1','L2','L4'),values=c('#f4b79fff','#8a96a3ff','#c08168ff'))


Re <- plot_grid(Re_Ma, Re_Ta, Re_TG, Re_VN, ncol=4) 
infperiod <- plot_grid(infperiod_Ma, infperiod_Ta, infperiod_TG, infperiod_VN, ncol=4) 
lambda <- plot_grid(lambda_Ma, lambda_Ta, lambda_TG, lambda_VN, ncol=4) 


ggsave("Re.png", plot=Re, path=dirname(snakemake@output[["Re"]]), width=408, height=144, units="mm")
ggsave("infperiod.png", plot=infperiod, path=dirname(snakemake@output[["infperiod"]]), width=408, height=144, units="mm")
ggsave("transm_rate.png", plot=lambda, path=dirname(snakemake@output[["transm_rate"]]), width=408, height=144, units="mm")
