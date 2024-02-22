# Plot posterior parameter distributions

# BDMM results

def _get_all_bdmm_logs(wildcards):
    files = expand(
        "results/analyses/{{method}}/{analysis}/{analysis}.log",
        analysis = [a for a in config["run"][wildcards.method] if _get_model_analysis(wildcards,a) == "BDMM"])
    return files

rule plot_bdmm:
    input:
        input_logs = _get_all_bdmm_logs
    output:
        Re = "results/figures/bdmm/{method}/Re.png",
        infperiod = "results/figures/bdmm/{method}/infperiod.png",
        latentperiod = "results/figures/bdmm/{method}/latentperiod.png",
        infperiodtot = "results/figures/bdmm/{method}/infperiodtot.png",
        transm_rate = "results/figures/bdmm/{method}/transm_rate.png"
    script:
        "../scripts/parameter_plots_bdmm_violin.R"


# BD results

def _get_all_bd_logs(wildcards):
    files = expand(
        "results/analyses/{{method}}/{analysis}/{analysis}.log",
        analysis = [a for a in config["run"][wildcards.method] if _get_model_analysis(wildcards,a) == "BD"])
    return files

rule plot_bd:
    input:
        input_logs = _get_all_bd_logs
    output:
        Re = "results/figures/bd/{method}/Re.png",
        infperiod = "results/figures/bd/{method}/infperiod.png",
        transm_rate = "results/figures/bd/{method}/transm_rate.png"
    script:
        "../scripts/parameter_plots_bd_violin.R"        


# BD_v2 results

def _get_all_bd_v2_logs(wildcards):
    files = expand(
        "results/analyses/{{method}}/{analysis}/{analysis}.log",
        analysis = [a for a in config["run"][wildcards.method] if _get_model_analysis(wildcards,a) == "BD_v2"])
    return files

rule plot_bd_v2:
    input:
        input_logs = _get_all_bd_v2_logs
    output:
        Re = "results/figures/bd_v2/{method}/Re.png",
        infperiod = "results/figures/bd_v2/{method}/infperiod.png",
        transm_rate = "results/figures/bd_v2/{method}/transm_rate.png"
    script:
        "../scripts/parameter_plots_bd_v2_violin.R"        


# BDSKY results

def _get_all_bdsky_logs(wildcards):
    files = expand(
        "results/analyses/{{method}}/{analysis}/{analysis}.log",
        analysis = [a for a in config["run"][wildcards.method] if _get_model_analysis(wildcards,a) == "BDSKY"])
    return files

rule plot_bdsky:
    input:
        input_logs = _get_all_bdsky_logs
    output:
        transm_rate_2 = "results/figures/bdsky/{method}/transm_rate_2.png",
    script:
        "../scripts/parameter_plots_bdsky.R"


# BDMM-BDSKY results

def _get_all_bdmmbdsky_logs(wildcards):
    files = expand(
        "results/analyses/{{method}}/{analysis}/{analysis}.log",
        analysis = [a for a in config["run"][wildcards.method] if _get_model_analysis(wildcards,a) == "BDMM_BDSKY"])
    return files

rule plot_bdmm_bdsky:
    input:
        input_logs = _get_all_bdmmbdsky_logs
    output:
        Re = "results/figures/bdmm_bdsky/{method}/Re.png",
        infperiod = "results/figures/bdmm_bdsky/{method}/infperiod.png",
        latentperiod = "results/figures/bdmm_bdsky/{method}/latentperiod.png",
        infperiodtot = "results/figures/bdmm_bdsky/{method}/infperiodtot.png",
        transm_rate = "results/figures/bdmm_bdsky/{method}/transm_rate.png"
    script:
        "../scripts/parameter_plots_bdmm_bdsky_violin.R"              


# BDMM-BDSKY (fixed Re) results

def _get_all_bdmmbdsky_fRe_logs(wildcards):
    files = expand(
        "results/analyses/{{method}}/{analysis}/{analysis}.log",
        analysis = [a for a in config["run"][wildcards.method] if _get_model_analysis(wildcards,a) == "BDMM_BDSKY_fRe"])
    return files

rule plot_bdmm_bdsky_fRe:
    input:
        input_logs = _get_all_bdmmbdsky_fRe_logs
    output:
        infperiod = "results/figures/bdmm_bdsky_fRe/{method}/infperiod.png",
        latentperiod = "results/figures/bdmm_bdsky_fRe/{method}/latentperiod.png",
        infperiodtot = "results/figures/bdmm_bdsky_fRe/{method}/infperiodtot.png",
        transm_rate = "results/figures/bdmm_bdsky_fRe/{method}/transm_rate.png"
    script:
        "../scripts/parameter_plots_bdmm_bdsky_fixedRe_violin.R"     


# BDMM_INV results

def _get_all_bdmm_inv_logs(wildcards):
    files = expand(
        "results/analyses/{{method}}/{analysis}/{analysis}.log",
        analysis = [a for a in config["run"][wildcards.method] if _get_model_analysis(wildcards,a) == "BDMM_INV"])
    return files

rule plot_bdmm_inv:
    input:
        input_logs = _get_all_bdmm_inv_logs
    output:
        Re = "results/figures/bdmm_inverse/{method}/Re.png",
        infperiod = "results/figures/bdmm_inverse/{method}/infperiod.png",
        latentperiod = "results/figures/bdmm_inverse/{method}/latentperiod.png",
        infperiodtot = "results/figures/bdmm_inverse/{method}/infperiodtot.png",
        transm_rate = "results/figures/bdmm_inverse/{method}/transm_rate.png"
    script:
        "../scripts/parameter_plots_bdmm_inverse_violin.R"


# BDMM_SEL results

def _get_all_bdmm_sel_logs(wildcards):
    files = expand(
        "results/analyses/{{method}}/{analysis}/{analysis}.log",
        analysis = [a for a in config["run"][wildcards.method] if _get_model_analysis(wildcards,a) == "BDMM_SEL"])
    return files

rule plot_bdmm_sel:
    input:
        input_logs = _get_all_bdmm_sel_logs
    output:
        Re = "results/figures/bdmm_modelselection/{method}/Re.png",
        infperiod = "results/figures/bdmm_modelselection/{method}/infperiod.png",
        latentperiod = "results/figures/bdmm_modelselection/{method}/latentperiod.png",
        infperiodtot = "results/figures/bdmm_modelselection/{method}/infperiodtot.png",
        transm_rate = "results/figures/bdmm_modelselection/{method}/transm_rate.png",
        BF = "results/figures/bdmm_modelselection/{method}/BF.png"
    script:
        "../scripts/parameter_plots_bdmm_modelselection_violin.R"