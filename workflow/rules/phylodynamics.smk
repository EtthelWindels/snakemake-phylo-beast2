# phylodynamics


def _get_beast_param(param, wildcards):
    return config["beast"][wildcards.analysis].get(param) or config["beast"].get(param)

def _get_mrs(wildcards):
    ids = pd.read_csv("results/" + wildcards.dataset + "/data/ids_" + wildcards.subsampling + "." + wildcards.dseed + ".tsv", sep = '\t')
    dates = ids['seq_name'].str.split("|", expand=True)[2]
    return max(dates)

rule beast:
    """
    Running BEAST2 analysis {wildcards.analysis} BDMM-Prime, MCMC chain {wildcards.bseed}, subsample {wildcards.subsampling} {wildcards.dseed}.
    """
    input:
        alignment = _get_alignment,
        ids = rules.combine_subsamples.output.combined,
        xml = lambda wildcards: config["beast"][wildcards.analysis]["xml"],
    output:
        trace = "results/{dataset}/beast/{analysis}/chains/{subsampling}.{dseed}.{bseed}.f.log",
        trees = "results/{dataset}/beast/{analysis}/chains/{subsampling}.{dseed}.{bseed}.f.trees",
        typed_trees = "results/{dataset}/beast/{analysis}/chains/{subsampling}.{dseed}.{bseed}.typed.node.f.trees"
    params:
        length = lambda wildcards: _get_beast_param("length", wildcards),
        logevery = lambda wildcards: round(_get_beast_param("length", wildcards) / 10000),
        action = lambda wildcards: _get_beast_param("action", wildcards),
        demes = lambda wildcards: ",".join(list(config["data"][wildcards.dataset].keys())),
        n_types = lambda wildcards: len(config["data"][wildcards.dataset].keys()),
        mrs = lambda wildcards: _get_mrs(wildcards),
        model_params = lambda wildcards: str(_get_beast_param("model_params", wildcards)).replace(":", "=").replace(
            "{", "\"").replace("}", "\"").replace(" ", "").replace("'", ""),
        folder_name = "results/{dataset}/beast/{analysis}/chains",
        file_name = "{subsampling}.{dseed}.{bseed}",
        java =   lambda wildcards: _get_beast_param("java", wildcards), 
        jar =   lambda wildcards: _get_beast_param("jar", wildcards)
    log:
        "logs/beast_{dataset}_{analysis}_{subsampling}.{dseed}.{bseed}.txt"
    benchmark:
        "benchmarks/beast_{dataset}_{analysis}_{subsampling}.{dseed}.{bseed}.benchmark.txt"
    threads:
        lambda wildcards: _get_beast_param("threads", wildcards),
    resources:
        runtime = lambda wildcards: _get_beast_param("time", wildcards),
        mem_mb = lambda wildcards: _get_beast_param("mem_mb", wildcards)
    shell:
        """
        if test -f "{params.folder_name}/{params.file_name}.state" && test -f "{params.folder_name}/{params.file_name}.log  && test -f "{params.folder_name}/{params.file_name}.trees; then
            ACTION={params.action}
            scp {output.trace} {params.folder_name}/{params.file_name}.log 
            scp {output.trees} {params.folder_name}/{params.file_name}.trees
        else
            ACTION=overwrite
        fi

        mkdir -p {params.folder_name}
        
        {params.java} -jar {params.jar} -D aligned_fasta={input.aln} \
            -D demes="{params.demes}" \
            -D n_types="{params.n_types}" \
            -D mrs="{params.mrs}" \
            -D {params.model_params} \
            -D chain_length={params.length} \
            -D log_every={params.logevery} \
            -D file_name={params.folder_name}/{params.file_name} \
            -seed {wildcards.bseed} \
            -statefile "{params.folder_name}/{params.file_name}.state" \
            -java -$ACTION {input.xml} 2>&1 | tee -a {log}
        
        [ -f {params.folder_name}/{params.file_name}.log ] && mv {params.folder_name}/{params.file_name}.log {output.trace}
        [ -f {params.folder_name}/{params.file_name}.trees ] && mv {params.folder_name}/{params.file_name}.trees {output.trees} 
        """




def _get_trace_tocombine(wildcards):
    files = expand(
        "results/{{dataset}}/beast/{{analysis}}/chains/{{subsampling}}.{{dseed}}.{bseed}.f.log",
        bseed = BEAST_SEED)
    return files

rule combine_trace:
    message: 
        """
        Combine trace files: {input.trace_files} with LogCombiner v1.8.2.
        """
    input:
        trace_files = _get_trace_tocombine    
    output:
        combined_trace = "results/{dataset}/beast/{analysis}/{subsampling}.{dseed}.comb.log"
    log:
        "logs/combine_trace_{dataset}_{analysis}_{subsampling}.{dseed}.txt"
    benchmark:
        "benchmarks/combine_trace_{dataset}_{analysis}_{subsampling}.{dseed}.benchmark.txt"
    params:
        burnin = lambda wildcards: config["beast"][wildcards.analysis].get("burnin") or config["beast"].get("burnin"),
        input_command = lambda wildcards, input: " -log ".join(input) 
    shell:
        """
        logcombiner -log {params.input_command} -o {output.combined_trace} -b {params.burnin}  2>&1 | tee -a {log}
        """

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
