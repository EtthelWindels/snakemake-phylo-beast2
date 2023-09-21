# Phylodynamics

rule beast:
    input:
        alignment = lambda wildcards: "".join(["data/alignments","/",_get_analysis_param(wildcards, "dataset"),"/",_get_analysis_param(wildcards, "dataset"),"_beast.fasta"]),
        xml = lambda wildcards: _get_analysis_param(wildcards, "xml")
    output:
        trace = "results/analyses/{method}/{analysis}/chains/{analysis}.{chain,[0-9]+}.log",
        trees = "results/analyses/{method}/{analysis}/chains/{analysis}.{chain,[0-9]+}.trees"
    params:
        beast_command = lambda wildcards: _get_analysis_param(wildcards, "command"), 
        action = lambda wildcards: _get_analysis_param(wildcards,"action"),
        xml_params = lambda wildcards: str(_get_analysis_param(wildcards, "xml_params")).replace(":", "=").replace("{", "\"").replace("}", "\"").replace(" ", "").replace("'", ""),
        folder_name = "results/analyses/{method}/{analysis}/chains",
        file_name = "{analysis}.{chain,[0-9]+}"
    log:
        "logs/{method}_{analysis}_{chain,[0-9]+}.txt"
    benchmark:
        "benchmarks/{method}_{analysis}_{chain,[0-9]+}.benchmark.txt"
    threads:
        lambda wildcards: _get_analysis_param(wildcards, "threads"),
    resources:
       runtime = lambda wildcards: _get_analysis_param(wildcards, "time"),
       mem_mb = lambda wildcards: _get_analysis_param(wildcards, "mem_mb")
    shell:
        """
        mkdir -p {params.folder_name}/temp

        {params.beast_command} \
            -D aligned_fasta={input.alignment}  \
            -D {params.xml_params} \
            -D file_name={params.folder_name}/temp/{params.file_name} \
            -seed {wildcards.chain} \
            -statefile "{params.folder_name}/{params.file_name}.state" \
            -{params.action} {input.xml} 2>&1 | tee -a {log}       
        
        [ -f {params.folder_name}/temp/{params.file_name}.log ] && mv {params.folder_name}/temp/{params.file_name}.log {output.trace}  
        [ -f {params.folder_name}/temp/{params.file_name}.trees ] && mv {params.folder_name}/temp/{params.file_name}.trees {output.trees} 

        """
        # (temporary log file created to enable "resume" without deleting file)


def _get_chains(wildcards):
    files = expand(
        "results/analyses/{{method}}/{{analysis}}/chains/{{analysis}}.{chain}.log",
        chain = range(1, _get_analysis_param(wildcards, "chains") + 1))
    return files


rule combine_chains:
    message: 
        """
        Combine chain files: {input.chain_files} with LogCombiner.
        """
    input:
        chain_files = _get_chains  
    output:
        combined_chain = "results/analyses/{method}/{analysis}/{analysis}.log"
    log:
        "logs/combine_trace_{method}_{analysis}.txt"
    benchmark:
        "benchmarks/combine_trace_{method}_{analysis}.benchmark.txt"
    params:
        burnin =  lambda wildcards: _get_analysis_param(wildcards, "burnin"),
        input_command = lambda wildcards, input: " -log ".join(input) 
    shell:
        """
        logcombiner -log {params.input_command} -o {output.combined_chain} -b {params.burnin}  2>&1 | tee -a {log} 
        """


def _get_trees(wildcards):
    files = expand(
        "results/analyses/{{method}}/{{analysis}}/chains/{{analysis}}.{chain}.trees",
        chain = range(1, _get_analysis_param(wildcards, "chains") + 1))
    return files


rule combine_trees:
    message: 
        """
        Combine trace files: {input.trees_files} with LogCombiner v1.8.2.
        """
    input:
        trees_files = _get_trees    
    output:
        combined_trees = "results/analyses/{method}/{analysis}/{analysis}.trees"
    log:
        "logs/combine_trees_{method}_{analysis}.txt"
    benchmark:
        "benchmarks/combine_trees_{method}_{analysis}.benchmark.txt"
    params:
        burnin =  lambda wildcards: _get_analysis_param(wildcards, "burnin"),
        input_command = lambda wildcards, input: " -log ".join(input) 
    shell:
        """
        logcombiner -log {params.input_command} -o {output.combined_trees} -b {params.burnin}  2>&1 | tee -a {log}
        """