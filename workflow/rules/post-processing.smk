# Plot BDMM results

rule plot_bdmm:
    input:
        Ma_L1 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        Ma_L2 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        Ma_L3 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        Ma_L4 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        Ta_L1 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        Ta_L2 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        Ta_L3 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        Ta_L4 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        TG_L2 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        TG_L4 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        TG_L6 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        VN_L1 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        VN_L2 = "results/results/analyses/{method}/{analysis}/{analysis}.log",
        VN_L4 = "results/results/analyses/{method}/{analysis}/{analysis}.log",