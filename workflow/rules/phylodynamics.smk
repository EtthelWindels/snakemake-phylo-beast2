# Phylodynamics     

# with runs variable

# checkpoint beast:
#     input:
#         alignment = lambda wildcards: "".join(["data/alignments","/",_get_analysis_param(wildcards, "dataset"),"/",_get_analysis_param(wildcards, "dataset"),"_beast.fasta"]),
#         xml = lambda wildcards: _get_analysis_param(wildcards, "xml"),
#     output:
#         trace = "results/analyses/{method}/{analysis}/chains/{analysis}.{chain}.r{i}.log",
#         trees = "results/analyses/{method}/{analysis}/chains/{analysis}.{chain}.r{i}.trees",
#         is_converged = "results/analyses/{method}/{analysis}/chains/is_converged_{analysis}.{chain}.r{i}.txt"
#     params:
#         beast_command = lambda wildcards: _get_analysis_param(wildcards, "command"), 
#         action = lambda wildcards: _get_analysis_param(wildcards, "action"),
#         user_check = lambda wildcards: _get_analysis_param(wildcards, "user_check"),
#         xml_params = lambda wildcards: str(_get_analysis_param(wildcards, "xml_params")).replace(":", "=").replace(
#             "{", "\"").replace("}", "\"").replace(" ", "").replace("'", ""),
#         folder_name = "results/analyses/{method}/{analysis}/chains",
#         file_name = "{analysis}.{chain}.r{i}",
#         state_file = "{analysis}.{chain}.state",
#         previous_file_name = lambda wildcards: wildcards.analysis + "." + wildcards.chain + ".r" + str(int(wildcards.i) - 1) if wildcards.i != 0 else wildcards.analysis + "." + wildcards.chain + ".r{i}"
#     log:
#         "logs/{method}_{analysis}_{chain}.r{i}.txt"
#     benchmark:
#         "benchmarks/{method}_{analysis}_{chain}.r{i}.benchmark.txt"
#     threads:
#         lambda wildcards: _get_analysis_param(wildcards, "threads"),
#     resources:
#         runtime = lambda wildcards: _get_analysis_param(wildcards, "time"),
#         mem_per_cpu = lambda wildcards: _get_analysis_param(wildcards, "mem_per_cpu")
#     shell:
#         """
#         mkdir -p {params.folder_name}/running
        
#         if [ {wildcards.i} == 0 ]; then
            
#             if [ {params.action} == "resume" ]; then
#                 ACTION="resume"
#             else
#                 ACTION="overwrite"
#             fi
            
#         else
#             ACTION="resume"
#             scp {params.folder_name}/{params.previous_file_name}.log {params.folder_name}/running/{params.file_name}.log 
#             scp {params.folder_name}/{params.previous_file_name}.trees {params.folder_name}/running/{params.file_name}.trees

#             rm {params.folder_name}/{params.previous_file_name}.log {params.folder_name}/{params.previous_file_name}.trees {params.folder_name}/is_converged_{params.previous_file_name}.txt
#         fi

#         # TODO Add message to only run user check for several chains and analyses in cluster with parallel job submission

#         if [ {params.user_check} == True ]; then
#             echo NO > {output.is_converged}
#         else
#             echo YES > {output.is_converged}
#         fi

#         {params.beast_command} \
#             -D aligned_fasta={input.alignment} \
#             -D {params.xml_params} \
#             -D file_name={params.folder_name}/running/{params.file_name} \
#             -seed {wildcards.chain} \
#             -statefile "{params.folder_name}/{params.state_file}" \
#             -$ACTION {input.xml} 2>&1 | tee -a {log}
        
#         # We need the chains to be written in a different path than snakemake output so snakemake does not delete them if job fails
#         # So we moved them once they are finished
#         [ -f {params.folder_name}/running/{params.file_name}.log ] && mv {params.folder_name}/running/{params.file_name}.log {output.trace}
#         [ -f {params.folder_name}/running/{params.file_name}.trees ] && mv {params.folder_name}/running/{params.file_name}.trees {output.trees} 
#         """

