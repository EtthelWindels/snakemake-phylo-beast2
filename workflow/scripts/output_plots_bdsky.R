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
parser$add_argument("--input_path", type="character", help="Path to input files") #analyses/BDSKY folder
parser$add_argument("--output_path", type="character", help="Path to output figures") #figures/BDSKY folder

args <- parser$parse_args()



# Read arguments ----------------------------------------------------------

# Malawi
LOGFILE_Ma_4_2 <- list.files(paste0(args$input_path,"/Malawi"), pattern="L4_2.log$", full.names=T)
LOGFILE_Ma_4_3 <- list.files(paste0(args$input_path,"/Malawi"), pattern="L4_3.log$", full.names=T)
LOGFILE_Ma_4_4 <- list.files(paste0(args$input_path,"/Malawi"), pattern="L4_4.log$", full.names=T)
LOGFILE_Ma_4_5 <- list.files(paste0(args$input_path,"/Malawi"), pattern="L4_5.log$", full.names=T)


# Tanzania
LOGFILE_Ta_3_2 <- list.files(paste0(args$input_path,"/Tanzania"), pattern="L3_2.log$", full.names=T)
LOGFILE_Ta_3_3 <- list.files(paste0(args$input_path,"/Tanzania"), pattern="L3_3.log$", full.names=T)
LOGFILE_Ta_3_4 <- list.files(paste0(args$input_path,"/Tanzania"), pattern="L3_4.log$", full.names=T)
LOGFILE_Ta_3_5 <- list.files(paste0(args$input_path,"/Tanzania"), pattern="L3_5.log$", full.names=T)

# The Gambia
LOGFILE_TG_4_2 <- list.files(paste0(args$input_path,"/TheGambia"), pattern="L4_2.log$", full.names=T)
LOGFILE_TG_4_3 <- list.files(paste0(args$input_path,"/TheGambia"), pattern="L4_3.log$", full.names=T)
LOGFILE_TG_4_4 <- list.files(paste0(args$input_path,"/TheGambia"), pattern="L4_4.log$", full.names=T)
LOGFILE_TG_4_5 <- list.files(paste0(args$input_path,"/TheGambia"), pattern="L4_5.log$", full.names=T)

# Vietnam
LOGFILE_VN_2_2 <- list.files(paste0(args$input_path,"/Vietnam"), pattern="L2_2.log$", full.names=T)
LOGFILE_VN_2_3 <- list.files(paste0(args$input_path,"/Vietnam"), pattern="L2_3.log$", full.names=T)
LOGFILE_VN_2_4 <- list.files(paste0(args$input_path,"/Vietnam"), pattern="L2_4.log$", full.names=T)
LOGFILE_VN_2_5 <- list.files(paste0(args$input_path,"/Vietnam"), pattern="L2_5.log$", full.names=T)

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

logfile_Ma_4_2 <- loadTrajectories(LOGFILE_Ma_4_2, burninFrac=0.1) %>%
              as.data.frame()
logfile_Ma_4_2$lambda1 <- logfile_Ma_4_2$birthRate.1
logfile_Ma_4_2$lambda2 <- logfile_Ma_4_2$birthRate.2

