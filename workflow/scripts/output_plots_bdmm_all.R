## ------------------------------------------------------------------------
## Plot posterior densities inferred with BEAST
## 2023-08-24 Etthel Windels
## ------------------------------------------------------------------------



# Load libraries ----------------------------------------------------------

suppressMessages(suppressWarnings(require(argparse)))
suppressMessages(suppressWarnings(require(ggplot2)))
suppressMessages(suppressWarnings(require(dplyr)))
suppressMessages(suppressWarnings(require(stringr)))
suppressMessages(suppressWarnings(require(cowplot)))



# Parser ------------------------------------------------------------------

parser <- argparse::ArgumentParser()
parser$add_argument("--input_path", type="character", help="Path to input files")
parser$add_argument("--output_path", type="character", help="Path to output figures")

args <- parser$parse_args()



# Read arguments ----------------------------------------------------------

# Malawi
LOGFILE_Ma_1 <- list.files(paste0(args$input_path,"/Malawi"), pattern="L1.log$", full.names=T)
LOGFILE_Ma_2 <- list.files(paste0(args$input_path,"/Malawi"), pattern="L2.log$", full.names=T)
LOGFILE_Ma_3 <- list.files(paste0(args$input_path,"/Malawi"), pattern="L3.log$", full.names=T)
LOGFILE_Ma_4 <- list.files(paste0(args$input_path,"/Malawi"), pattern="L4.log$", full.names=T)

# Tanzania
LOGFILE_Ta_1 <- list.files(paste0(args$input_path,"/Tanzania"), pattern="L1.log$", full.names=T)
LOGFILE_Ta_2 <- list.files(paste0(args$input_path,"/Tanzania"), pattern="L2.log$", full.names=T)
LOGFILE_Ta_3 <- list.files(paste0(args$input_path,"/Tanzania"), pattern="L3.log$", full.names=T)
LOGFILE_Ta_4 <- list.files(paste0(args$input_path,"/Tanzania"), pattern="L4.log$", full.names=T)

# The Gambia
LOGFILE_TG_2 <- list.files(paste0(args$input_path,"/TheGambia"), pattern="L2.log$", full.names=T)
LOGFILE_TG_4 <- list.files(paste0(args$input_path,"/TheGambia"), pattern="L4.log$", full.names=T)
LOGFILE_TG_6 <- list.files(paste0(args$input_path,"/TheGambia"), pattern="L6.log$", full.names=T)

# Vietnam
LOGFILE_VN_1 <- list.files(paste0(args$input_path,"/Vietnam"), pattern="L1.log$", full.names=T)
LOGFILE_VN_2 <- list.files(paste0(args$input_path,"/Vietnam"), pattern="L2.log$", full.names=T)
LOGFILE_VN_4 <- list.files(paste0(args$input_path,"/Vietnam"), pattern="L4.log$", full.names=T)

OUTPUT_PATH <- args$output_path



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
logfile_Ma_1$bUR <- logfile_Ma_1$becomeUninfectiousRate.2
logfile_Ma_1$inf_period <- 1/logfile_Ma_1$bUR
logfile_Ma_1$Re <- logfile_Ma_1$R0AmongDemes.2
logfile_Ma_1$lambda <- logfile_Ma_1$Re*logfile_Ma_1$bUR 
logfile_Ma_1$migr <- logfile_Ma_1$rateMatrix.1
logfile_Ma_1$latent_period <- 1/logfile_Ma_1$migr
logfile_Ma_1$inf_period_tot <- logfile_Ma_1$latent_period + logfile_Ma_1$inf_period

