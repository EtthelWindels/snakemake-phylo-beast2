# phylodynamics

rule beast:
    input:
        alignment = "results/data/{dataset}/aligned{sufix,.*}.fasta",
        xml = lambda wildcards: _get_analysis_param(wildcards, "beast", "xml")
    output:
        trace = "results/analysis/beast/{analysis}/chains/{dataset}{sufix,.*}.{chain}.log",
        trees = "results/analysis/beast/{analysis}/chains/{dataset}{sufix,.*}.{chain}.trees",
    params:
        beast_command = lambda wildcards: _get_analysis_param(wildcards, "beast", "command"), 
        action = lambda wildcards: _get_analysis_param(wildcards, "beast", "action"),
        xml_params = lambda wildcards: str(_get_analysis_param(wildcards, "beast", "xml_params")).replace(":", "=").replace(
            "{", "\"").replace("}", "\"").replace(" ", "").replace("'", ""),
        folder_name = "results/analysis/beast/{analysis}/chains",
        file_name = "{dataset}{sufix,.*}.{chain}",
    log:
        "logs/beast_{analysis}_{dataset}_{sufix,.*}_{chain}.txt"
    # benchmark:
    #     "benchmarks/beast_{dataset}_{analysis}_{subsampling}.{dseed}.{bseed}.benchmark.txt"
    threads:
        lambda wildcards: _get_analysis_param(wildcards, "beast", "threads"),
    resources:
        runtime = lambda wildcards: _get_analysis_param(wildcards, "beast", "time"),
        mem_mb = lambda wildcards: _get_analysis_param(wildcards, "beast", "mem_mb")
    shell:
        """
        {params.beast_command} \
            -D aligned_fasta={input.alignment} \
            -D {params.xml_params} \
            -D file_name={params.folder_name}/temp/{params.file_name} \
            -seed {wildcards.chain} \
            -statefile "{params.folder_name}/{params.file_name}.state" \
            -{params.action} {input.xml} 2>&1 | tee -a {log}

        [ -f {params.folder_name}/temp/{params.file_name}.log ] && mv {params.folder_name}/temp/{params.file_name}.log {output.trace}
        [ -f {params.folder_name}/temp/{params.file_name}.trees ] && mv {params.folder_name}/temp/{params.file_name}.trees {output.trees} 
        
        """




        # """
        # if {params.action}==resume
        #     if test -f "{params.folder_name}/{params.file_name}.state" && test -f "{params.folder_name}/{params.file_name}.log  && test -f "{params.folder_name}/{params.file_name}.trees; then
        #         ACTION={params.action}
        #         scp {output.trace} {params.folder_name}/{params.file_name}.log 
        #         scp {output.trees} {params.folder_name}/{params.file_name}.trees
        #     else
        #         printf '%s\n' "Resumin" >&2error no state log or trees
        #         exit 1
        # fi

        # mkdir -p {params.folder_name}
        
        # {params.beast_command} \
        #     -D aligned_fasta={input.aln} \
        #     -D {params.model_params} \
        #     -D file_name={params.folder_name}/temp/{params.file_name} \
        #     -seed {wildcards.bseed} \
        #     -statefile "{params.folder_name}/{params.file_name}.state" \
        #     -java -{params.action} {input.xml} 2>&1 | tee -a {log}
        
        # [ -f {params.folder_name}/temp/{params.file_name}.log ] && mv {params.folder_name}/temp/{params.file_name}.log {output.trace}
        # [ -f {params.folder_name}/temp/{params.file_name}.trees ] && mv {params.folder_name}/temp/{params.file_name}.trees {output.trees} 
        # """


def _get_chains(wildcards):
    files = expand(
        "results/analysis/beast/{{analysis}}/chains/{{dataset}}{{sufix,.*}}.{chain}.{{output}}",
        chain = range(1, _get_analysis_param(wildcards, "beast", "chains") + 1))
    return files