logfile_Ma_4_3 <- loadTrajectories(LOGFILE_Ma_4_3, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ma_4_3$lambda1 <- logfile_Ma_4_3$birthRate.1
logfile_Ma_4_3$lambda2 <- logfile_Ma_4_3$birthRate.2
logfile_Ma_4_3$lambda3 <- logfile_Ma_4_3$birthRate.3

logfile_Ma_4_4 <- loadTrajectories(LOGFILE_Ma_4_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ma_4_4$lambda1 <- logfile_Ma_4_4$birthRate.1
logfile_Ma_4_4$lambda2 <- logfile_Ma_4_4$birthRate.2
logfile_Ma_4_4$lambda3 <- logfile_Ma_4_4$birthRate.3
logfile_Ma_4_4$lambda4 <- logfile_Ma_4_4$birthRate.4

logfile_Ma_4_5 <- loadTrajectories(LOGFILE_Ma_4_5, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ma_4_5$lambda1 <- logfile_Ma_4_5$birthRate.1
logfile_Ma_4_5$lambda2 <- logfile_Ma_4_5$birthRate.2
logfile_Ma_4_5$lambda3 <- logfile_Ma_4_5$birthRate.3
logfile_Ma_4_5$lambda4 <- logfile_Ma_4_5$birthRate.4
logfile_Ma_4_5$lambda5 <- logfile_Ma_4_5$birthRate.5

# Tanzania

logfile_Ta_3_2 <- loadTrajectories(LOGFILE_Ta_3_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_3_2$lambda1 <- logfile_Ta_3_2$birthRate.1
logfile_Ta_3_2$lambda2 <- logfile_Ta_3_2$birthRate.2

logfile_Ta_3_3 <- loadTrajectories(LOGFILE_Ta_3_3, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_3_3$lambda1 <- logfile_Ta_3_3$birthRate.1
logfile_Ta_3_3$lambda2 <- logfile_Ta_3_3$birthRate.2
logfile_Ta_3_3$lambda3 <- logfile_Ta_3_3$birthRate.3

logfile_Ta_3_4 <- loadTrajectories(LOGFILE_Ta_3_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_3_4$lambda1 <- logfile_Ta_3_4$birthRate.1
logfile_Ta_3_4$lambda2 <- logfile_Ta_3_4$birthRate.2
logfile_Ta_3_4$lambda3 <- logfile_Ta_3_4$birthRate.3
logfile_Ta_3_4$lambda4 <- logfile_Ta_3_4$birthRate.4

logfile_Ta_3_5 <- loadTrajectories(LOGFILE_Ta_3_5, burninFrac=0.1) %>%
  as.data.frame()
logfile_Ta_3_5$lambda1 <- logfile_Ta_3_5$birthRate.1
logfile_Ta_3_5$lambda2 <- logfile_Ta_3_5$birthRate.2
logfile_Ta_3_5$lambda3 <- logfile_Ta_3_5$birthRate.3
logfile_Ta_3_5$lambda4 <- logfile_Ta_3_5$birthRate.4
logfile_Ta_3_5$lambda5 <- logfile_Ta_3_5$birthRate.5

# The Gambia

logfile_TG_4_2 <- loadTrajectories(LOGFILE_TG_4_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_TG_4_2$lambda1 <- logfile_TG_4_2$birthRate.1
logfile_TG_4_2$lambda2 <- logfile_TG_4_2$birthRate.2

logfile_TG_4_3 <- loadTrajectories(LOGFILE_TG_4_3, burninFrac=0.1) %>%
  as.data.frame()
logfile_TG_4_3$lambda1 <- logfile_TG_4_3$birthRate.1
logfile_TG_4_3$lambda2 <- logfile_TG_4_3$birthRate.2
logfile_TG_4_3$lambda3 <- logfile_TG_4_3$birthRate.3

logfile_TG_4_4 <- loadTrajectories(LOGFILE_TG_4_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_TG_4_4$lambda1 <- logfile_TG_4_4$birthRate.1
logfile_TG_4_4$lambda2 <- logfile_TG_4_4$birthRate.2
logfile_TG_4_4$lambda3 <- logfile_TG_4_4$birthRate.3
logfile_TG_4_4$lambda4 <- logfile_TG_4_4$birthRate.4

logfile_TG_4_5 <- loadTrajectories(LOGFILE_TG_4_5, burninFrac=0.1) %>%
  as.data.frame()
logfile_TG_4_5$lambda1 <- logfile_TG_4_5$birthRate.1
logfile_TG_4_5$lambda2 <- logfile_TG_4_5$birthRate.2
logfile_TG_4_5$lambda3 <- logfile_TG_4_5$birthRate.3
logfile_TG_4_5$lambda4 <- logfile_TG_4_5$birthRate.4
logfile_TG_4_5$lambda5 <- logfile_TG_4_5$birthRate.5

# Vietnam

logfile_VN_2_2 <- loadTrajectories(LOGFILE_VN_2_2, burninFrac=0.1) %>%
  as.data.frame()
logfile_VN_2_2$lambda1 <- logfile_VN_2_2$birthRate.1
logfile_VN_2_2$lambda2 <- logfile_VN_2_2$birthRate.2

logfile_VN_2_3 <- loadTrajectories(LOGFILE_VN_2_3, burninFrac=0.1) %>%
  as.data.frame()
logfile_VN_2_3$lambda1 <- logfile_VN_2_3$birthRate.1
logfile_VN_2_3$lambda2 <- logfile_VN_2_3$birthRate.2
logfile_VN_2_3$lambda3 <- logfile_VN_2_3$birthRate.3

logfile_VN_2_4 <- loadTrajectories(LOGFILE_VN_2_4, burninFrac=0.1) %>%
  as.data.frame()
logfile_VN_2_4$lambda1 <- logfile_VN_2_4$birthRate.1
logfile_VN_2_4$lambda2 <- logfile_VN_2_4$birthRate.2
logfile_VN_2_4$lambda3 <- logfile_VN_2_4$birthRate.3
logfile_VN_2_4$lambda4 <- logfile_VN_2_4$birthRate.4

logfile_VN_2_5 <- loadTrajectories(LOGFILE_VN_2_5, burninFrac=0.1) %>%
  as.data.frame()
logfile_VN_2_5$lambda1 <- logfile_VN_2_5$birthRate.1
logfile_VN_2_5$lambda2 <- logfile_VN_2_5$birthRate.2
logfile_VN_2_5$lambda3 <- logfile_VN_2_5$birthRate.3
logfile_VN_2_5$lambda4 <- logfile_VN_2_5$birthRate.4
logfile_VN_2_5$lambda5 <- logfile_VN_2_5$birthRate.5


# Plot posterior densities ------------------------------------------------

n_Ma <- dim(logfile_Ma_4_2)[1] + dim(logfile_Ma_4_3)[1] + dim(logfile_Ma_4_4)[1] + dim(logfile_Ma_4_5)[1] 
n_Ta <- dim(logfile_Ta_3_2)[1] + dim(logfile_Ta_3_3)[1] + dim(logfile_Ta_3_4)[1] + dim(logfile_Ta_3_5)[1] 
n_TG <- dim(logfile_TG_4_2)[1] + dim(logfile_TG_4_3)[1] + dim(logfile_TG_4_4)[1] + dim(logfile_TG_4_5)[1] 
n_VN <- dim(logfile_VN_2_2)[1] + dim(logfile_VN_2_3)[1] + dim(logfile_VN_2_4)[1] + dim(logfile_VN_2_5)[1] 

all_lin_2 <- data.frame(country=c(rep("Malawi",2*dim(logfile_Ma_4_2)[1]),rep("Tanzania",2*dim(logfile_Ta_3_2)[1]),rep("TheGambia",2*dim(logfile_TG_4_2)[1]),rep("Vietnam",2*dim(logfile_VN_2_2)[1])),
                      lineage=c(rep("L4",2*dim(logfile_Ma_4_2)[1]),rep("L3",2*dim(logfile_Ta_3_2)[1]),rep("L4",2*dim(logfile_TG_4_2)[1]),rep("L2",2*dim(logfile_VN_2_2)[1])),
                      epoch=c(rep("t1",dim(logfile_Ma_4_2)[1]),rep("t2",dim(logfile_Ma_4_2)[1]),rep("t1",dim(logfile_Ta_3_2)[1]),rep("t2",dim(logfile_Ta_3_2)[1]),rep("t1",dim(logfile_TG_4_2)[1]),rep("t2",dim(logfile_TG_4_2)[1]),rep("t1",dim(logfile_VN_2_2)[1]),rep("t2",dim(logfile_VN_2_2)[1])),
                      lambda=c(logfile_Ma_4_2$lambda1,logfile_Ma_4_2$lambda2,logfile_Ta_3_2$lambda1,logfile_Ta_3_2$lambda2,logfile_TG_4_2$lambda1,logfile_TG_4_2$lambda2,logfile_VN_2_2$lambda1,logfile_VN_2_2$lambda2))

all_lin_3 <- data.frame(country=c(rep("Malawi",3*dim(logfile_Ma_4_3)[1]),rep("Tanzania",3*dim(logfile_Ta_3_3)[1]),rep("TheGambia",3*dim(logfile_TG_4_3)[1]),rep("Vietnam",3*dim(logfile_VN_2_3)[1])),
                        lineage=c(rep("L4",3*dim(logfile_Ma_4_3)[1]),rep("L3",3*dim(logfile_Ta_3_3)[1]),rep("L4",3*dim(logfile_TG_4_3)[1]),rep("L2",3*dim(logfile_VN_2_3)[1])),
                        epoch=c(rep("t1",dim(logfile_Ma_4_3)[1]),rep("t2",dim(logfile_Ma_4_3)[1]),rep("t3",dim(logfile_Ma_4_3)[1]),rep("t1",dim(logfile_Ta_3_3)[1]),rep("t2",dim(logfile_Ta_3_3)[1]),rep("t3",dim(logfile_Ta_3_3)[1]),rep("t1",dim(logfile_TG_4_3)[1]),rep("t2",dim(logfile_TG_4_3)[1]),rep("t3",dim(logfile_TG_4_3)[1]),rep("t1",dim(logfile_VN_2_3)[1]),rep("t2",dim(logfile_VN_2_3)[1]),rep("t3",dim(logfile_VN_2_3)[1])),
                        lambda=c(logfile_Ma_4_3$lambda1,logfile_Ma_4_3$lambda2,logfile_Ma_4_3$lambda3,logfile_Ta_3_3$lambda1,logfile_Ta_3_3$lambda2,logfile_Ta_3_3$lambda3,logfile_TG_4_3$lambda1,logfile_TG_4_3$lambda2,logfile_TG_4_3$lambda3,logfile_VN_2_3$lambda1,logfile_VN_2_3$lambda2,logfile_VN_2_3$lambda3))

all_lin_4 <- data.frame(country=c(rep("Malawi",4*dim(logfile_Ma_4_4)[1]),rep("Tanzania",4*dim(logfile_Ta_3_4)[1]),rep("TheGambia",4*dim(logfile_TG_4_4)[1]),rep("Vietnam",4*dim(logfile_VN_2_4)[1])),
                        lineage=c(rep("L4",4*dim(logfile_Ma_4_4)[1]),rep("L3",4*dim(logfile_Ta_3_4)[1]),rep("L4",4*dim(logfile_TG_4_4)[1]),rep("L2",4*dim(logfile_VN_2_4)[1])),
                        epoch=c(rep("t1",dim(logfile_Ma_4_4)[1]),rep("t2",dim(logfile_Ma_4_4)[1]),rep("t3",dim(logfile_Ma_4_4)[1]),rep("t4",dim(logfile_Ma_4_4)[1]),rep("t1",dim(logfile_Ta_3_4)[1]),rep("t2",dim(logfile_Ta_3_4)[1]),rep("t3",dim(logfile_Ta_3_4)[1]),rep("t4",dim(logfile_Ta_3_4)[1]),rep("t1",dim(logfile_TG_4_4)[1]),rep("t2",dim(logfile_TG_4_4)[1]),rep("t3",dim(logfile_TG_4_4)[1]),rep("t4",dim(logfile_TG_4_4)[1]),rep("t1",dim(logfile_VN_2_4)[1]),rep("t2",dim(logfile_VN_2_4)[1]),rep("t3",dim(logfile_VN_2_4)[1]),rep("t4",dim(logfile_VN_2_4)[1])),
                        lambda=c(logfile_Ma_4_4$lambda1,logfile_Ma_4_4$lambda2,logfile_Ma_4_4$lambda3,logfile_Ma_4_4$lambda4,logfile_Ta_3_4$lambda1,logfile_Ta_3_4$lambda2,logfile_Ta_3_4$lambda3,logfile_Ta_3_4$lambda4,logfile_TG_4_4$lambda1,logfile_TG_4_4$lambda2,logfile_TG_4_4$lambda3,logfile_TG_4_4$lambda4,logfile_VN_2_4$lambda1,logfile_VN_2_4$lambda2,logfile_VN_2_4$lambda3,logfile_VN_2_4$lambda4))

all_lin_5 <- data.frame(country=c(rep("Malawi",5*dim(logfile_Ma_4_5)[1]),rep("Tanzania",5*dim(logfile_Ta_3_5)[1]),rep("TheGambia",5*dim(logfile_TG_4_5)[1]),rep("Vietnam",5*dim(logfile_VN_2_5)[1])),
                        lineage=c(rep("L4",5*dim(logfile_Ma_4_5)[1]),rep("L3",5*dim(logfile_Ta_3_5)[1]),rep("L4",5*dim(logfile_TG_4_5)[1]),rep("L2",5*dim(logfile_VN_2_5)[1])),
                        epoch=c(rep("t1",dim(logfile_Ma_4_5)[1]),rep("t2",dim(logfile_Ma_4_5)[1]),rep("t3",dim(logfile_Ma_4_5)[1]),rep("t4",dim(logfile_Ma_4_5)[1]),rep("t5",dim(logfile_Ma_4_5)[1]),rep("t1",dim(logfile_Ta_3_5)[1]),rep("t2",dim(logfile_Ta_3_5)[1]),rep("t3",dim(logfile_Ta_3_5)[1]),rep("t4",dim(logfile_Ta_3_5)[1]),rep("t5",dim(logfile_Ta_3_5)[1]),rep("t1",dim(logfile_TG_4_5)[1]),rep("t2",dim(logfile_TG_4_5)[1]),rep("t3",dim(logfile_TG_4_5)[1]),rep("t4",dim(logfile_TG_4_5)[1]),rep("t5",dim(logfile_TG_4_5)[1]),rep("t1",dim(logfile_VN_2_5)[1]),rep("t2",dim(logfile_VN_2_5)[1]),rep("t3",dim(logfile_VN_2_5)[1]),rep("t4",dim(logfile_VN_2_5)[1]),rep("t5",dim(logfile_VN_2_5)[1])),
                        lambda=c(logfile_Ma_4_5$lambda1,logfile_Ma_4_5$lambda2,logfile_Ma_4_5$lambda3,logfile_Ma_4_5$lambda4,logfile_Ma_4_5$lambda5,logfile_Ta_3_5$lambda1,logfile_Ta_3_5$lambda2,logfile_Ta_3_5$lambda3,logfile_Ta_3_5$lambda4,logfile_Ta_3_5$lambda5,logfile_TG_4_5$lambda1,logfile_TG_4_5$lambda2,logfile_TG_4_5$lambda3,logfile_TG_4_5$lambda4,logfile_TG_4_5$lambda5,logfile_VN_2_5$lambda1,logfile_VN_2_5$lambda2,logfile_VN_2_5$lambda3,logfile_VN_2_5$lambda4,logfile_VN_2_5$lambda5))



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


# 3 time intervals

lambda_Ma_3 <- ggplot(all_lin_3[all_lin_3$country=="Malawi",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Malawi"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3'),values=c('#c08168ff','#c08168ff','#c08168ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3'),values=c('#c08168ff','#c08168ff','#c08168ff'))

lambda_Ta_3 <- ggplot(all_lin_3[all_lin_3$country=="Tanzania",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Tanzania"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3'),values=c('#bfcbdbff','#bfcbdbff','#bfcbdbff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3'),values=c('#bfcbdbff','#bfcbdbff','#bfcbdbff'))

lambda_TG_3 <- ggplot(all_lin_3[all_lin_3$country=="TheGambia",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("The Gambia"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3'),values=c('#c08168ff','#c08168ff','#c08168ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3'),values=c('#c08168ff','#c08168ff','#c08168ff'))

lambda_VN_3 <- ggplot(all_lin_3[all_lin_3$country=="Vietnam",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Vietnam"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3'),values=c('#8a96a3ff','#8a96a3ff','#8a96a3ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3'),values=c('#8a96a3ff','#8a96a3ff','#8a96a3ff'))

# 4 time intervals

lambda_Ma_4 <- ggplot(all_lin_4[all_lin_4$country=="Malawi",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Malawi"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4'),values=c('#c08168ff','#c08168ff','#c08168ff','#c08168ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4'),values=c('#c08168ff','#c08168ff','#c08168ff','#c08168ff'))

lambda_Ta_4 <- ggplot(all_lin_4[all_lin_4$country=="Tanzania",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Tanzania"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4'),values=c('#bfcbdbff','#bfcbdbff','#bfcbdbff','#bfcbdbff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4'),values=c('#bfcbdbff','#bfcbdbff','#bfcbdbff','#bfcbdbff'))

lambda_TG_4 <- ggplot(all_lin_4[all_lin_4$country=="TheGambia",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("The Gambia"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4'),values=c('#c08168ff','#c08168ff','#c08168ff','#c08168ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4'),values=c('#c08168ff','#c08168ff','#c08168ff','#c08168ff'))

lambda_VN_4 <- ggplot(all_lin_4[all_lin_4$country=="Vietnam",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Vietnam"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4'),values=c('#8a96a3ff','#8a96a3ff','#8a96a3ff','#8a96a3ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4'),values=c('#8a96a3ff','#8a96a3ff','#8a96a3ff','#8a96a3ff'))

# 5 time intervals

lambda_Ma_5 <- ggplot(all_lin_5[all_lin_5$country=="Malawi",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Malawi"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4','time interval 5'),values=c('#c08168ff','#c08168ff','#c08168ff','#c08168ff','#c08168ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4','time interval 5'),values=c('#c08168ff','#c08168ff','#c08168ff','#c08168ff','#c08168ff'))

lambda_Ta_5 <- ggplot(all_lin_5[all_lin_5$country=="Tanzania",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Tanzania"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4','time interval 5'),values=c('#bfcbdbff','#bfcbdbff','#bfcbdbff','#bfcbdbff','#bfcbdbff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4','time interval 5'),values=c('#bfcbdbff','#bfcbdbff','#bfcbdbff','#bfcbdbff','#bfcbdbff'))

lambda_TG_5 <- ggplot(all_lin_5[all_lin_5$country=="TheGambia",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("The Gambia"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4','time interval 5'),values=c('#c08168ff','#c08168ff','#c08168ff','#c08168ff','#c08168ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4','time interval 5'),values=c('#c08168ff','#c08168ff','#c08168ff','#c08168ff','#c08168ff'))

lambda_VN_5 <- ggplot(all_lin_5[all_lin_5$country=="Vietnam",], aes(epoch, y=lambda, fill=epoch, colour=epoch)) +
  geom_violin(stat='ydensity',alpha=0.5, show.legend = FALSE)+
  labs(title=expression(atop(bold("Vietnam"))), x="Transmission rate", y='Posterior density')+ 
  theme_classic() +
  theme(axis.text.x = element_text(hjust=0.5, size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size=18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        plot.title = element_text(size=25, hjust=0.5)) +
  # xlim(0,1.5)+
  scale_fill_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4','time interval 5'),values=c('#8a96a3ff','#8a96a3ff','#8a96a3ff','#8a96a3ff','#8a96a3ff'))+
  scale_colour_manual(labels=c('time interval 1','time interval 2','time interval 3','time interval 4','time interval 5'),values=c('#8a96a3ff','#8a96a3ff','#8a96a3ff','#8a96a3ff','#8a96a3ff'))





lambda_2 <- plot_grid(lambda_Ma_2, lambda_Ta_2, lambda_TG_2, lambda_VN_2, ncol=4) 
lambda_3 <- plot_grid(lambda_Ma_3, lambda_Ta_3, lambda_TG_3, lambda_VN_3, ncol=4) 
lambda_4 <- plot_grid(lambda_Ma_4, lambda_Ta_4, lambda_TG_4, lambda_VN_4, ncol=4) 
lambda_5 <- plot_grid(lambda_Ma_5, lambda_Ta_5, lambda_TG_5, lambda_VN_5, ncol=4) 


ggsave("lambda_2.png", plot=lambda_2, path=OUTPUT_PATH, width=408, height=144, units="mm")
ggsave("lambda_3.png", plot=lambda_3, path=OUTPUT_PATH, width=408, height=144, units="mm")
ggsave("lambda_4.png", plot=lambda_4, path=OUTPUT_PATH, width=408, height=144, units="mm")
ggsave("lambda_5.png", plot=lambda_5, path=OUTPUT_PATH, width=408, height=144, units="mm")