logfile_Ma_2 <- loadTrajectories(LOGFILE_Ma_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ma_2$bUR <- logfile_Ma_2$becomeUninfectiousRate.2
logfile_Ma_2$inf_period <- 1/logfile_Ma_2$bUR
logfile_Ma_2$Re <- logfile_Ma_2$R0AmongDemes.2
logfile_Ma_2$lambda <- logfile_Ma_2$Re*logfile_Ma_2$bUR 
logfile_Ma_2$migr <- logfile_Ma_2$rateMatrix.1
logfile_Ma_2$latent_period <- 1/logfile_Ma_2$migr
logfile_Ma_2$inf_period_tot <- logfile_Ma_2$latent_period + logfile_Ma_2$inf_period

logfile_Ma_3 <- loadTrajectories(LOGFILE_Ma_3, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ma_3$bUR <- logfile_Ma_3$becomeUninfectiousRate.2
logfile_Ma_3$inf_period <- 1/logfile_Ma_3$bUR
logfile_Ma_3$Re <- logfile_Ma_3$R0AmongDemes.2
logfile_Ma_3$lambda <- logfile_Ma_3$Re*logfile_Ma_3$bUR 
logfile_Ma_3$migr <- logfile_Ma_3$rateMatrix.1
logfile_Ma_3$latent_period <- 1/logfile_Ma_3$migr
logfile_Ma_3$inf_period_tot <- logfile_Ma_3$latent_period + logfile_Ma_3$inf_period

logfile_Ma_4 <- loadTrajectories(LOGFILE_Ma_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ma_4$bUR <- logfile_Ma_4$becomeUninfectiousRate.2
logfile_Ma_4$inf_period <- 1/logfile_Ma_4$bUR
logfile_Ma_4$Re <- logfile_Ma_4$R0AmongDemes.2
logfile_Ma_4$lambda <- logfile_Ma_4$Re*logfile_Ma_4$bUR 
logfile_Ma_4$migr <- logfile_Ma_4$rateMatrix.1
logfile_Ma_4$latent_period <- 1/logfile_Ma_4$migr
logfile_Ma_4$inf_period_tot <- logfile_Ma_4$latent_period + logfile_Ma_4$inf_period

# Tanzania

logfile_Ta_1 <- loadTrajectories(LOGFILE_Ta_1, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_1$bUR <- logfile_Ta_1$becomeUninfectiousRate.2
logfile_Ta_1$inf_period <- 1/logfile_Ta_1$bUR
logfile_Ta_1$Re <- logfile_Ta_1$R0AmongDemes.2
logfile_Ta_1$lambda <- logfile_Ta_1$Re*logfile_Ta_1$bUR 
logfile_Ta_1$migr <- logfile_Ta_1$rateMatrix.1
logfile_Ta_1$latent_period <- 1/logfile_Ta_1$migr
logfile_Ta_1$inf_period_tot <- logfile_Ta_1$latent_period + logfile_Ta_1$inf_period

logfile_Ta_2 <- loadTrajectories(LOGFILE_Ta_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_2$bUR <- logfile_Ta_2$becomeUninfectiousRate.2
logfile_Ta_2$inf_period <- 1/logfile_Ta_2$bUR
logfile_Ta_2$Re <- logfile_Ta_2$R0AmongDemes.2
logfile_Ta_2$lambda <- logfile_Ta_2$Re*logfile_Ta_2$bUR 
logfile_Ta_2$migr <- logfile_Ta_2$rateMatrix.1
logfile_Ta_2$latent_period <- 1/logfile_Ta_2$migr
logfile_Ta_2$inf_period_tot <- logfile_Ta_2$latent_period + logfile_Ta_2$inf_period

logfile_Ta_3 <- loadTrajectories(LOGFILE_Ta_3, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_3$bUR <- logfile_Ta_3$becomeUninfectiousRate.2
logfile_Ta_3$inf_period <- 1/logfile_Ta_3$bUR
logfile_Ta_3$Re <- logfile_Ta_3$R0AmongDemes.2
logfile_Ta_3$lambda <- logfile_Ta_3$Re*logfile_Ta_3$bUR 
logfile_Ta_3$migr <- logfile_Ta_3$rateMatrix.1
logfile_Ta_3$latent_period <- 1/logfile_Ta_3$migr
logfile_Ta_3$inf_period_tot <- logfile_Ta_3$latent_period + logfile_Ta_3$inf_period

logfile_Ta_4 <- loadTrajectories(LOGFILE_Ta_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_4$bUR <- logfile_Ta_4$becomeUninfectiousRate.2
logfile_Ta_4$inf_period <- 1/logfile_Ta_4$bUR
logfile_Ta_4$Re <- logfile_Ta_4$R0AmongDemes.2
logfile_Ta_4$lambda <- logfile_Ta_4$Re*logfile_Ta_4$bUR 
logfile_Ta_4$migr <- logfile_Ta_4$rateMatrix.1
logfile_Ta_4$latent_period <- 1/logfile_Ta_4$migr
logfile_Ta_4$inf_period_tot <- logfile_Ta_4$latent_period + logfile_Ta_4$inf_period

# The Gambia

logfile_TG_2 <- loadTrajectories(LOGFILE_TG_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_TG_2$bUR <- logfile_TG_2$becomeUninfectiousRate.2
logfile_TG_2$inf_period <- 1/logfile_TG_2$bUR
logfile_TG_2$Re <- logfile_TG_2$R0AmongDemes.2
logfile_TG_2$lambda <- logfile_TG_2$Re*logfile_TG_2$bUR 
logfile_TG_2$migr <- logfile_TG_2$rateMatrix.1
logfile_TG_2$latent_period <- 1/logfile_TG_2$migr
logfile_TG_2$inf_period_tot <- logfile_TG_2$latent_period + logfile_TG_2$inf_period

logfile_TG_4 <- loadTrajectories(LOGFILE_TG_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_TG_4$bUR <- logfile_TG_4$becomeUninfectiousRate.2
logfile_TG_4$inf_period <- 1/logfile_TG_4$bUR
logfile_TG_4$Re <- logfile_TG_4$R0AmongDemes.2
logfile_TG_4$lambda <- logfile_TG_4$Re*logfile_TG_4$bUR 
logfile_TG_4$migr <- logfile_TG_4$rateMatrix.1
logfile_TG_4$latent_period <- 1/logfile_TG_4$migr
logfile_TG_4$inf_period_tot <- logfile_TG_4$latent_period + logfile_TG_4$inf_period

logfile_TG_6 <- loadTrajectories(LOGFILE_TG_6, burninFrac=0.1) %>%
  as.data.frame()
logfile_TG_6$bUR <- logfile_TG_6$becomeUninfectiousRate.2
logfile_TG_6$inf_period <- 1/logfile_TG_6$bUR
logfile_TG_6$Re <- logfile_TG_6$R0AmongDemes.2
logfile_TG_6$lambda <- logfile_TG_6$Re*logfile_TG_6$bUR 
logfile_TG_6$migr <- logfile_TG_6$rateMatrix.1
logfile_TG_6$latent_period <- 1/logfile_TG_6$migr
logfile_TG_6$inf_period_tot <- logfile_TG_6$latent_period + logfile_TG_6$inf_period

# Vietnam

logfile_VN_1 <- loadTrajectories(LOGFILE_VN_1, burninFrac=0.1) %>%
  as.data.frame()
logfile_VN_1$bUR <- logfile_VN_1$becomeUninfectiousRate.2
logfile_VN_1$inf_period <- 1/logfile_VN_1$bUR
logfile_VN_1$Re <- logfile_VN_1$R0AmongDemes.2
logfile_VN_1$lambda <- logfile_VN_1$Re*logfile_VN_1$bUR 
logfile_VN_1$migr <- logfile_VN_1$rateMatrix.1
logfile_VN_1$latent_period <- 1/logfile_VN_1$migr
logfile_VN_1$inf_period_tot <- logfile_VN_1$latent_period + logfile_VN_1$inf_period

logfile_VN_2 <- loadTrajectories(LOGFILE_VN_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_VN_2$bUR <- logfile_VN_2$becomeUninfectiousRate.2
logfile_VN_2$inf_period <- 1/logfile_VN_2$bUR
logfile_VN_2$Re <- logfile_VN_2$R0AmongDemes.2
logfile_VN_2$lambda <- logfile_VN_2$Re*logfile_VN_2$bUR 
logfile_VN_2$migr <- logfile_VN_2$rateMatrix.1
logfile_VN_2$latent_period <- 1/logfile_VN_2$migr
logfile_VN_2$inf_period_tot <- logfile_VN_2$latent_period + logfile_VN_2$inf_period

logfile_VN_4 <- loadTrajectories(LOGFILE_VN_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_VN_4$bUR <- logfile_VN_4$becomeUninfectiousRate.2
logfile_VN_4$inf_period <- 1/logfile_VN_4$bUR
logfile_VN_4$Re <- logfile_VN_4$R0AmongDemes.2
logfile_VN_4$lambda <- logfile_VN_4$Re*logfile_VN_4$bUR 
logfile_VN_4$migr <- logfile_VN_4$rateMatrix.1
logfile_VN_4$latent_period <- 1/logfile_VN_4$migr
logfile_VN_4$inf_period_tot <- logfile_VN_4$latent_period + logfile_VN_4$inf_period


# Plot posterior densities ------------------------------------------------

n_Ma <- dim(logfile_Ma_1)[1] + dim(logfile_Ma_2)[1] + dim(logfile_Ma_3)[1] + dim(logfile_Ma_4)[1] 
n_Ta <- dim(logfile_Ta_1)[1] + dim(logfile_Ta_2)[1] + dim(logfile_Ta_3)[1] + dim(logfile_Ta_4)[1] 
n_TG <- dim(logfile_TG_2)[1] + dim(logfile_TG_4)[1] + dim(logfile_TG_6)[1] 
n_VN <- dim(logfile_VN_1)[1] + dim(logfile_VN_2)[1] + dim(logfile_VN_4)[1] 

all_lin <- data.frame(country=c(rep("Malawi",n_Ma),rep("Tanzania",n_Ta),rep("TheGambia",n_TG),rep("Vietnam",n_VN)),
                      lineage=c(rep("L1",dim(logfile_Ma_1)[1]), rep("L2",dim(logfile_Ma_2)[1]), rep("L3",dim(logfile_Ma_3)[1]), rep("L4",dim(logfile_Ma_4)[1]),rep("L1",dim(logfile_Ta_1)[1]), rep("L2",dim(logfile_Ta_2)[1]), rep("L3",dim(logfile_Ta_3)[1]), rep("L4",dim(logfile_Ta_4)[1]),rep("L2",dim(logfile_TG_2)[1]), rep("L4",dim(logfile_TG_4)[1]), rep("L6",dim(logfile_TG_6)[1]),rep("L1",dim(logfile_VN_1)[1]), rep("L2",dim(logfile_VN_2)[1]), rep("L4",dim(logfile_VN_4)[1])),
                      Re=c(logfile_Ma_1$Re, logfile_Ma_2$Re, logfile_Ma_3$Re, logfile_Ma_4$Re,logfile_Ta_1$Re, logfile_Ta_2$Re, logfile_Ta_3$Re, logfile_Ta_4$Re, logfile_TG_2$Re, logfile_TG_4$Re, logfile_TG_6$Re, logfile_VN_1$Re, logfile_VN_2$Re, logfile_VN_4$Re),
                      inf_period=c(logfile_Ma_1$inf_period, logfile_Ma_2$inf_period, logfile_Ma_3$inf_period, logfile_Ma_4$inf_period,logfile_Ta_1$inf_period, logfile_Ta_2$inf_period, logfile_Ta_3$inf_period, logfile_Ta_4$inf_period, logfile_TG_2$inf_period, logfile_TG_4$inf_period, logfile_TG_6$inf_period, logfile_VN_1$inf_period, logfile_VN_2$inf_period, logfile_VN_4$inf_period),
                      latent_period=c(logfile_Ma_1$latent_period, logfile_Ma_2$latent_period, logfile_Ma_3$latent_period, logfile_Ma_4$latent_period,logfile_Ta_1$latent_period, logfile_Ta_2$latent_period, logfile_Ta_3$latent_period, logfile_Ta_4$latent_period, logfile_TG_2$latent_period, logfile_TG_4$latent_period, logfile_TG_6$latent_period, logfile_VN_1$latent_period, logfile_VN_2$latent_period, logfile_VN_4$latent_period),
                      inf_period_tot=c(logfile_Ma_1$inf_period_tot, logfile_Ma_2$inf_period_tot, logfile_Ma_3$inf_period_tot, logfile_Ma_4$inf_period_tot,logfile_Ta_1$inf_period_tot, logfile_Ta_2$inf_period_tot, logfile_Ta_3$inf_period_tot, logfile_Ta_4$inf_period_tot, logfile_TG_2$inf_period_tot, logfile_TG_4$inf_period_tot, logfile_TG_6$inf_period_tot, logfile_VN_1$inf_period_tot, logfile_VN_2$inf_period_tot, logfile_VN_4$inf_period_tot),
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
  xlim(0,2.5)+
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
  xlim(0,2.5)+
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
  xlim(0,2.5)+
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
    xlim(0,2.5)+
  scale_fill_manual(labels=c('L1','L2','L4'),values=c('#f4b79fff','#8a96a3ff','#c08168ff'))+
  scale_colour_manual(labels=c('L1','L2','L4'),values=c('#f4b79fff','#8a96a3ff','#c08168ff'))

latentperiod_Ma <- ggplot(all_lin[all_lin$country=="Malawi",], aes(latent_period, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Malawi"))), x="Infected uninfectious period", y='Posterior density')+ 
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

latentperiod_Ta <- ggplot(all_lin[all_lin$country=="Tanzania",], aes(latent_period, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Tanzania"))), x="Infected uninfectious period", y='Posterior density')+ 
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

latentperiod_TG <- ggplot(all_lin[all_lin$country=="TheGambia",], aes(latent_period, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("The Gambia"))), x="Infected uninfectious period", y='Posterior density')+ 
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

latentperiod_VN <- ggplot(all_lin[all_lin$country=="Vietnam",], aes(latent_period, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Vietnam"))), x="Infected uninfectious period", y='Posterior density')+ 
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


infperiodtot_Ma <- ggplot(all_lin[all_lin$country=="Malawi",], aes(inf_period_tot, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Malawi"))), x="Total infected period", y='Posterior density')+ 
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

infperiodtot_Ta <- ggplot(all_lin[all_lin$country=="Tanzania",], aes(inf_period_tot, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Tanzania"))), x="Total infected period", y='Posterior density')+ 
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

infperiodtot_TG <- ggplot(all_lin[all_lin$country=="TheGambia",], aes(inf_period_tot, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("The Gambia"))), x="Total infected period", y='Posterior density')+ 
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

infperiodtot_VN <- ggplot(all_lin[all_lin$country=="Vietnam",], aes(inf_period_tot, fill=lineage, colour=lineage)) +
  geom_density(stat='density',alpha=0.5)+
  labs(title=expression(atop(bold("Vietnam"))), x="Total infected period", y='Posterior density')+ 
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
latentperiod <- plot_grid(latentperiod_Ma, latentperiod_Ta, latentperiod_TG, latentperiod_VN, ncol=4) 
infperiodtot <- plot_grid(infperiodtot_Ma, infperiodtot_Ta, infperiodtot_TG, infperiodtot_VN, ncol=4) 
lambda <- plot_grid(lambda_Ma, lambda_Ta, lambda_TG, lambda_VN, ncol=4) 


ggsave("Re.png", plot=Re, path=OUTPUT_PATH, width=408, height=144, units="mm")
ggsave("infperiod.png", plot=infperiod, path=OUTPUT_PATH, width=408, height=144, units="mm")
ggsave("latentperiod.png", plot=latentperiod, path=OUTPUT_PATH, width=408, height=144, units="mm")
ggsave("infperiodtot.png", plot=infperiodtot, path=OUTPUT_PATH, width=408, height=144, units="mm")
ggsave("lambda.png", plot=lambda, path=OUTPUT_PATH, width=408, height=144, units="mm")
