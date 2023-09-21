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
        Re = "results/figures/bdmm/{method}/Re.svg",
        infperiod = "results/figures/bdmm/{method}/infperiod.svg",
        latentperiod = "results/figures/bdmm/{method}/latentperiod.svg",
        infperiodtot = "results/figures/bdmm/{method}/infperiodtot.svg",
        transm_rate = "results/figures/bdmm/{method}/transm_rate.svg"
    script:
        "../scripts/parameter_plots_bdmm.R"


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
        Re = "results/figures/bd/{method}/Re.svg",
        infperiod = "results/figures/bd/{method}/infperiod.svg",
        transm_rate = "results/figures/bd/{method}/transm_rate.svg"
    script:
        "../scripts/parameter_plots_bd.R"        
        

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
        transm_rate_2 = "results/figures/bdsky/{method}/transm_rate_2.svg",
    script:
        "../scripts/parameter_plots_bdsky.R"      