rule combine_chains:
    message: 
        """
        Combine chain files: {input.chain_files} with LogCombiner.
        """
    input:
        chain_files = _get_chains  
    output:
        combined_chain = "results/analysis/beast/{analysis}/{dataset}{sufix,.*}.{output}",
        # combined_chai2n = "results/analysis/beast/{analysis}/{dataset}{sufix,.*}.trees",
    # log:
    #     "logs/combine_trace_{dataset}_{analysis}_{subsampling}.{dseed}.txt"
    # benchmark:
    #     "benchmarks/combine_trace_{dataset}_{analysis}_{subsampling}.{dseed}.benchmark.txt"
    params:
        burnin =  lambda wildcards: _get_analysis_param(wildcards, "beast", "burnin"),
        input_command = lambda wildcards, input: " -log ".join(input) 
    shell:
        """
        logcombiner -log {params.input_command} -o {output.combined_chain} -b {params.burnin}  2>&1 | tee -a {log}
        """

# rule combine_trees:
#     message: 
#         """
#         Combine trace files: {input.trace_files} with LogCombiner v1.8.2.
#         """
#     input:
#         trace_files = _get_trace_tocombine    
#     output:
#         combined_trees = "results/analysis/beast/{analysis}/{dataset}{sufix,.*}.trees",
#     # log:
#     #     "logs/combine_trace_{dataset}_{analysis}_{subsampling}.{dseed}.txt"
#     # benchmark:
#     #     "benchmarks/combine_trace_{dataset}_{analysis}_{subsampling}.{dseed}.benchmark.txt"
#     params:
#         burnin =  lambda wildcards: _get_analysis_param(wildcards, "beast", "burnin"),
#         input_command = lambda wildcards, input: " -log ".join(input) 
#     shell:
#         """
#         logcombiner -log {params.input_command} -o {output.combined_trace} -b {params.burnin}  2>&1 | tee -a {log}
#         """

# def _get_typedtrees_tocombine(wildcards):
#     files = expand(
#         "results/{{dataset}}/beast/{{analysis}}/chains/{{subsampling}}.{{dseed}}.{bseed}.f.typed.node.trees",
#         bseed = BEAST_SEED)
#     return files

# rule combine_typedtrees:
#     message: 
#         """
#         Combine typed tree files: {input.tree_files} with LogCombiner v1.8.2.
#         """
#     input:
#         tree_files = _get_typedtrees_tocombine    
#     output:
#         combined_typedtrees = "results/{dataset}/beast/{analysis}/{subsampling}.{dseed}.comb.typed.node.trees"
#     log:
#         "logs/combine_typedtrees_{dataset}_{analysis}_{subsampling}.{dseed}.txt"
#     benchmark:
#         "benchmarks/combine_typedtree_{dataset}_{analysis}_{subsampling}.{dseed}.benchmark.txt"
#     params:
#         burnin = lambda wildcards: config["beast"][wildcards.analysis].get("burnin") or config["beast"].get("burnin"),
#         input_command = lambda wildcards, input: " -log ".join(input) 
#     shell:
#         """
#         logcombiner -log {params.input_command} -o {output.combined_typedtrees} -b {params.burnin}  2>&1 | tee -a {log}
#         """

# rule summarize_typedtrees:
#     message: 
#         """
#         Summarize trees to Maximum clade credibility tree with median node heights with TreeAnnotator.
#         """
#     input:
#         combined_trees = rules.combine_typedtrees.output.combined_typedtrees
#     output:
#         summary_tree = "results/{dataset}/beast/{analysis}/{subsampling}.{dseed}.comb.mcc.typed.node.tree"
#     log:
#         "logs/summarise_typedtrees_{dataset}_{analysis}_{subsampling}.{dseed}.txt"
#     benchmark:
#         "benchmarks/summarise_typedtree_{dataset}_{analysis}_{subsampling}.{dseed}.benchmark.txt"
#     params:
#         burnin = 0,
#         heights = "median"
#     shell:
#         """
#         treeannotator -heights {params.heights} -b {params.burnin} -lowMem {input.combined_trees} {output.summary_tree} 2>&1 | tee -a {log} 
#         """