# runs = 0
# def _is_converged(wildcards):
#     global runs
#     with checkpoints.beast.get(method = wildcards.method, analysis = wildcards.analysis, chain = wildcards.chain, i = runs).output.is_converged.open() as f:
#         s = f.read().strip()
#         if s == "YES":
#             return "results/analyses/{method}/{analysis}/chains/{analysis}.{chain}.r" + str(runs) + ".{output}"
#         elif s == "NO":
#             runs += 1
#             checkpoints.beast.get(method= wildcards.method, analysis = wildcards.analysis, chain = wildcards.chain, i = runs)

# rule aggregate_runs:
#     input:
#         run = _is_converged 
#     output:
#         chain = "results/analyses/{method}/{analysis}/chains/{analysis}.{chain}.{output}",
#     shell:
#         """
#         mv {input.run} {output.chain} 2>&1 | tee -a {log}
#         """





rule beast:
    input:
        alignment = lambda wildcards: "".join(["data/alignments","/",_get_analysis_param(wildcards, "dataset"),"/",_get_analysis_param(wildcards, "dataset"),"_beast.fasta"]),
        xml = lambda wildcards: _get_analysis_param(wildcards, "xml"),
    output:
        trace = "results/analyses/{method}/{analysis}/chains/{analysis}.{chain}.log",
        trees = "results/analyses/{method}/{analysis}/chains/{analysis}.{chain}.trees",
       # is_converged = "results/analyses/{method}/{analysis}/chains/is_converged_{analysis}.{chain}.txt"
    params:
        beast_command = lambda wildcards: _get_analysis_param(wildcards, "command"), 
        action = lambda wildcards: _get_analysis_param(wildcards, "action"),
        user_check = lambda wildcards: _get_analysis_param(wildcards, "user_check"),
        xml_params = lambda wildcards: str(_get_analysis_param(wildcards, "xml_params")).replace(":", "=").replace(
            "{", "\"").replace("}", "\"").replace(" ", "").replace("'", ""),
        folder_name = "results/analyses/{method}/{analysis}/chains",
        file_name = "{analysis}.{chain}",
        state_file = "{analysis}.{chain}.state",
        #previous_file_name = lambda wildcards: wildcards.analysis + "." + wildcards.chain + ".r" + str(int(wildcards.i) - 1) if wildcards.i != 0 else wildcards.analysis + "." + wildcards.chain + ".r{i}"
    log:
        "logs/{method}_{analysis}_{chain}.txt"
    benchmark:
        "benchmarks/{method}_{analysis}_{chain}.benchmark.txt"
    threads:
        lambda wildcards: _get_analysis_param(wildcards, "threads"),
    resources:
        runtime = lambda wildcards: _get_analysis_param(wildcards, "time"),
        mem_per_cpu = lambda wildcards: _get_analysis_param(wildcards, "mem_per_cpu")
    shell:
        """
        mkdir -p {params.folder_name}/running
        
        # for resuming, make sure the files are in the running folder

        {params.beast_command} \
            -D aligned_fasta={input.alignment} \
            -D {params.xml_params} \
            -D file_name={params.folder_name}/running/{params.file_name} \
            -seed {wildcards.chain} \
            -statefile "{params.folder_name}/{params.state_file}" \
            -{params.action} {input.xml} 2>&1 | tee -a {log}
        
        # We need the chains to be written in a different path than snakemake output so snakemake does not delete them if job fails
        # So we moved them once they are finished
        [ -f {params.folder_name}/running/{params.file_name}.log ] && mv {params.folder_name}/running/{params.file_name}.log {output.trace}
        [ -f {params.folder_name}/running/{params.file_name}.trees ] && mv {params.folder_name}/running/{params.file_name}.trees {output.trees} 
        """


def _get_chains(wildcards):
    files = expand(
        "results/analyses/{{method}}/{{analysis}}/chains/{{analysis}}.{chain}.{{output}}",
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
        combined_chain = "results/analyses/{method}/{analysis}/{analysis}.{output}",
    params:
        burnin =  lambda wildcards: _get_analysis_param(wildcards, "burnin"),
        resample =  lambda wildcards: _get_analysis_param(wildcards, "resample"),
        input_command = lambda wildcards, input: " -log ".join(input) 
    resources:
        mem_per_cpu = 4096
    shell:
        """
        logcombiner -log {params.input_command} -o {output.combined_chain} -b {params.burnin}  -resample {params.resample} 2>&1 | tee -a {log}
        """

